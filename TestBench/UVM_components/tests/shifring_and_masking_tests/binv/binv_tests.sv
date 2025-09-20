class binv_test extends uvm_test;
  
    //register it into uvm factory
   `uvm_component_utils(binv_test)

  bmu_environment bmu_env;

conflict_binv_data_path_seq seq1;
conflict_reading_with_binv_seq seq2;
toggle_lsb_seq seq3;
reset_seq seq4;
toggle_msb_seq seq5;
 usual_binv_seq seq6;
 

  //overridden new()
  function new(string name="bmu_binv_test",uvm_component parent);
    super.new(name,parent);
  endfunction
  
  
  //buil_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    bmu_env=bmu_environment::type_id::create("bmu_env",this); 
  endfunction
  
  
  //run_phase()
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this); 
    
    seq1= conflict_binv_data_path_seq::type_id::create("seq1");
  seq2= conflict_reading_with_binv_seq::type_id::create("seq2");
  seq3= toggle_lsb_seq::type_id::create("seq3");
    seq4= reset_seq::type_id::create("seq4");
   seq5= toggle_msb_seq::type_id::create("seq5");
    seq6=usual_binv_seq::type_id::create("seq6");


 
     seq1.start(bmu_env.agent.sequencer); 
    seq2.start(bmu_env.agent.sequencer); 
     seq3.start(bmu_env.agent.sequencer); 
      seq4.start(bmu_env.agent.sequencer); 
       seq5.start(bmu_env.agent.sequencer); 
      seq6.start(bmu_env.agent.sequencer); 
    
    phase.drop_objection(this); 
    `uvm_info(get_type_name(), "End of testcase", UVM_LOW); 
  endtask
  
endclass 