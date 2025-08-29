// !! NOTE : in logical ops in general we dont have edge cases so all of them are applicavle without any errors thats why i implement them in one sequence class !

class usual_slt_seq extends uvm_sequence #(bmu_sequence_item);
  
  //register the class into uvm factory
  `uvm_object_utils(usual_slt_seq)
 


  //overriden new()
  function new(string name ="usual_slt_seq");
    super.new(name);
  endfunction
  
  
  //task stimul
  task body(); 
      
    //declare&initialize sequence_item ( packet , transaction .. )
    bmu_sequence_item seq=bmu_sequence_item::type_id::create("seq");


 //disable the Reset signal for the test of test cases 
    seq.rst_l.constraint_mode(0);
    seq.rst_l=1'b1;
 

 
   seq.ap.costraint_mode(0); 
   initialize_ap(seq.ap);

   //signed slt with random inputs
   seq.ap.slt=1'b1;
   //there is no need since it is initilized in the previous function
   //seq.ap.unsign=1'b0;
   seq.ap.sub=1'b1;
 
   seq.randomize() with { csr_ren_in==1'b0;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard Signed SLT random inputs"), UVM_NONE) 
   finish_item(seq); 

 



    //signed slt with a=-120 , b=-10  ( neg values ) result=1
   seq.randomize() with { csr_ren_in==1'b0;a_in==32'hFFFFFF88; b_in==32'hFFFFFFF6;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard Signed SLT both neg inputs"), UVM_NONE) 
   finish_item(seq); 




    //signed slt with a=33 , b=52  ( pos values )  result=0
   seq.randomize() with { csr_ren_in==1'b0;a_in==32'h00000021; b_in==32'h00000034;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard Signed SLT both pos inputs"), UVM_NONE) 
   finish_item(seq); 




    //signed slt with a=150 , b=-200  (different signs )  result=0
   seq.randomize() with { csr_ren_in==1'b0;a_in==32'h00000096; b_in==32'hFFFFFF38;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard Signed SLT different signs inputs"), UVM_NONE) 
   finish_item(seq); 



    //signed slt with same inputs = 150 result=0
   seq.randomize() with { csr_ren_in==1'b0;a_in==32'h00000096;b_in==32'h00000096;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard Unsigned SLT"), UVM_NONE) 
   finish_item(seq);



    //unsigned slt with random inputs
   seq.ap.unsign=1'b1;
   seq.randomize() with { csr_ren_in==1'b0;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard Unsigned SLT random inputs"), UVM_NONE) 
   finish_item(seq); 



   //unsigned slt with a=210 , b=96  ( pos values)  result=0
   seq.ap.unsign=1'b1;
   seq.randomize() with { csr_ren_in==1'b0;a_in==32'h000000D2;b_in==32'h00000060;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard Unsigned SLT"), UVM_NONE) 
   finish_item(seq); 



 
   //unsigned slt with a=-100 , b=-90  ( neg values)  result=0
   seq.ap.unsign=1'b1;
   seq.randomize() with { csr_ren_in==1'b0;a_in==32'hFFFFFF9C;b_in==32'hFFFFFFA6;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard Unsigned SLT"), UVM_NONE) 
   finish_item(seq);



    //unsigned slt with a=-100 , b=90  ( different signs )  result=0
   seq.ap.unsign=1'b1; 
   seq.randomize() with { csr_ren_in==1'b0;a_in==32'hFFFFFF9C;b_in==32'h0000005A;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard Unsigned SLT"), UVM_NONE) 
   finish_item(seq);


    //unsigned slt with same inputs = -100 result=0
   seq.ap.unsign=1'b1; 
   seq.randomize() with { csr_ren_in==1'b0;a_in==32'hFFFFFF9C;b_in==32'hFFFFFF9C;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard Unsigned SLT"), UVM_NONE) 
   finish_item(seq);
 
    
  endtask
  
  




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

endclass

