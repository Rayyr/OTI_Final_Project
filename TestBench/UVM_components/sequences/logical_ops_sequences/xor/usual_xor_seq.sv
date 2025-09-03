// !! NOTE : in logical ops in general we dont have edge cases so all of them are applicavle without any errors thats why i implement them in one sequence class !
import uvm_pkg::*;
`include "uvm_macros.svh"

class usual_xor_seq extends uvm_sequence#(bmu_sequence_item);
  
  //register the class into uvm factory
  `uvm_object_utils(usual_xor_seq)
 


  //overriden new()
  function new(string name ="usual_xor_seq");
    super.new(name);
  endfunction
  
  
  //task stimuls
  task body(); 
      
    //declare&initialize sequence_item ( packet , transaction .. )
    bmu_sequence_item seq=bmu_sequence_item::type_id::create("seq");
repeat(2) begin
 
  seq.ap.rand_mode(0);
  initialize_ap(seq.ap);
  seq.ap.lxor=1'b1;

 //a=223  b=5548   result = 5523  (pos)  error=0      (both + inputs) 
   seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0; seq.rst_l==1'b1;a_in==223;b_in==5548;}; 
     start_item(seq); 
     `uvm_info(get_type_name(), ("Standard XOring with both pos sign inputs "), UVM_NONE) ;
     finish_item(seq); 
  //  #10;
  
 
 //a=-9223  b=-548   result = 9765 (pos)  error=0      (both - inputs) 
    seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0; seq.rst_l==1'b1;a_in==-9223;b_in==-548;};
     start_item(seq); 
     `uvm_info(get_type_name(), ("Standard XOring with both neg sign inputs "), UVM_NONE) ;
     finish_item(seq); 
  //  #10;


     //a=-92233  b=23   result = -9280 (neg)  error=0      (+ & - inputs) 
    seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0; seq.rst_l==1'b1;a_in==-92233;b_in==23;};
     start_item(seq);
     `uvm_info(get_type_name(), ("Standard XOring with different signs inputs"), UVM_NONE) ;
     finish_item(seq);
   // #10;


    //a=101010...  b=01010..   result =-1 (neg)  error=0      (alternative inputs) 
    seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0; seq.rst_l==1'b1;a_in==32'b10101010101010101010101010101010;b_in==32'b01010101010101010101010101010101;};
     start_item(seq);
     `uvm_info(get_type_name(), ("Standard XOring with (101010...  &  010101....) inputs"), UVM_NONE) ;
     finish_item(seq);
   // #10;



    //a=10101...  b=10101..   result =0  error=0    (alternative same inputs) 
    seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0; seq.rst_l==1'b1;a_in==32'b10101010101010101010101010101010;b_in==32'b10101010101010101010101010101010;};
     start_item(seq);
     `uvm_info(get_type_name(), ("Standard XOring with (101010... ) inputs"), UVM_NONE) ;
     finish_item(seq);
    end
    
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

