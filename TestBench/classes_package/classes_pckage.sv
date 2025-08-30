package p;

import uvm_pkg::*;
/* sequences
`include "alu_sequence_item.sv"
`include "alu_random_sequence.sv"
`include "alu_add_sequence.sv"
`include "alu_sub_sequence.sv"
`include "alu_and_sequence.sv"
`include "alu_or_sequence.sv"
`include "alu_xor_sequence.sv"
`include "alu_undefined_opcode_sequence.sv"
`include "alu_overflow_sequence.sv"
`include "alu_underflow_sequence.sv"*/



 
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_sequencer.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_driver.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_monitor.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_agent.sv"
//`include "alu_subscriber.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_scoreboard.sv"
`include "/home/Trainee6/final_project/TestBench/UVM_components/bmu_environment.sv"

/* tests
`include "alu_random_test.sv"
`include "alu_add_test.sv"
`include "alu_and_test.sv"
`include "alu_undefined_opcode_test.sv"
`include "alu_xor_test.sv"
`include "alu_or_test.sv"
`include "alu_sub_test.sv"*/
 

endpackage