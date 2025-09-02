 


class bmu_monitor extends uvm_monitor;

//register in into uvm factory
`uvm_component_utils(bmu_monitor)

virtual bmu_interface vif;
  
uvm_analysis_port #(bmu_sequence_item) port; 


//override new() function
function new(string name="bmu_monitor",uvm_component parent);
super.new(name,parent);
port=new("monitor_port",this);
endfunction



//override build_phase() function
function void build_phase(uvm_phase phase);

super.build_phase(phase);
if(!uvm_config_db #(virtual bmu_interface) ::get(this, "", "vif", vif))
 `uvm_fatal(get_type_name(), "Not set at top level");

endfunction




//override run_phase() task
task run_phase(uvm_phase phase);
super.run_phase(phase);

forever begin

bmu_sequence_item packet=bmu_sequence_item::type_id::create("packet");
@(vif.monitor_cb);
      packet.rst_l= vif.monitor_cb.rst_l;
      packet.a_in = vif.monitor_cb.a_in; 
      packet.b_in = vif.monitor_cb.b_in;
      packet.ap = vif.monitor_cb.ap; 
      packet.csr_rddata_in = vif.monitor_cb.csr_rddata_in; 
      packet.csr_ren_in = vif.monitor_cb.csr_ren_in; 
      packet.valid_in = vif.monitor_cb.valid_in; 
      packet.scan_mode = vif.monitor_cb.scan_mode; 

      
      printDataSentToUDT(vif);
    //  `uvm_info(get_type_name(), $sformatf("Monitor: input signals are sent to the DUT are:A = %0d, B = %0d, Opcode = %h", packet.a_in, packet.b_in),UVM_HIGH); 
       packet.result_ff = vif.monitor_cb.result_ff; 
      packet.error = vif.monitor_cb.error; 
    //  `uvm_info(get_type_name(), $sformatf("Monitor Result = %d",vif.monitor_cb.result_ff), UVM_LOW)
     `uvm_info(get_type_name(), $sformatf("Monitor: the output signals recived from the DUT are: Result = %d, Error = %b",packet.result_ff,packet.error), UVM_LOW)
      port.write(packet); //send it to the scoreboard
      

end

endtask


function void printDataSentToUDT(virtual bmu_interface vif);
 `uvm_info(get_type_name(), $sformatf("Monitor: input signals are sent to the DUT are:A = %0d, B = %0d , Reset = %0d", vif.monitor_cb.a_in, vif.monitor_cb.b_in,vif.monitor_cb.rst_l),UVM_LOW)
endfunction


endclass