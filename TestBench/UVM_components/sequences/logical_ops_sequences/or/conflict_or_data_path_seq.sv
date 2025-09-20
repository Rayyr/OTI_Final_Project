// !! NOTE : in logical ops in general we dont have edge cases so all of them are applicavle without any errors thats why i implement them in one sequence class !
import uvm_pkg::*;
`include "uvm_macros.svh"

class conflict_or_data_path_seq extends uvm_sequence#(bmu_sequence_item);
  
  //register the class into uvm factory
  `uvm_object_utils(conflict_or_data_path_seq)
 


  //overriden new()
  function new(string name ="conflict_or_data_path_seq");
    super.new(name);
  endfunction
  
  
  //task stimul
  task body(); 
      
    //declare&initialize sequence_item ( packet , transaction .. )
    bmu_sequence_item seq=bmu_sequence_item::type_id::create("seq");

    seq.ap.rand_mode(0);
    initialize_ap(seq.ap);
    seq.ap.lor=1'b1;
     

    //activate sll operation once 
    seq.ap.sll=1'b1;
    
    `uvm_info(get_type_name(), ("Conflict OR data path by activation other operation once at a time"), UVM_NONE) //faild
repeat(3) begin
    seq.randomize() with {valid_in==1;csr_ren_in==1'b0;seq.rst_l==1'b1;};
    start_item(seq);//drive this transaction to the driver via the sequencer then to the DUT via the design_interface
    finish_item(seq);//notify that the process is finished ( sent sucessfully to the DUT )
end


seq.ap.zbb=1;
    `uvm_info(get_type_name(), ("Conflict Inverted-OR data path by activation other operation once at a time"), UVM_NONE) //faild
repeat(3) begin
    seq.randomize() with {valid_in==1;csr_ren_in==1'b0;seq.rst_l==1'b1;};
    start_item(seq);//drive this transaction to the driver via the sequencer then to the DUT via the design_interface
    finish_item(seq);//notify that the process is finished ( sent sucessfully to the DUT )
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