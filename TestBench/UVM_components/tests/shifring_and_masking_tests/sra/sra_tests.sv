class sra_test extends uvm_test;
  
    //register it into uvm factory
   `uvm_component_utils(sra_test)

  bmu_environment bmu_env;

conflict_reading_with_sra_seq seq1;
conflict_sra_data_path_seq seq2;
max_shift_amount_sra_version2_seq seq3;
max_shift_amount_sra_version2_seq seq4;
min_shift_amount_sra_seq seq5;
 reset_seq seq6;
 usual_sra_seq seq7;
 

  //overridden new()
  function new(string name="bmu_sra_test",uvm_component parent);
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
    
    seq1= conflict_reading_with_sra_seq::type_id::create("seq1");
    seq2= conflict_sra_data_path_seq::type_id::create("seq2");
    seq3= max_shift_amount_sra_version2_seq::type_id::create("seq3");
    seq4= max_shift_amount_sra_version2_seq::type_id::create("seq4");
    seq5= min_shift_amount_sra_seq::type_id::create("seq5");
    seq6=reset_seq::type_id::create("seq6");
    seq7=usual_sra_seq::type_id::create("seq7");

    repeat(2) begin 
    
     seq1.start(bmu_env.agent.sequencer); 
     seq2.start(bmu_env.agent.sequencer); 
      seq3.start(bmu_env.agent.sequencer); 
       seq4.start(bmu_env.agent.sequencer); 
        seq5.start(bmu_env.agent.sequencer); 
         seq6.start(bmu_env.agent.sequencer); 
         seq7.start(bmu_env.agent.sequencer); 
    end
    phase.drop_objection(this); 
    `uvm_info(get_type_name(), "End of testcase", UVM_LOW); 
  endtask
  
endclass 