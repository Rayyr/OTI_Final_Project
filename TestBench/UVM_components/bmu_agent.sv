class bmu_agent extends uvm_agent; 

 bmu_driver driver;
 bmu_monitor monitor;
 bmu_sequencer sequencer;

 `uvm_component_utils(bmu_agent);


 //override new()
 function new(string name="bmu_agent",uvm_component parent);
  super.new(name,parent);
 endfunction


 //override build_phase() 
 function void build_phase(uvm_phase phase);

super.build_phase(phase);

//the default agent type is active , but we can change it 
if(get_is_active()== UVM_ACTIVE) begin
this.sequencer=bmu_sequencer::type_id::create("bmu_sequencer",this);
this.driver=bmu_driver::type_id::create("bmu_driver",this);
end

//in all cases the monitor must be created either if it is active or passive
  monitor = bmu_monitor::type_id::create("bmu_monitor",this); 
 endfunction
  



  //override connect_phase()
  function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
if(get_is_active()==UVM_ACTIVE)
this.driver.seq_item_port.connect(this.sequencer.seq_item_export);
  endfunction
endclass 