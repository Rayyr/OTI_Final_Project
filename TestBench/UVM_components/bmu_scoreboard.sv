class bmu_scoreboard extends uvm_scoreboard ;


bmu_sequence_item refPacket;//from reference model ( expected one ) 
bmu_sequence_item cmd_pipe[$];
 
    // Analysis port to connect to the monitor
uvm_analysis_imp #(bmu_sequence_item, bmu_scoreboard) exp;
 int unsigned latency = 1;

//register it into uvm factory
`uvm_component_utils(bmu_scoreboard)


//override new()
function new(string name="bmu_scoreboard",uvm_component parent);
super.new(name,parent);
this.refPacket=bmu_sequence_item::type_id::create("refPacket");
endfunction


//override build_phase()
function void build_phase(uvm_phase phase);
super.build_phase(phase);
exp=new("exp",this);
/*
    int unsigned tmp_latency;
        // Optional: allow overriding latency from test/env
    if (uvm_config_db#(int unsigned)::get(this, "", "latency", tmp_latency))
      latency = tmp_latency;*/
endfunction

//override write()
function void write(bmu_sequence_item actualPacket);
 
 //actualPacket : from DUT(via the Monitor)
   //  bmu_sequence_item in_tr;
    bmu_sequence_item prod;
    logic signed [31:0]  exp_res;
    bit   exp_err;

  
    
    initializeRefPacket(actualPacket,refPacket);
    cmd_pipe.push_back(refPacket);

  

    if (cmd_pipe.size() > 2) begin // here cmd_pipe stores the history of the inputs and outputs
     prod = cmd_pipe.pop_front(); // here we pop the front of the pipe
   //for the next seq. to delete the ones for the previous sequence .... since my latency is 3 cycles not 1 so .....
    cmd_pipe.pop_front();
    cmd_pipe.pop_front();
/*
      $display("ref-a=%0d",prod.a_in);
      $display("ref-b=%0d",prod.b_in);
      $display("res=%0d",prod.result_ff);*/

//compute the expected result based to my reference model 
      referenceModelBMU(prod,exp_res,exp_err);//or directlly we can modify the prod's result_ff pf course basd to valid_in since to the comments i wrote in the notepad**
      
      if(prod.valid_in==1) begin //there is no need dince the testbench is high level implenetation somehow so the results will ne available immediatlt but we perform the synch to get the correct dut outputs so the ptoblem not from scoreboard and this is is shown the 2 solutions i have uploaded in github by providing delays ......
        prod.result_ff=exp_res;
        prod.error=exp_err; end

      else begin //also it is entered in case of reset sequences
        prod.result_ff=0; 
        prod.error=0; end//that means currentlly we cant assign the result to ff since it is not valid in (logically)!
 /*
 $display(prod.ap);
 $display(actualPacket.ap);*/
  
      // here we check if the expected result is correct
      if ( (actualPacket.result_ff !==  prod.result_ff) || (actualPacket.error !=  prod.error) ) begin
        `uvm_info("fail",
          $sformatf("Mismatch: refA=%0d refB=%0d _________ dut_a=%0d dut_b=%0d ________ refResult=%0d/%0d _________ DUTResult=%0d/%0d\n\n\n",
                    prod.a_in, prod.b_in,  actualPacket.a_in ,actualPacket.b_in,prod.result_ff,  prod.error,
                    actualPacket.result_ff, actualPacket.error),UVM_LOW)
      end
      else `uvm_info("pass",
          $sformatf("Match: refA=%0d refB=%0d  _________ dut_a=%0d  dut_b=%0d _________ refResult=%0d/%0b _________ DUTResult=%0d/%0b\n\n\n",
                    prod.a_in, prod.b_in,  actualPacket.a_in ,actualPacket.b_in, prod.result_ff,  prod.error,
                    actualPacket.result_ff, actualPacket.error),UVM_LOW)
   end
  // else $display("hi");

endfunction


/*
//override run_phase()
task run_phase(uvm_phase phase);
super.run_phase(phase);

forever begin

 
 analysis_fifo.get(actualPacket);

 
initializeRefPacket(actualPacket,refPacket);
 

  referenceModelBMU(refPacket);

 
    
   if(if_equel(refPacket,actualPacket)==1'b1)begin  //matched :)
      //`uvm_info("pass", $sformatf(" ------ :: Match :: ------ "), UVM_LOW);//low : the verbosty levl  
      `uvm_info("pass", 
          $sformatf("A=%0d    B=%0d  Result=%0d   error=%b | RefA=%0d  RefB=%0d   RefResult=%0d   error=%b\n\n", 
                    actualPacket.a_in, actualPacket.b_in, actualPacket.result_ff,actualPacket.error, refPacket.a_in,
                    refPacket.b_in, refPacket.result_ff, refPacket.error),UVM_LOW)
   end
   else begin //not matched :(
   // `uvm_info("fail", $sformatf("------ :: Mismatch :: ------ "), UVM_LOW);//low : the verbosty levl 
    `uvm_info("fail", 
          $sformatf("A=%0d    B=%0d    Result=%0d    error=%b | RefA=%0d    RefB=%0d    RefResult=%0d    error=%b\n\n", 
                    actualPacket.a_in, actualPacket.b_in, actualPacket.result_ff,actualPacket.error, refPacket.a_in,
                    refPacket.b_in, refPacket.result_ff, refPacket.error),UVM_LOW)

   end
//$display("hello");
end


endtask
*/


function bit if_equel(bmu_sequence_item actualP,bmu_sequence_item refP);

//here only i check the output ports since oreviouslly once i poped the received transaction obj from the DUT ( atualP ) i initilize my refP with its input pots 
//then the variation between these 2 packets will be based to their output ports !!
if((actualP.result_ff=== refP.result_ff) && (actualP.error === refP.error))
// result=1'b1;//they are the same 
return 1'b1;
return 1'b0;


endfunction





function bit check_dont_care_inputs(bmu_sequence_item pck);
if((pck.rst_l===1'bx)||(pck.a_in===1'bx)||(refPacket.b_in===1'bx))
return 1'b1;
return 1'b0;
endfunction


//the reference model of my BMU
task referenceModelBMU(bmu_sequence_item refPacket,output logic signed [31:0]  exp_res,output bit er);

er=1'b0;
exp_res=32'b0;

 //logic signed [31:0] res;
 

 
//active low reset
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
exp_res=32'b0;
//no error since no operation !
er=1'b0;
end



//read from CSR register
else if (refPacket.csr_ren_in==1'b1) begin

//invalid 
 if (refPacket.ap  != 0) begin 
 //other feilds are being activated once !
 //based to reference model i make the reading op with the higheset pririty , iow if ap.sub=1 and read=1 then read will be 
 //be considered the base not the sub
 `uvm_error("bmu_scoreboard","illegal op feilds value while you are attemping to perform reading op with writing operation !!")
