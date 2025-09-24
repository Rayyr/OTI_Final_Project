// !! NOTE : in logical ops in general we dont have edge cases so all of them are applicavle without any errors thats why i implement them in one sequence class !

class usual_ctz_seq extends uvm_sequence #(bmu_sequence_item);
  
  //register the class into uvm factory
  `uvm_object_utils(usual_ctz_seq)
 


  //overriden new()
  function new(string name ="usual_ctz_seq");
    super.new(name);
  endfunction
  
  
  //task stimul
  task body(); 
      
    //declare&initialize sequence_item ( packet , transaction .. )
    bmu_sequence_item seq=bmu_sequence_item::type_id::create("seq");
 

   seq.ap.rand_mode(0); 
   initialize_ap(seq.ap);
   seq.ap.ctz=1'b1;

 
   `uvm_info(get_type_name(), ("Standard CTZ with 0's bits input"), UVM_NONE)   /// passed  ---even
   //a=0   result=32   DUT-result = 32    
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==0;seq.rst_l==1'b1;}; 
repeat(3) begin
   start_item(seq); //t=0
   finish_item(seq);//t=0
    //t=0 drives the inputs to DUT via driver (negedge) ------
    //t=5 sample the outputs from the dut via the monitor ( poedge)
end //0+5 ( neg+pos (driver and monitor))


 
    `uvm_info(get_type_name(), ("Standard CTZ with 1's bits input"), UVM_NONE) ///passed   --odd value
   //a=32'b1111...   result=0   DUT-result =0     /// passed
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==32'hffffffff;seq.rst_l==1'b1;}; 
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 


 
 

//since the other cases there is no clear pattern of how DUt make the counting so i will explicitly set up the patterns by bits ...
     `uvm_info(get_type_name(), ("Standard CTZ even value : a_in[0]=0 & a_in[1]=1 "), UVM_NONE) ///faild
   //a=32'bxxxxx...10 even with 1 trailing 0
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==32'h11111112;seq.rst_l==1'b1;}; 
      // $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq); 
   finish_item(seq);
end 
  

 

      `uvm_info(get_type_name(), ("Standard CTZ even value==least 2bits=0 Consecutive"), UVM_NONE) ///faild
   //a=32'bxxxxx....00
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==32'h12345f34;seq.rst_l==1'b1;}; 
//  $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
  



   `uvm_info(get_type_name(), ("Standard CTZ even value==least 3bit=0 (Consecutive)"), UVM_NONE) ///faild
   //a=32'bxxxxx....000
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==32'h12345f18;seq.rst_l==1'b1;}; 
 // $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
   




   `uvm_info(get_type_name(), ("Standard CTZ even value==least 4bit=0 (Consecutive)"), UVM_NONE) ///faild
   //a=32'bxxxxx....0000
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==32'h12345f10;seq.rst_l==1'b1;}; 
 // $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
   


   
   `uvm_info(get_type_name(), ("Standard CTZ even value==least 5bit=0 (Consecutive)"), UVM_NONE) ///faild
   //a=32'bxxxxx....00000
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==32'h12345f20;seq.rst_l==1'b1;}; 
 // $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
   



      `uvm_info(get_type_name(), ("Standard CTZ even value==least 6bit=0 (Consecutive)"), UVM_NONE) ///faild
   //a=32'bxxxxx....00000
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==32'h12345f40;seq.rst_l==1'b1;}; 
//  $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
   




   
      `uvm_info(get_type_name(), ("Standard CTZ even value==least 7bit=0 (Consecutive)"), UVM_NONE) ///faild
   //a=32'bxxxxx....00000
  
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==32'h12345f80;seq.rst_l==1'b1;}; 
 // $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
   





      `uvm_info(get_type_name(), ("Standard CTZ even value==least 8bit=0==1Byte (Consecutive)"), UVM_NONE) ///passed
   //a=32'bxxxxx....00000
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==32'h12345f00;seq.rst_l==1'b1;}; 
     //   $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
  



      `uvm_info(get_type_name(), ("Standard CTZ even value==least 16bit=0==2Byte (Consecutive)"), UVM_NONE) //faild
   //a=32'bxxxxx....00000
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==32'h12350000;seq.rst_l==1'b1;}; 
      //  $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
  




      `uvm_info(get_type_name(), ("Standard CTZ even value==least 9bit=0==1Byte (Consecutive)"), UVM_NONE) //faild
   //a=32'bxxxxx....00000
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in==32'h12345200;seq.rst_l==1'b1;}; 
      //  $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
   


 
   

/*
     `uvm_info(get_type_name(), ("Standard CTZ odd value least bit=1 msb=0"), UVM_NONE) //passed
   //a=odd value
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in[0]==1;a_in[31]==0;seq.rst_l==1'b1;}; 
    //  $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
   


        `uvm_info(get_type_name(), ("Standard CTZ odd value least bit=1 msb=1"), UVM_NONE) //passed
   //a=odd value
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in[0]==1 && a_in[31]==0;seq.rst_l==1'b1;}; 
    //  $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end */



        `uvm_info(get_type_name(), ("Standard CTZ with random odd input"), UVM_NONE) //aot all passed
   //a=odd value
   repeat(10) begin
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in[0]==1;seq.rst_l==1'b1;}; 
    //  $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
   end
   



    `uvm_info(get_type_name(), ("Standard CTZ with random even input"), UVM_NONE) //not all passed
   //a=even value
   repeat(10) begin
      seq.randomize() with { valid_in==1;csr_ren_in==1'b0;a_in[0]==0;seq.rst_l==1'b1;}; 
    //  $display("%b",seq.a_in);
repeat(3) begin
   start_item(seq);
   finish_item(seq);
end 
   end



      `uvm_info(get_type_name(), ("Standard CTZ with to test the all possipilties for 0's count (0-32)"), UVM_NONE) //only the power of 4 مضاعفات inputs passed 
for(int i=0;i<=32;i++)begin
     seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0;rst_l==1'b1;}; 
     seq.a_in=getVal(i);
repeat(3) begin
   start_item(seq); 
   finish_item(seq);
 end

end
 
 
  endtask
  
  
  //summary : from all cases i came up that the power of 4 مضاعفات passed but as i say its related to conequences zeroes ....
 
function logic[31:0] getVal(int count);

  logic [31:0] result = -1;//all bits =1
  int zeroes_added = 0;
  for (int i = 0; i < 32; i++) begin
    if (zeroes_added < count) begin
      result[i] = 0;
      zeroes_added++;
    end
  end
  return result;

  endfunction


//initilize the ap feilds to 0
task initialize_ap(output rtl_alu_pkt_t op);

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

endclass

