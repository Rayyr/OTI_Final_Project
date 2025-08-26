class bmu_scoreboard extends uvm_scoreboard ;


bmu_sequence_item refPacket;//from reference model ( expected one ) 
bmu_sequence_item actualPacket;//from DUT 
bmu_sequence_item qPackets[$];

//analysis port 
uvm_analysis_imp #(bmu_sequence_item,bmu_scoreboard) exp;


//register it into uvm factory
`uvm_component_utils(bmu_scoreboard);


//override new()
function new(string name="bmu_scoreboard",uvm_component parent);
super.new(name,parent);
this.refPacket=bmu_sequence_item::type_id::create("refPacket");
endfunction


//override build_phase()
function void build_phase(uvm_phase phase);
super.build_phase(phase);
exp=new("exp",this);
endfunction

//override write()
function void write(bmu_sequence_item seq);
qPackets.push_back(seq);
endfunction



//override run_phase()
task run_phase(uvm_phase phase);

super.run_phase(phase);

forever begin

wait(qPackets.size()!=0);
actualPacket=qPackets.pop_front();

//initialize the refPacket's inputs with the actual Packet ( from DUT ) 
initializeRefPacket(actualPacket,refPacket);
 

//i implenment the ref model using task since in function() They cannot have output or inout arguments. Only input arguments are allowed.
   referenceModelBMU(refPacket);


   output bit result;
   if(if_equel(refPacket,actualPacket,result)==1'b1)begin  //matched :)
      `uvm_info("pass", $sformatf("\033[32m ------ :: Match :: ------ \033[0m"), UVM_LOW);//low : the verbosty levl  
      `uvm_info("pass", 
          $sformatf("A=%0d    B=%0d    Result=%0d    error=%b | RefA=%0d    RefB=%0d    RefResult=%0d    error=%b", 
                    actualPacket.a_in, actualPacket.b_in, actualPacket.result_ff,actualPacket.error, refPacket.a_in,
                    refPacket.b_in, refPacket.result_ff, refPacket.error),UVM_LOW)
   end
   else begin //not matched :(
    `uvm_info("fail", $sformatf("\033[31m ------ :: Mismatch :: ------ \033[0m"), UVM_LOW);//low : the verbosty levl 
    `uvm_info("fail", 
          $sformatf("A=%0d    B=%0d    Result=%0d    error=%b | RefA=%0d    RefB=%0d    RefResult=%0d    error=%b", 
                    actualPacket.a_in, actualPacket.b_in, actualPacket.result_ff,actualPacket.error, refPacket.a_in,
                    refPacket.b_in, refPacket.result_ff, refPacket.error),UVM_LOW)

   end

end


endtask



task if_equel(bmu_sequence_item actualP,refP,bit output result);

result=1'b0;//they are not the same 

//here only i check the output ports since oreviouslly once i poped the received transaction obj from the DUT ( atualP ) i initilize my refP with its input pots 
//then the variation between these 2 packets will be based to their output ports !!
if((actualP.result_ff=== refP.result_ff) && (actualP.error === refP.error))
  result=1'b1;//they are the same 


endtask






//the reference model of my BMU
task referenceModelBMU(bmu_sequence_item refPacket);

 

if(refPacket.rst_l==0) begin 
//here we will reinitialize all the inputs to 0 ( or simply set them to 0 ) to avoid (x) values 
//inputs , thats why initially we need to make reset case before the actual one in order to make reinitilization as follow 
refPacket.a_in=32'b0;
refPacket.b_in=32'b0;
initializeAp(refPacket.ap);
refPacket.valid_in=1'b0;
refPacket.scan_mode=1'b0;
refPacket.csr_ren_in=1'b0;
refPacket.csr_rddata_in=32'b0;


//outputs
refPacket.result_ff=32'b0;
//no error since no operation !
refPacket.error=1'b0;
end

//here we will implement the actual BMU logic !
else begin : all_operations

//the default , only they will be considered in case of invalid combination ( not defined op ), others it will be overridden
refPacket.result_ff=32'b0;
refPacket.error=1'b1;

//logical operations
//OR op
if(refPacket.ap.lor==1'b1) begin:OR_op

//invalid OR !
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({lor:1, default:0})) != 0) begin 
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
refPacket.error=1'b0;
 end

//inavlid OR!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     //conflict !
      refPacket.error=1'b1;
 end

//valid OR !
 else begin
refPacket.result_ff=refPacket.a_in | refPacket.b_in;
refPacket.error=1'b0;
 end

end//OR_op


//Inverted OR op
if(refPacket.ap.lor==1'b1 && refPacket.ap.zbb==1'b1) begin: Inverted_OR_op

//invalid Inverted_OR !
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({lor:1, zbb:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  refPacket.error=1'b0;
 end

//inavlid Inverted_OR!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
      refPacket.error=1'b1;
 end

//valid Inverted_OR !
 else begin
refPacket.result_ff=refPacket.a_in | ~refPacket.b_in;
refPacket.error=1'b0;
 end

end//Inverted_OR_op



//XOR op
if(refPacket.ap.lxor==1'b1) begin: XOR_op

//invalid XOR !
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({lxor:1, default:0})) != 0) begin 
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  refPacket.error=1'b0;
 end

//inavlid XOR!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
      refPacket.error=1'b1;
 end

//valid XOR !
 else begin
refPacket.result_ff=refPacket.a_in ^ refPacket.b_in;
refPacket.error=1'b0;
 end

end//XOR_op




//Inverted_XOR op
if(refPacket.ap.lxor==1'b1 && refPacket.ap.zbb==1'b1) begin: Inverted_XOR_op

//invalid Inverted_XOR !
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({lxor:1, zbb:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  refPacket.error=1'b0;
 end

//inavlid Inverted_XOR!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
      refPacket.error=1'b1;
 end

//valid Inverted_XOR !
 else begin
refPacket.result_ff=refPacket.a_in ^ ~refPacket.b_in;
refPacket.error=1'b0;
 end

end//Inverted_XOR_op



//shifting and masking operations
//SRL op
if(refPacket.ap.srl==1'b1) begin: SRL_op

//invalid SRL !
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({srl:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
refPacket.error=1'b0;
 end

//inavlid SRL !
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     refPacket.error=1'b1;
 end

//valid SRL !
 else begin
refPacket.result_ff=refPacket.a_in >> refPacket.b_in[4:0];
refPacket.error=1'b0;
 end

end//SRL_op




//SRA op
if(refPacket.ap.sra==1'b1) begin: SRA_op

//invalid SRA!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({sra:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
 refPacket.error=1'b0;
 end

//inavlid SRA !
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
      refPacket.error=1'b1;
 end

//valid SRA !
 else begin
refPacket.result_ff=refPacket.a_in >>> refPacket.b_in[4:0];
refPacket.error=1'b0;
 end

end//SRA_op





//ROR op
if(refPacket.ap.ror==1'b1) begin: ROR_op

//invalid ROR!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({ror:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  refPacket.error=1'b0;
 end

//inavlid ROR !
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     refPacket.error=1'b1;
 end

//valid ROR !
 else begin
  for(int i=0;i<refPacket.b_in[4:0];i++) begin
        
        bit temp=refPacket.a_in[0];//LSB 
        refPacket.a_in=refPacket.a_in >> 1;//shift a to the right by 1 bit 
        refPacket.a_in[31]=temp;


  end
refPacket.result_ff=refPacket.a_in ;
refPacket.error=1'b0;
 end

end//ROR_op






//BINV op
if(refPacket.ap.binv==1'b1) begin: BINV_op

//invalid BINV!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({binv:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
refPacket.error=1'b0;
 end

//inavlid BINV!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     refPacket.error=1'b1;
 end

//valid BINV !
else begin
refPacket.a_in[refPacket.b_in[4:0]]=~refPacket.a_in[refPacket.b_in[4:0]];
refPacket.result_ff=refPacket.a_in ;
refPacket.error=1'b0;
end

end//BINV_op





//SH2ADD op
if(refPacket.ap.sh2add==1'b1 && refPacket.ap.zba==1'b1) begin: SH2ADD_op

//invalid SH2ADD!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({sh2add:1,zba=1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  refPacket.error=1'b0;
 end

//inavlid SH2ADD!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     refPacket.error=1'b1;
 end

//valid SH2ADD !
else begin 
refPacket.result_ff=(refPacket.a_in<<2)+refPacket.b_in ;
refPacket.error=1'b0;

if(refPacket.a_in>0 && refPacket.b_in>0 && refPacket.result_ff<0)
refPacket.error=1'b1;

if(refPacket.a_in<0 && refPacket.b_in<0 && refPacket.result_ff>0)
refPacket.error=1'b1;
end
 
 end//SH2ADD_op

 




//arithmatic operations 
//SUB op (a-b)
if(refPacket.ap.sub==1'b1) begin: SUB_op

//invalid SUB!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({sub:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  refPacket.error=1'b0;
 end

//inavlid SUB!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
      refPacket.error=1'b1;
 end

//valid SUB !
else begin
refPacket.result_ff=refPacket.a_in - refPacket.b_in ;
refPacket.error=1'b0;

if(refPacket.a_in>0 && refPacket.b_in<0 && refPacket.result_ff<0) // (+) - (-) = (-) error!
refPacket.error=1'b1;

if(refPacket.a_in<0 && refPacket.b_in>0 && refPacket.result_ff>0) // (-) - (+) = (+) error!
refPacket.error=1'b1;
end

 // (-) - (-) == (-) + (+) no error 
  // (+) - (+) no error 
 end//SUB_op





//Bit Manipulation
//SLT ( default is signed SLT)
if(refPacket.ap.slt==1'b1 && refPacket.ap.sub==1'b1) begin: SLT_op_SIGNED

//invalid SLT signed!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({slt:1,sub=1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  refPacket.error=1'b0;
 end

//inavlid SLT signed!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
      refPacket.error=1'b1;
 end

//valid SLT signed!
else begin 
refPacket.result_ff=refPacket.a_in < refPacket.b_in?32'h00000001:32'h00000000 ;
refPacket.error=1'b0;
end
  
 end//SLT_op signed





//SLT unsigned
if(refPacket.ap.slt==1'b1 && refPacket.ap.sub==1'b1 && refPacket.ap.unsign==1'b1) begin: SLT_op_UNSIGNED

//invalid SLT unsigned!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({slt:1,sub=1,unsign=1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
refPacket.error=1'b0;
 end

//inavlid SLT unsigned!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     refPacket.error=1'b1;
 end

//valid SLT unsigned!
else begin 
    refPacket.error=1'b0;

    if(refPacket.a_in[31]==refPacket.b_in[31]) begin //same MSP == same sign bit !
       refPacket.result_ff=refPacket.a_in < refPacket.b_in?32'h00000001:32'h00000000 ;
    end
    else begin //different sign bits 
      if(refPacket.a_in[31]==1'b1)// neg value then for sure a less than b
        refPacket.result_ff=32'h00000001;
      else 
       refPacket.result_ff=32'h00000000;

    end

end
  
end//SLT_op unsigned





//CTZ
if(refPacket.ap.ctz==1'b1) begin: CTZ_op

//invalid CTZ!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({ctz:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
refPacket.error=1'b0;
 end

//inavlid CTZ!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     refPacket.error=1'b1;
 end

//valid CTZ!
else begin 
    refPacket.error=1'b0;
    refPacket.result_ff=count_trailing_zeroes(refPacket.a_in);
end
  
end//CTZ_op




//check it if we need to test it or not since it is not found in the specs !!!!!!!!!!!!
//CLZ
if(refPacket.ap.clz==1'b1) begin: CLZ_op

//invalid CLZ!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({clz:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
refPacket.error=1'b0;
 end

//inavlid CLZ!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     refPacket.error=1'b1;
 end

//valid CLZ!
else begin 
    refPacket.error=1'b0;
    refPacket.result_ff=count_leading_zeroes(refPacket.a_in);
end
  
end//CLZ_op

 
 


//CPOP
if(refPacket.ap.cpop==1'b1) begin: CPOP_op

//invalid CPOP!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({cpop:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
   refPacket.error=1'b0;
 end

//inavlid CPOP!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
       refPacket.error=1'b1;
 end

//valid CPOP!
else begin 
    refPacket.error=1'b0;
    refPacket.result_ff=count_ones(refPacket.a_in);
end
  
end//CPOP_op





//siext_b
if(refPacket.ap.siext_b==1'b1) begin: siext_b_op

//invalid siext_b!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({siext_b:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
 refPacket.error=1'b0;
 end

//inavlid siext_b!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     refPacket.error=1'b1;
 end

//valid siext_b!
else begin 
    refPacket.error=1'b0;
    //extract the a[7]
    logic [23:0]a_23_0={24{refPacket.a_in[7]}};
    refPacket.result_ff= {a_23_0,refPacket.a_in[7:0]};
end
  
end//siext_b_op
 





//MAX ( signed op ) 
if(refPacket.ap.max==1'b1 && refPacket.ap.sub==1'b1 && refPacket.ap.zbb=1'b1) begin: MAX_op

//invalid MAX!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({max:1,sub=1,zbb=1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  refPacket.error=1'b0;
 end

//inavlid MAX!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     refPacket.error=1'b1;
 end

//valid MAX!
else begin 
    refPacket.error=1'b0;
    refPacket.result_ff= refPacket.a_in > refPacket.b_in ? refPacket.a_in : refPacket.b_in;
end
  
end//MAX_op





//Pack
if(refPacket.ap.pack==1'b1 ) begin: Pack_op

//invalid Pack!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({pack:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  refPacket.error=1'b0;
 end

//inavlid Pack!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     refPacket.error=1'b1;
 end

//valid Pack!
else begin 
    refPacket.error=1'b0;
    refPacket.result_ff= {refPacket.b_in[15:0], refPacket.a_in[15:0]};
end
  
end//Pack_op





//grev
if(refPacket.ap.grev==1'b1 ) begin: grev_op

//invalid grev!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ((refPacket.ap & ~'({grev:1, default:0})) != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  refPacket.error=1'b0;
 end

//inavlid grev!
 else if (refPacket.csr_ren_in!=1'b0) begin
     `uvm_error("bmu_scoreboard","illegal : csr_ren_in must =0 not 1 !")
     refPacket.error=1'b1;
 end