er=1'b1;
 end

else
 
exp_res=refPacket.csr_rddata_in;

end




//here we will implement the actual BMU logic !
else begin  

//the default , only they will be considered in case of invalid combination ( not defined op ), others it will be overridden
exp_res=32'b0;
er=1'b1;

//logical operations
//OR op
if(refPacket.ap.lor==1'b1 && refPacket.ap.zbb==0) begin

//invalid OR !
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>1) begin 
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
er=1'b0;
 end
 

//valid OR !
 else begin
exp_res=refPacket.a_in | refPacket.b_in;
er=1'b0;
 end

end//OR_op


//Inverted OR op
else if(refPacket.ap.lor==1'b1 && refPacket.ap.zbb==1'b1) begin

//invalid Inverted_OR !
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>2) begin // if(refPacket.lor && )
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
 er=1'b0;
 end

 

//valid Inverted_OR !
 else begin
exp_res=refPacket.a_in | ~refPacket.b_in;
er=1'b0;
 end

end//Inverted_OR_op



//XOR op
else if(refPacket.ap.lxor==1'b1 && refPacket.ap.zbb==1'b0) begin 

//invalid XOR !
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>2) begin 
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  er=1'b0;
 end

 

//valid XOR !
 else begin
exp_res=refPacket.a_in ^ refPacket.b_in;
er=1'b0;
 end

end//XOR_op




//Inverted_XOR op
else if(refPacket.ap.lxor==1'b1 && refPacket.ap.zbb==1'b1) begin 

//invalid Inverted_XOR !
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>2) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  er=1'b0;
 end

 
//valid Inverted_XOR !
 else begin
exp_res=refPacket.a_in ^ ~refPacket.b_in;
er=1'b0;
 end

end//Inverted_XOR_op



//shifting and masking operations
//SRL op
else if(refPacket.ap.srl==1'b1) begin 

//invalid SRL !
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>1) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
er=1'b0;
 end

 

