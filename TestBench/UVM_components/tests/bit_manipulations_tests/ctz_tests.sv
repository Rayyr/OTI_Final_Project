class ctz_test extends uvm_test;
  
    //register it into uvm factory
   `uvm_component_utils(ctz_test)

  bmu_environment bmu_env;

 conflict_ctz_data_path_seq seq1;
 conflict_reading_with_ctz_seq seq2;
 reset_seq seq3;
 usual_ctz_seq seq4;
random_ctz_seq seq5;
 
 

  //overridden new()
  function new(string name="bmu_ctz_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  
  //buil_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    bmu_env=bmu_environment::type_id::create("bmu_env",this); 
  endfunction
  


  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    // Pretty tree of everything that was constructed
    uvm_top.print_topology(); // or: uvm_root::get().print_topology();
  endfunction
 

 
  
  //run_phase()
  task run_phase(uvm_phase phase);
 
    super.run_phase(phase);
    phase.raise_objection(this); 
    
    seq1= conflict_ctz_data_path_seq::type_id::create("seq1");
    seq2= conflict_reading_with_ctz_seq::type_id::create("seq2");
    seq3= reset_seq::type_id::create("seq3");
    seq4= usual_ctz_seq::type_id::create("seq4");
    seq5=random_ctz_seq::type_id::create("seq5");
 

   
    
    seq1.start(bmu_env.agent.sequencer); 
    seq2.start(bmu_env.agent.sequencer); 
    seq3.start(bmu_env.agent.sequencer); 
    seq4.start(bmu_env.agent.sequencer); 
   seq5.start(bmu_env.agent.sequencer); 

    phase.drop_objection(this); 
    `uvm_info(get_type_name(), "End of testcase", UVM_LOW); 
  endtask
  
endclass 