//valid grev!
else begin 

    refPacket.error=1'b0;

    if(refPacket.b_in != 24) refPacket.result_ff=32'b0;
    else 
    refPacket.result_ff= {refPacket.a_in[7:0], refPacket.a_in[15:8], refPacket.a_in[23:16], refPacket.a_in[31:24]};
end
  
end//grev_op

 

end//all_operations


endtask






function int count_ones(logic signed [31:0] a);
integer count =0;

if(a==32'hffffffff) return 32 ;  // 32;

while(a!=32'b0)begin
if((a>>1 & 32'h00000001) == 32'h00000001) count++;
a=a>>1;
end

return count;
endfunction








function int count_trailing_zeroes(logic signed [31:0] a);
integer count =0;

if(a==32'b0) return 32 ;  // 32;

for( ; (a & 32'h00000001 )==32'h00000000; a=a>>1) begin //perform masking to fetch out the LSB in each time 
  count++;
end 

return count;
endfunction




function int count_leading_zeroes(logic signed [31:0] a);
integer count =0;

if(a==32'b0) return 32 ;  // 32;

for( ; (a & 32'h80000000 )==32'h00000000; a=a<<1) begin //perform masking to fetch out the MSB in each time 
  count++;
end 

return count;
endfunction




//initilizae the ap for the refPacket in case we make reset activated 
task initializeAp(output rtl_alu_pkt_t op);

op.clz=0;
op.ctz=0;
op.cpop=0;
op.siext_b=0;
op.siext_h=0;
op.min=0;
op.max=0;
op.pack=0;
op.packu=0;
op.packh=0;
op.rol=0;
op.ror=0;
op.grev=0;
op.gorc=0;
op.zbb=0;
op.bset=0;
op.bclr=0;
op.binv=0;
op.bext=0;
op.sh1add=0;
op.sh2add=0;
op.sh3add=0;
op.zba=0;
op.land=0;
op.lol=0;
op.lxor=0;
op.sll=0;
op.srl=0;
op.sra=0;
op.beq=0;
op.bne=0;
op.blt=0;
op.bge=0;
op.add=0;
op.sub=0;
op.slt=0;
op.unsign=0;
op.jal=0;
op.predict_t=0;
op.predict_nt=0;
op.csr_write=0;
op.csr_imm=0;


endtask



//this function will initialize the refpacket'inputs based to the actualP ones which it comes from DUT to calculate the output baed to my referene model
function void initializeRefPacket(bmu_sequence_item actualP,bmu_sequence_item refP);

  refP.a_in=actualP.a_in;
  refP.b_in=actualP.b_in;
  refP.rst_l=actualP.rst_l;
  refP.ap=actualP.ap;
  refP.valid_in=actualP.valid_in;
  refP.scan_mode=actualP.scan_mode;
  refP.csr_ren_in=actualP.csr_ren_in;
  refP.csr_rddata_in=actualP.csr_rddata_in;

  return;

endfunction


endclass