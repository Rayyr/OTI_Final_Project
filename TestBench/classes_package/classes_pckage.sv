package xx;

import uvm_pkg::*;


//sequences  cpop
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/conflict_cpop_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/conflict_reading_with_cpop_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/cpop/usual_cpop_seq.sv"



/*
//sequences xor
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/conflict_inverted_xor_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/conflict_reading_with_xor_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/usual_inverted_xor_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/logical_ops_sequences/xor/usual_xor_seq.sv"
*/

 

//sequences ctz
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/conflict_ctz_data_path_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/conflict_reading_with_ctz_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/usual_ctz_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/ctz/random_seq.sv"

 

 //sequences grev
//sequences grev
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/conflict_grev_data_path_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/conflict_reading_with_grev_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/invalid_b_in_grev_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/random_grev_seq.sv"
 `include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/reset_seq.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/sequences/bit_manipulation_ops_sequences/grev/usual_grev_seq.sv"

endpackage  