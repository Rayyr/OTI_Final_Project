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

 

 

endpackage  