// !! NOTE : in logical ops in general we dont have edge cases so all of them are applicavle without any errors thats why i implement them in one sequence class !
 import uvm_pkg::*;
`include "uvm_macros.svh"

class usual_cpop_seq extends uvm_sequence#(bmu_sequence_item);
  
  //register the class into uvm factory
  `uvm_object_utils(usual_cpop_seq)
 


  //overriden new()
  function new(string name ="usual_cpop_seq");
    super.new(name);
  endfunction
  
  
  //task stimul
  task body(); 
      
    //declare&initialize sequence_item ( packet , transaction .. )
    bmu_sequence_item seq=bmu_sequence_item::type_id::create("seq");
 

    seq.ap.rand_mode(0);
    initialize_ap(seq.ap);
    seq.ap.cpop=1'b1;   


   
 
    //a_in=101010(alternative input)  result=32/2     DUT-result=8   ///faild
      `uvm_info(get_type_name(), ("Standard CPOP with alternative-input(1010...)"), UVM_NONE) 
repeat(3) begin
     seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0;a_in==32'hAAAAAAAA;rst_l==1'b1;}; 
   start_item(seq); 
   finish_item(seq);
 end


     //a_in=0101(alternative input)  result=32/2     DUT-result=8   ///faild
      `uvm_info(get_type_name(), ("Standard CPOP with alternative-input(0101...)"), UVM_NONE) 
repeat(3) begin
     seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0;a_in==32'h55555555;rst_l==1'b1;}; 
   start_item(seq); 
   finish_item(seq);
 end


    `uvm_info(get_type_name(), ("Standard CPOP with 1's bits input"), UVM_NONE) //faild
      //a_in=32'b11111...  result=32     DUT-result=16(max)
 repeat(3)begin
   start_item(seq); 
   seq.randomize() with {rst_l==1;valid_in==1'b1;csr_ren_in==1'b0;a_in==32'hffffffff;}; 
   finish_item(seq);
end




    `uvm_info(get_type_name(), ("Standard CPOP with 0's bits input"), UVM_NONE) //passed
      //a_in=32'b000000...  result=0    DUT-result=0
 repeat(3)begin
   start_item(seq); 
   seq.randomize() with {rst_l==1;valid_in==1'b1;csr_ren_in==1'b0;a_in==32'h00000000;}; 
   finish_item(seq);
end


 

    //a_in=ffff0000  result=16     DUT-result=0   ///faild
      `uvm_info(get_type_name(), ("Standard CPOP with MS 2 Bytes=1's bits(ffff0000) input"), UVM_NONE) 
           seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0;a_in==32'hffff0000;rst_l==1'b1;}; 
repeat(3) begin
   start_item(seq); 
   finish_item(seq);
 end


     //a_in=0000ffff  result=16     DUT-result=16   ///passed
      `uvm_info(get_type_name(), ("Standard CPOP with LS 2 Bytes=1's(0000ffff) bits input"), UVM_NONE) 
      seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0;a_in==32'h0000ffff;rst_l==1'b1;}; 
repeat(3) begin
   start_item(seq); 
   finish_item(seq);
 end
   



        //a_in=0000fff0  result=12     DUT-result=12   ///passed
      `uvm_info(get_type_name(), ("Standard CPOP with LS 2 Bytes= (0000fff0) bits input"), UVM_NONE) 
      seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0;a_in==32'h0000fff0;rst_l==1'b1;}; 
repeat(3) begin
   start_item(seq); 
   finish_item(seq);
 end


         //a_in=1f900000  result=7     DUT-result=0   ///faild
      `uvm_info(get_type_name(), ("Standard CPOP with MS 2bytes =(1f900000)input"), UVM_NONE) 
      seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0;a_in==32'h1f900000;rst_l==1'b1;}; 
repeat(3) begin
   start_item(seq); 
   finish_item(seq);
 end



          //a_in=1f900010  result=8     DUT-result=1   ///faild
   `uvm_info(get_type_name(), ("Standard CPOP with (1f900010) mixed 1's bits in the MS2Bytes & LS2Bytes input"), UVM_NONE) 
      seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0;a_in==32'h1f900010;rst_l==1'b1;}; 
repeat(3) begin
   start_item(seq); 
   finish_item(seq);
 end


/*
//special direct test
          //a_in=1f900010  result=8     DUT-result=1   ///faild
   `uvm_info(get_type_name(), ("Standard CPOP with 10 1`s"), UVM_NONE) 
      seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0;a_in==32'b00000000000000000000001111111111;rst_l==1'b1;}; 
repeat(3) begin
   start_item(seq); 
   finish_item(seq);
 end

 */

   `uvm_info(get_type_name(), ("Standard CPOP with to test the all possipilties for 1's count (0-32)"), UVM_NONE) 
for(int i=0;i<=32;i++)begin
     seq.randomize() with { valid_in==1'b1;csr_ren_in==1'b0;rst_l==1'b1;$countones(a_in)==i;}; 
     //seq.a_in=getVal(i);
repeat(3) begin
   start_item(seq); 
   finish_item(seq);
 end

end

    
  endtask
  
  
  function logic[31:0] getVal(int count);


  logic [31:0] result = 0;
  int ones_added = 0;
  for (int i = 0; i < 32; i++) begin
    if (ones_added < count) begin
      result[i] = 1;
      ones_added++;
    end
  end
  return result;

  endfunction


//summary : the dut cpop() only counts in the Least significant 2 bytes so at most the counter=16 !

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

