class or_test extends uvm_test;
  
    //register it into uvm factory
   `uvm_component_utils(or_test)

  bmu_environment bmu_env;

avg_oring_seq seq1;
 
 
 
 

  //overridden new()
  function new(string name="bmu_or_test",uvm_component parent);
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
    
    seq1= avg_oring_seq::type_id::create("seq1");
 
   
 

    repeat(2) begin 
    
     seq1.start(bmu_env.agent.sequencer); 
  
         
 
    end
    phase.drop_objection(this); 
    `uvm_info(get_type_name(), "End of testcase", UVM_LOW); 
  endtask
  
endclass 