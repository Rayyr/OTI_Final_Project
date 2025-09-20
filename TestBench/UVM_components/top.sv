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
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/usual_cpop_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/conflict_cpop_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/conflict_reading_with_cpop_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/reset_seq.sv"

*/



/*
//sequences ctz
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/conflict_ctz_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/conflict_reading_with_ctz_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/usual_ctz_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/random_ctz_seq.sv" 
 */




/*
//sequences grev
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/conflict_grev_data_path_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/conflict_reading_with_grev_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/usual_grev_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/random_grev_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/invalid_b_in_grev_seq.sv"
*/


 /*
//sequences max
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/max/conflict_max_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/max/conflict_reading_with_max_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/max/reset_max_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/max/usual_max_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/max/random_max_seq.sv"
*/





/*
//sequences xor
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/usual_xor_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/conflict_xor_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/conflict_reading_with_xor_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/random_xor_seq.sv"
*/





/*
//sequences pack
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/pack/conflict_pack_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/pack/conflict_reading_with_pack_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/pack/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/pack/usual_pack_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/pack/random_pack_seq.sv"
*/






/*
//sequences siext_b
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/siext_b/conflict_reading_with_siext_b_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/siext_b/conflict_siext_b_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/siext_b/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/siext_b/usual_siext_b_seq.sv"
 */



 


/*
//sequences slt
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/slt/conflict_reading_with_slt_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/slt/conflict_slt_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/slt/usual_slt_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/slt/random_slt_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/slt/reset_seq.sv"
*/



//sequences read
//`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/csr_ops_sequences/csr_read/usual_csr_read_seq.sv"





//sequences binv
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/binv/conflict_binv_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/binv/conflict_reading_with_binv_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/binv/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/binv/toggle_lsb_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/binv/toggle_msb_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/binv/usual_binv_seq.sv"





/*
//sequences ror
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/ror/conflict_reading_with_ror_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/ror/conflict_ror_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/ror/max_rotation_amount_ror_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/ror/min__rotation_amount_ror_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/ror/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/ror/random_ror_seq.sv"
*/





/*
//sequences sh2add
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sh2add/conflict_reading_with_sh2add_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sh2add/conflict_sh2add_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sh2add/overflow_sh2add_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sh2add/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sh2add/underflow_sh2add_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sh2add/usual_sh2add_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sh2add/random_sh2add_seq.sv"

*/






/*
//sequences sra
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sra/conflict_reading_with_sra_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sra/conflict_sra_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sra/max_shift_amount_sra_version1_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sra/max_shift_amount_sra_version2_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sra/min_shift__amount_sra_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sra/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/sra/random_sra_seq.sv"
*/




/*
//sequences srl
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/srl/conflict_reading_with_srl_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/srl/conflict_srl_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/srl/random_srl_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/srl/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/srl/min_shift_amount_srl_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/shifting_and_masking_ops_sequences/srl/max_shift_amount_srl_seq.sv"
*/


/*
//sequences or
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/or/conflict_or_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/or/conflict_reading_with_or_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/or/random_or_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/or/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/or/usual_or_seq.sv"
*/




/*
//sequences sub
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/arithmatic_ops_sequences/sub/conflict_reading_with_sub_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/arithmatic_ops_sequences/sub/conflict_sub_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/arithmatic_ops_sequences/sub/overflow_sub_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/arithmatic_ops_sequences/sub/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/arithmatic_ops_sequences/sub/underflow_sub_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/arithmatic_ops_sequences/sub/usual_sub_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/arithmatic_ops_sequences/sub/equality_sub_seq.sv"
*/





//tests
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/cpop_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/logical_tests/xor/xor_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/ctz_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/grev_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/max_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/pack_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/siext_b_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/bit_manipulations_tests/slt_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/csr_tests/csr_read_tests.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/shifring_and_masking_tests/binv/binv_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/shifring_and_masking_tests/ror/ror_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/shifring_and_masking_tests/sh2add/sh2add_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/shifring_and_masking_tests/sra/sra_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/shifring_and_masking_tests/srl/srl_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/logical_tests/or/or_tests.sv"
//`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/arithmatic_tests/sub_tests.sv"



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
//run_test("slt_test");
//run_test("csr_read_test");
run_test("binv_test");
//run_test("ror_test");
//run_test("sh2add_test");
//run_test("sra_test");
//run_test("srl_test");
//run_test("or_test");
//run_test("sub_test");

 end
 
endmodule  