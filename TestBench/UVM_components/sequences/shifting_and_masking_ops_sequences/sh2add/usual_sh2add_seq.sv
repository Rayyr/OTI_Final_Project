// !! NOTE : in logical ops in general we dont have edge cases so all of them are applicavle without any errors thats why i implement them in one sequence class !

class usual_sh2add_seq extends uvm_sequence #(bmu_sequence_item);
  
  //register the class into uvm factory
  `uvm_object_utils(usual_sh2add_seq)
 


  //overriden new()
  function new(string name ="usual_sh2add_seq");
    super.new(name);
  endfunction
  
  
  //task stimul
  task body(); 
      
    //declare&initialize sequence_item ( packet , transaction .. )
    bmu_sequence_item seq=bmu_sequence_item::type_id::create("seq");


 //disable the Reset signal for the test of test cases 
    seq.rst_l.rand_mode(0);
    seq.rst_l=1'b1;
 

 
   seq.ap.rand_mode(0); 
   initialize_ap(seq.ap);
   seq.ap.sh2add=1'b1;
   seq.ap.zba=1'b1;
 
  

//add random seq , neg and pos afters shift

   `uvm_info(get_type_name(), ("Standard SH2ADD with a_in&b_in=0 inputs"), UVM_NONE) //passed
repeat(3) begin
//a_in=0 & b_in=0
   seq.randomize() with {valid_in==1;csr_ren_in==1'b0;b_in==32'h00000000;a_in==32'h00000000;}; 
   start_item(seq); 
   finish_item(seq); 
end




   `uvm_info(get_type_name(), ("Standard SH2ADD with a_in=b_in 1's bits inputs"), UVM_NONE) //passed
repeat(3) begin
//a_in=1's bits & b_in=1's bits  ,  no overflow , result = -5 
   seq.randomize() with {valid_in==1; csr_ren_in==1'b0;b_in==32'hffffffff;a_in==32'hffffffff;}; 
   start_item(seq); 
   finish_item(seq); 
end





   `uvm_info(get_type_name(), ("Standard SH2ADD with a_in=0 and b_in=random_value"), UVM_NONE) //passed
      seq.randomize() with {valid_in==1;csr_ren_in==1'b0;a_in==32'h00000000;}; 
repeat(3) begin
//a_in=0 & b_in=any value  , result remains b , no error
   start_item(seq); 
   finish_item(seq); 
end
 


 
    `uvm_info(get_type_name(), ("Standard SH2ADD with a_in=random value and b_in=0"), UVM_NONE) //passed
       seq.randomize() with { valid_in==1;csr_ren_in==1'b0;b_in==32'h00000000;}; 
repeat(3) begin
//a_in=any value & b_in=0  , result remains a<<2 , no error
   start_item(seq); 
   finish_item(seq); 
end






   `uvm_info(get_type_name(), ("Standard SH2ADD with a_in and b_in=max value"), UVM_NONE) //passsed
repeat(3) begin
//a_in=max & b_in=max  ,  no error , since (-) + (+)  A(0x7fffffff) + B(0x7fffffff)  , result=-4+max
   seq.randomize() with {valid_in==1;csr_ren_in==1'b0;b_in==32'h7FFFFFFF;a_in==32'h7FFFFFFF;}; 
   start_item(seq); 
   finish_item(seq); 
end






   `uvm_info(get_type_name(), ("Standard SH2ADD with a_in and b_in=min value"), UVM_NONE) //passed
repeat(3) begin
//a_in=min & b_in=min  ,no error since (+) + (-) , result = b (0+b) , A(0x80000000) + B(0x80000000) 
   seq.randomize() with {valid_in==1;csr_ren_in==1'b0;b_in==32'h80000000;a_in==32'h80000000;}; 
   start_item(seq); 
   finish_item(seq); 
end






   `uvm_info(get_type_name(), ("Standard SH2ADD with a_in=non-zero value in this form (32'bxx1xxx...) and b_in=max value"), UVM_NONE) //passed
      seq.randomize() with {valid_in==1;csr_ren_in==1'b0;b_in==32'h7FFFFFFF;(a_in!=0 && a_in[29]==1'b1);}; 
repeat(3) begin
//a_in=any non-zero value (32’bxx1xxx...) & b_in=max  no overflow nor underflow since (+) + (-) = (+) always since b is max only in one case if a is min value so the result =-1 only  
   start_item(seq); 
   finish_item(seq); 
end







   `uvm_info(get_type_name(), ("Standard SH2ADD with a_in=non-zero value in this form (32'bxx0xxx...) and b_in=min value"), UVM_NONE) //passed
      seq.randomize() with {valid_in==1;csr_ren_in==1'b0;b_in==32'h80000000;(a_in!=0 && a_in[29]==1'b0);}; 
repeat(3) begin
//a_in=any non-zero value (32’bxx0xxx...) & b_in=min  , min  no overflow nor underflow since (-) + (+) = (+) always since b is min only in one case if a is max value so the result =-1 only
   start_item(seq); 
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

