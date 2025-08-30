// !! NOTE : in logical ops in general we dont have edge cases so all of them are applicavle without any errors thats why i implement them in one sequence class !

class usual_sub_seq extends uvm_sequence #(bmu_sequence_item);
  
  //register the class into uvm factory
  `uvm_object_utils(usual_sub_seq)
 


  //overriden new()
  function new(string name ="usual_sub_seq");
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
   seq.ap.sub=1'b1;
 
 
 //both inputs are + ( usual case without overflow )
   seq.randomize() with { csr_ren_in==1'b0;a_in==32'h00000064; b_in==32'h0000003C;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard SUB with a_in=100 , b_in=60 usual case without overflow/underflow"), UVM_NONE) 
   finish_item(seq); 

 




 
 //both inputs are - ( usual case without underflow )
   seq.randomize() with { csr_ren_in==1'b0;a_in==32'hFFFFF6E6; b_in==32'hFFF9E569;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard SUB with a_in=-2330 , b_in=-400023 usual case without overflow/underflow"), UVM_NONE) 
   finish_item(seq); 






 //neg and pos inputs ( usual case without underflow )
   seq.randomize() with { csr_ren_in==1'b0;a_in==32'h0001B563; b_in==32'hFEAD084C;}; 
   start_item(seq); 
   `uvm_info(get_type_name(), ("Standard SUB with a_in=112035 , b_in=-22223044 usual case without overflow/underflow"), UVM_NONE) 
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

