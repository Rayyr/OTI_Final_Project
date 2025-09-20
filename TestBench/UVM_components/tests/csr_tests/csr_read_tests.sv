class csr_read_test extends uvm_test;
  
    //register it into uvm factory
   `uvm_component_utils(csr_read_test)

  bmu_environment bmu_env;
  
usual_csr_read_data_path_seq seq1;

  //overridden new()
  function new(string name="bmu_csr_read_test",uvm_component parent);
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
    
    seq1= usual_csr_read_data_path_seq::type_id::create("seq1");
    
  
     seq1.start(bmu_env.agent.sequencer); 
    
    phase.drop_objection(this); 
    `uvm_info(get_type_name(), "End of testcase", UVM_LOW); 
  endtask
  
endclass 