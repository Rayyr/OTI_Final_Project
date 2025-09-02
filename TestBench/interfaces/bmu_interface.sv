
import rtl_pkg::*;
interface bmu_interface (input logic clk);


//inputs 
 logic signed [31:0]a_in;//1st operand input
 logic signed [31:0]b_in;//2nd operand input  
 bit rst_l;
 bit scan_mode;
 bit valid_in;
 bit csr_ren_in ;
 logic signed [31:0] csr_rddata_in ;
//add struct opcode
 rtl_predict_pkt_t ap;


//outputs
logic signed [31:0] result_ff;
logic  error;



//clocking controller blocks
  //neg edge since the dut will operate on posedge so the driver will take the 
  //seq_obj from the sequencer to send it to the dut so it must receive it before posedge 
  clocking driver_cb @(negedge clk);
    //this means driver will drive the transaction(sequence item) before 1 time unit to the dut and it will gets the outputs from the dut exactly without any delays ( at negedge ) 
    default input#1   output#0;
    //since he will send the transaction obj to the dut via the intercae so all of ports are output (logically) !
    output a_in,b_in,ap,rst_l,valid_in,scan_mode,csr_ren_in ,csr_rddata_in;
  endclocking 
  
  
  clocking monitor_cb @(posedge clk);
      default input#0  output#1;
      //since he will receive the transaction obj from dut via the interfcae so all ports are inputs (logically) !
    input a_in,b_in,ap,rst_l,valid_in,scan_mode,csr_ren_in ,csr_rddata_in,result_ff,error;
  endclocking
  
  
  //NOTE : since driver will work on neg edge of the pulse and the driver on the pos edge of ot , so each op require 1 cycle ( min)
  //modports 
  modport driver_mod (clocking driver_cb,input clk);
  modport monitor_mod(clocking monitor_cb,input clk);


endinterface