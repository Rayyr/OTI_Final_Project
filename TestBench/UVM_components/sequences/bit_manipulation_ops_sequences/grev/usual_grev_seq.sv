// !! NOTE : in logical ops in general we dont have edge cases so all of them are applicavle without any errors thats why i implement them in one sequence class !

class usual_grev_seq extends uvm_sequence #(bmu_sequence_item);
  
  //register the class into uvm factory
  `uvm_object_utils(usual_grev_seq)
 


  //overriden new()
  function new(string name ="usual_grev_seq");
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
   seq.ap.grev=1'b1;
 


    `uvm_info(get_type_name(), ("Standard GREV with a_in=0 "), UVM_NONE) //passed
repeat(3) begin
//a_in=0  result=0
   seq.randomize() with {valid_in==1;csr_ren_in==1'b0;b_in[4:0]==5'b11000;a_in==32'h00000000;}; 
   start_item(seq); 
   finish_item(seq); 
end



   `uvm_info(get_type_name(), ("Standard GREV with a_in=1's bits"), UVM_NONE) ///passed
repeat(3) begin
//a_in=1's bits   result=-1
   seq.randomize() with {valid_in==1;csr_ren_in==1'b0;b_in[4:0]==5'b11000;a_in==32'hffffffff;}; 
   start_item(seq); 
   finish_item(seq); 
end

 


   `uvm_info(get_type_name(), ("Standard GREV with alternative-input (a_in) (1010...)"), UVM_NONE) //passed
repeat(3) begin
  //a_in=101010(alternative input)(MSB=1)
   seq.randomize() with {valid_in==1;csr_ren_in==1'b0;a_in==32'b10101010101010101010101010101010;b_in[4:0]==5'b11000;}; 
   start_item(seq); 
   finish_item(seq);
end




   `uvm_info(get_type_name(), ("Standard GREV with alternative-input (a_in) (0101...)"), UVM_NONE) //passed
repeat(3) begin
   //a_in=0101010101(alternative input)(MSB=0)
   seq.randomize() with {valid_in==1;csr_ren_in==1'b0;a_in==32'b01010101010101010101010101010101;b_in[4:0]==5'b11000;}; 
   start_item(seq); 
   finish_item(seq);
end



   `uvm_info(get_type_name(), ("Standard GREV with 000055fa input MS 2 Bytes=0"), UVM_NONE) //faild
repeat(3) begin
    seq.randomize() with {valid_in==1;csr_ren_in==1'b0;a_in==32'h000055fa;b_in[4:0]==5'b11000;}; 
   start_item(seq); 
   finish_item(seq);
end




   `uvm_info(get_type_name(), ("Standard GREV with f0400000 input LS 2 Bytes=0"), UVM_NONE) //faild
repeat(3) begin
    seq.randomize() with {valid_in==1;csr_ren_in==1'b0;a_in==32'hf0400000;b_in[4:0]==5'b11000;}; 
   start_item(seq); 
   finish_item(seq);
end



 


   `uvm_info(get_type_name(), ("Standard GREV with symmetry input (2 by 2 bytes == 'h2410_2410)"), UVM_NONE) //faild    reveres the complete 4 bytes 
repeat(2) begin
        seq.randomize() with {valid_in==1;csr_ren_in==1'b0;a_in[31:16]==a_in[15:0];b_in[4:0]==5'b11000;}; 
repeat(3) begin
    start_item(seq); 
   finish_item(seq);
end
end


 

   `uvm_info(get_type_name(), ("Standard GREV with same input bytes(f0f0f0f0)"), UVM_NONE) //passed   
repeat(2) begin
       seq.randomize() with {valid_in==1;csr_ren_in==1'b0;a_in[7:0]== a_in[15:8];a_in[7:0]== a_in[23:16]; a_in[7:0] == a_in[31:24];b_in[4:0]==5'b11000;}; 
repeat(3) begin
    start_item(seq); 
   finish_item(seq);
end
end


 


   `uvm_info(get_type_name(), ("Standard GREV with symmetry input ( 1 by 1 byte == 'h23f0_f023)"), UVM_NONE) //faild   reveres the complete 4 bytes 
repeat(2) begin
       seq.randomize() with {valid_in==1;csr_ren_in==1'b0;a_in[7:0]== a_in[31:24];a_in[15:8]== a_in[23:16];b_in[4:0]==5'b11000;}; 
repeat(3) begin
    start_item(seq); 
   finish_item(seq);
end
end

 
 
  
  endtask
  
//summary : the dut grev reverse each 2 bytes !  




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