//valid SRL !
 else begin
exp_res=refPacket.a_in >> refPacket.b_in[4:0];
er=1'b0;
 end

end//SRL_op




//SRA op
else if(refPacket.ap.sra==1'b1) begin 

//invalid SRA!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>1) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
er=1'b0;
 end

 

//valid SRA !
 else begin
exp_res=refPacket.a_in >>> refPacket.b_in[4:0];
er=1'b0;
 end

end//SRA_op





//ROR op
else if(refPacket.ap.ror==1'b1) begin 

//invalid ROR!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>1) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
 er=1'b0;
 end

 

//valid ROR !
 else begin
  for(int i=0;i<refPacket.b_in[4:0];i++) begin
        
        logic temp=refPacket.a_in[0];//LSB 
        refPacket.a_in=refPacket.a_in >> 1;//shift a to the right by 1 bit 
        refPacket.a_in[31]=temp;


  end
exp_res=refPacket.a_in ;
er=1'b0;
 end

end//ROR_op






//BINV op
else if(refPacket.ap.binv==1'b1) begin 

//invalid BINV!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>1) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
er=1'b0;
 end

 

//valid BINV !
else begin
refPacket.a_in[refPacket.b_in[4:0]]=~refPacket.a_in[refPacket.b_in[4:0]];
exp_res=refPacket.a_in ;
er=1'b0;
end

end//BINV_op





//SH2ADD op
else if(refPacket.ap.sh2add==1'b1 && refPacket.ap.zba==1'b1) begin 

//invalid SH2ADD!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>2) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
er=1'b0;
 end

 

//valid SH2ADD !
else begin 
refPacket.a_in = refPacket.a_in<<2;
 
exp_res=refPacket.a_in+refPacket.b_in ;
er=1'b0;

if(refPacket.a_in>0 && refPacket.b_in>0 && exp_res<0)
er=1'b1;

if(refPacket.a_in<0 && refPacket.b_in<0 && exp_res>0)
er=1'b1;
end
 
 end//SH2ADD_op

 




//arithmatic operations 
//SUB op (a-b)
//nust enable zba based to the table 
else if(refPacket.ap.sub==1'b1 && refPacket.ap.zba==1) begin 

/*
//invalid SUB!
 if (refPacket.ap.zba != 0) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feild ZBA value !")
er=1'b1;
 end
*/


//invalid
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>2) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
 er=1'b0;
 end

 

//valid SUB !
else begin
exp_res=refPacket.a_in - refPacket.b_in ;
er=1'b0;

if(refPacket.a_in>0 && refPacket.b_in<0 && exp_res<0) begin // (+) - (-) = (-) error!
er=1'b1;
$display("hi`");
end

if(refPacket.a_in<0 && refPacket.b_in>0 && exp_res>0) begin// (-) - (+) = (+) error!
er=1'b1;
$display("hi2");
end
end

$display("hi4");
 // (-) - (-) == (-) + (+) no error 
  // (+) - (+) no error 
 end//SUB_op





//Bit Manipulation
//SLT ( default is signed SLT)
else if(refPacket.ap.slt==1'b1 && refPacket.ap.sub==1'b1 && refPacket.ap.unsign==0) begin 

//invalid SLT signed!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>2) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
er=1'b0;
 end
 

//valid SLT signed!
else begin 
exp_res=refPacket.a_in < refPacket.b_in?32'h00000001:32'h00000000 ;
er=1'b0;
end
  
 end//SLT_op signed





//SLT unsigned
else if(refPacket.ap.slt==1'b1 && refPacket.ap.sub==1'b1 && refPacket.ap.unsign==1'b1) begin 

//invalid SLT unsigned!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>3) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
er=1'b0;
 end

 

//valid SLT unsigned!
else begin 
   er=1'b0;
/*
    if(refPacket.a_in[31]==refPacket.b_in[31]) begin //same MSP == same sign bit !
       refPacket.result_ff=refPacket.a_in < refPacket.b_in?32'h00000001:32'h00000000 ;
    end
    else begin //different sign bits 
      if(refPacket.a_in[31]==1'b1)// neg value then for sure a less than b
        refPacket.result_ff=32'h00000001;
      else 
       refPacket.result_ff=32'h00000000;

    end*/

   // refPacket= $unsigned(refPacket.a_in) < $unsigned(refPacket.b_in) ? 32'h00000001:32'h00000000;
    exp_res= ($unsigned(refPacket.a_in) < $unsigned(refPacket.b_in)) ? 32'h00000001 : 32'h00000000;


end
  
end//SLT_op unsigned





//CTZ
else if(refPacket.ap.ctz==1'b1) begin 

//invalid CTZ!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>1) begin
 //other feilds are being activated once !
  
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
er=1'b0;
 end

 

//valid CTZ!
else begin 
   er=1'b0;
    exp_res=count_trailing_zeroes(refPacket.a_in);
    //or simplly we cand make like this 
    //if(a[0]==1) result=0 else ctz(a);
end
  
end//CTZ_op



/*
//check it if we need to test it or not since it is not found in the specs !!!!!!!!!!!!
//CLZ
if(refPacket.ap.clz==1'b1) begin 

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

 
 */


//CPOP
else if(refPacket.ap.cpop==1'b1) begin

//invalid CPOP!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>1) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
   er=1'b0;
 end

 

//valid CPOP!
else begin 
  er=1'b0;
   exp_res=count_ones(refPacket.a_in);
end
  
end//CPOP_op





//siext_b
else if(refPacket.ap.siext_b==1'b1) begin 

//invalid siext_b!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>1) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
er=1'b0;
 end

 

//valid siext_b!
else begin 
   er=1'b0;
    //extract the a[7]
   // logic [23:0]a_23_0={24{refPacket.a_in[7]}};
  exp_res= {{24{refPacket.a_in[7]}},refPacket.a_in[7:0]};
end
  
end//siext_b_op
 





//MAX ( signed op ) 
else if(refPacket.ap.max==1'b1 && refPacket.ap.sub==1'b1) begin 


//invalid MAX!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>2) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
 
 er=1'b0;
 end

 

//valid MAX!
else begin 
    er=1'b0;
   exp_res= refPacket.a_in > refPacket.b_in ? refPacket.a_in : refPacket.b_in;
   
end
  
end//MAX_op





//Pack
else if(refPacket.ap.pack==1'b1 ) begin 

//invalid Pack!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>1) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  er=1'b0;
 end

 

//valid Pack!
else begin 
   er=1'b0;
   exp_res = {refPacket.b_in[15:0], refPacket.a_in[15:0]};
end
  
end//Pack_op





//grev
else if(refPacket.ap.grev==1'b1 ) begin 

//invalid grev!
//since ap is packed struct so we can use struct litreal {} symbol , otherwise if it is unpacked we cant!
 if ($countones(refPacket.ap)>1) begin
 //other feilds are being activated once !
 `uvm_error("bmu_scoreboard","illegal op feilds value since other feilds are bing activated once !")
  er=1'b0;
 end

 

//valid grev!
else begin 

   er=1'b0;

    if(refPacket.b_in[4:0] != 24) exp_res=32'b0;
    else 
    exp_res= {refPacket.a_in[7:0], refPacket.a_in[15:8], refPacket.a_in[23:16], refPacket.a_in[31:24]};
end
  
end//grev_op

 

else //other ops (not in in my group si i consider them as invalid ops )
begin
exp_res=0;
er=1;

end

end//all_operations


endtask






function int count_ones(logic signed [31:0] a);
integer count =0;

if(a==32'hffffffff) return 32 ;  // 32;

while(a!=32'b0)begin
if((a[0] & 32'h00000001) == 32'h00000001) 
count++;
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
op.lor=0;
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

//i make ternary operator to check x state 

  refP.a_in = has_unknown_bits(actualP.a_in) ? 0 : actualP.a_in;
  refP.b_in = has_unknown_bits(actualP.b_in) ? 0 : actualP.b_in;
  refP.rst_l = has_unknown_bits(actualP.rst_l) ? 0 : actualP.rst_l;
  refP.ap=actualP.ap;
  refP.valid_in = has_unknown_bits(actualP.valid_in) ? 0 : actualP.valid_in;
  refP.scan_mode = has_unknown_bits(actualP.scan_mode) ? 0 : actualP.scan_mode;
  refP.csr_rddata_in = has_unknown_bits(actualP.csr_rddata_in) ? 0 : actualP.csr_rddata_in;
  refP.csr_ren_in = has_unknown_bits(actualP.csr_ren_in) ? 0 : actualP.csr_ren_in;

return;

endfunction



function bit has_unknown_bits(input logic [31:0] data);
  return (|(^data === 1'bx));  // if reduction XOR is 'x', there's an unknown
endfunction



endclass