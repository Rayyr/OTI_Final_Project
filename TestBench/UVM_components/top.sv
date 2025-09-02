import uvm_pkg::*;
`include "uvm_macros.svh"

//RTL design and other related files 

`include "/home/Trainee6/final_project/Design/Bit_Manibulation_Unit.sv"



//bmu interface
`include "/home/Trainee6/final_project/TestBench/interfaces/bmu_interface.sv"


 //uvm components
 `include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_sequence_item.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_sequencer.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_driver.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_monitor.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_agent.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_scoreboard.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_subscriber.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_environment.sv"


/*
//sequences cpop
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/conflict_cpop_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/conflict_reading_with_cpop_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/usual_cpop_seq.sv"
*/

`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/conflict_ctz_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/conflict_reading_with_ctz_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/usual_ctz_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/random_seq.sv"

 
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/usual_xor_seq.sv"
//tests
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/cpop_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/logical_tests/xor/xor_tests.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/ctz_tests.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/logical_tests/xor/xor_tests.sv"

 


module top;
  
  logic clk;
  
  //interface
  bmu_interface intf(clk);
  //dut
  Bit_Manipulation_Unit dut(.clk(clk),
  .rst_l(intf.rst_l),
   .a_in(intf.a_in), 
   .b_in(intf.b_in),
   .scan_mode(intf.scan_mode),
   .valid_in(intf.valid_in),
   .ap(intf.ap),
    .csr_ren_in(intf.csr_ren_in),
    .csr_rddata_in(intf.csr_rddata_in),
    .result_ff(intf.result_ff),
    .error(intf.error) );
  
  //clk generation
  always #5 clk=~clk; //ct=10 units
  
  initial begin
   clk=0;
   
  end
  
  
  // set interface in config_db 
  initial uvm_config_db#(virtual bmu_interface)::set(uvm_root::get(), "*", "vif",intf); 
  
 
 initial begin
//run_test("cpop_test");
//run_test("xor_test");
 run_test("ctz_test");
//run_test("xor_test");
 end
 
endmodule  