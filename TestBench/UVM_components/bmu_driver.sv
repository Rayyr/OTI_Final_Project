class bmu_driver extends uvm_driver #(bmu_sequence_item);

`uvm_component_utils(bmu_driver)

virtual bmu_interface vif;
bmu_sequence_item seq;

//override the constructor
function new(string name="bmu_driver",uvm_component parent);
super.new(name,parent);
endfunction


//override build_phase() function
function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(virtual bmu_interface)::get(this,"","vif",vif))
  `uvm_fatal(get_type_name(), "Not set at top level"); 

endfunction


//override run_phase() task
task run_phase(uvm_phase phase);
super.run_phase(phase);

forever begin
//here
seq_item_port.get_next_item(seq);
drive(seq);
`uvm_info(get_type_name(), $sformatf("Driver: signals driven to the DUT are: A = %0d , B = %0d",seq.a_in, seq.b_in), UVM_HIGH); 
seq_item_port.item_done();

end
endtask


//override drive() task
task drive(bmu_sequence_item seq);

@(vif.driver_cb);
  vif.driver_cb.a_in<=seq.a_in;
  vif.driver_cb.b_in<=seq.b_in;
  vif.driver_cb.rst_l<=seq.rst_l;
  vif.driver_cb.ap<=seq.ap;
  vif.driver_cb.valid_in<=seq.valid_in;
  vif.driver_cb.scan_mode<=seq.scan_mode;
  vif.driver_cb.csr_ren_in<=seq.csr_ren_in;
  vif.driver_cb.csr_rddata_in<=seq.csr_rddata_in;
endtask

endclass