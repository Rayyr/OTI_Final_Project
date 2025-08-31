import uvm_pkg::*;
 
`include "uvm_macros.svh"
 
`include "/home/Trainee6/final_project/TestBench/interfaces/bmu_interface.sv"
`include "/home/Trainee6/final_project/TestBench/classes_package/classes_pckage.sv"

`include "/home/Trainee6/final_project/Design/packages&libs/rtl_pdef.sv"
`include "/home/Trainee6/final_project/Design/packages&libs/rtl_def.sv"
`include "/home/Trainee6/final_project/Design/packages&libs/rtl_defines.sv"
`include "/home/Trainee6/final_project/Design/packages&libs/rtl_lib.sv"
`include "/home/Trainee6/final_project/Design/packages&libs/rtl_param.sv"

//note add the sequences into different package 
`include "/home/Trainee6/final_project/TestBench/UVM_components/tests/arithmatic_tests/sub_tests.sv"

//RTL design
`include "/home/Trainee6/final_project/Design/Bit_Manibulation_Unit.sv"
 import p::*;




module top;
  
  logic clk,rst;
  
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
   rst = 0; 
   #1; 
   rst = 1; 
   #1; 
   rst = 0;   
  end
  
  
  // set interface in config_db 
  initial uvm_config_db#(virtual bmu_interface)::set(uvm_root::get(), "*", "vif",intf); 
  
 
 initial begin
run_test("sub_tests");

 end
 
endmodule  