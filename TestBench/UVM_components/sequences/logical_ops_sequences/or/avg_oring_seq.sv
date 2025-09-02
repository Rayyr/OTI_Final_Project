// !! NOTE : in logical ops in general we dont have edge cases so all of them are applicavle without any errors thats why i implement them in one sequence class !

class avg_oring_seq extends uvm_sequence #(bmu_sequence_item);
  
  //register the class into uvm factory
  `uvm_object_utils(avg_oring_seq)
 


  //overriden new()
  function new(string name ="avg_oring_seq");
    super.new(name);
  endfunction
  
  
  //task stimul
  task body(); 
      
    //declare&initialize sequence_item ( packet , transaction .. )
    bmu_sequence_item seq=bmu_sequence_item::type_id::create("seq");

    //1st transaction
    seq.rst_l=0;
    start_item(seq);
    `uvm_info(get_type_name(), ("Reset Case"), UVM_NONE) 
    finish_item(seq);

 //disable the Reset signal for the test of test cases 
    seq.rst_l.constraint_mode(0);
    seq.rst_l=1'b1;
 

//2nd case : standard valid OR with random inputs a , b
   seq.ap.costraint_mode(0);//disable the randomization for the op feilds once we randomize the seq , this globally will be turned off
   initialize_ap(seq.ap);
   seq.ap.lor=1'b1;
   //seq.ap.zbb=1'b0;
   //all feilds of seq are being randomized instead of seq.rst_l,csr_ren_in
   seq.randomize() with { csr_ren_in==1'b0;};//these constraints locally for this line so this the difference of constraint_mode(0) vs inline constraint which is globally , locally respectivlly
   start_item(seq);//drive this transaction to the driver via the sequencer then to the DUT via the design_interface
   `uvm_info(get_type_name(), ("1st case : Standard Oring "), UVM_NONE) 
   finish_item(seq);//notify that the process is finished ( sent sucessfully to the DUT )
 

  
  //3rd case : Zbb inverted OR with random inputs a , b
   initialize_ap(seq.ap);
   seq.ap.lor=1'b1;
   seq.ap.zbb=1'b1;
   seq.randomize() with {csr_ren_in==1'b0;};
   start_item(seq);
   `uvm_info(get_type_name(), ("2nd case : Standard Inverted Oring "), UVM_NONE) 
   finish_item(seq);



  //4th case : Invalid OR (conflicting control flow fields) version 1
   initialize_ap(seq.ap);
   seq.ap.lor=1'b1;
   seq.ap.ror=1'b1;//enable such other op once 
   seq.randomize() with {csr_ren_in==1'b0;};
   start_item(seq);
   `uvm_info(get_type_name(), ("3rd case : Invalid Oring version 1"), UVM_NONE) 
   finish_item(seq);




  //5th case : Invalid OR (conflicting control flow fields) version 2
   initialize_ap(seq.ap);
   seq.ap.lor=1'b1;
   seq.randomize() with {csr_ren_in==1'b1;};
   start_item(seq);
   `uvm_info(get_type_name(), ("4th case : Invalid Oring version 2"), UVM_NONE) 
   finish_item(seq);



  //6th case : manual complete ORing test case 
   initialize_ap(seq.ap);
   seq.ap.lor=1'b1;
   seq.randomize() with {csr_ren_in==1'b0;a_in=14,b_in=-45};
   start_item(seq);
   `uvm_info(get_type_name(), ("5th case : Invalid Oring version 2"), UVM_NONE) 
   finish_item(seq);



  //7th case : manual complete Inverted ORing test case 
   initialize_ap(seq.ap);
   seq.ap.lor=1'b1;
   seq.ap.abb=1'b1;
   seq.randomize() with {csr_ren_in==1'b0;a_in=0,b_in=1};
   start_item(seq);
   `uvm_info(get_type_name(), ("6th case : Invalid Oring version 2"), UVM_NONE) 
   finish_item(seq);


  //8th case : Oring with dont-care -inputs 
   initialize_ap(seq.ap);
   seq.ap.lor=1'b1;
   seq.randomize() with {csr_ren_in==1'b0;a_in=32'bx,b_in=32'bx};
   start_item(seq);
   `uvm_info(get_type_name(), ("7th case : ORing with dont-care inputs"), UVM_NONE) 
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

