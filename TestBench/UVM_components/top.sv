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


//`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/conflict_ctz_data_path_seq.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/conflict_reading_with_ctz_seq.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/reset_seq.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/usual_ctz_seq.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/random_ctz_seq.sv"
 

/*
//sequences grev
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/conflict_grev_data_path_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/conflict_reading_with_grev_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/invalid_b_in_grev_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/random_grev_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/usual_grev_seq.sv"

*/


/*
//sequences max
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/max/conflict_max_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/max/conflict_reading_with_max_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/max/reset_max_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/max/usual_max_seq.sv"
*/

//`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/max/random_max_seq.sv"




//`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/usual_xor_seq.sv"



/*
//sequences pack
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/pack/conflict_pack_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/pack/conflict_reading_with_pack_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/pack/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/pack/usual_pack_seq.sv"

*/

//`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/pack/random_pack_seq.sv"



/*

//sequences siext_b
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/siext_b/conflict_reading_with_siext_b_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/siext_b/conflict_siext_b_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/siext_b/random_siext_b_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/siext_b/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/siext_b/usual_siext_b_seq.sv"

*/

 //`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/random_ctz_seq.sv"


/*
//sequences slt
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/slt/random_slt_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/slt/reset_seq.sv"
*/
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/slt/usual_slt_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/slt/conflict_reading_with_slt_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/slt/conflict_slt_data_path_seq.sv"



//tests
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/cpop_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/logical_tests/xor/xor_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/ctz_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/grev_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/max_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/pack_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/siext_b_tests.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/slt_tests.sv"

 


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
  
  
  
  initial begin
    // set interface in config_db
    uvm_config_db#(virtual bmu_interface)::set(uvm_root::get(), "*", "vif", intf);
end
 
 
 initial begin
//run_test("cpop_test");
//run_test("ctz_test");
//run_test("xor_test");
//run_test("grev_test");
//run_test("max_test");
//run_test("pack_test");
//run_test("siext_b_test");
run_test("slt_test");
 end
 
endmodule  