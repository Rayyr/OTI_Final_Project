
class bmu_sequencer extends uvm_sequencer#(bmu_sequence_item);

//register it into uvm factory
`uvm_component_utils(bmu_sequencer)


//overidden cpnstructor
function new(string name="bmu_sequencer",uvm_component parent);
super.new(name,parent);
endfunction


endclass