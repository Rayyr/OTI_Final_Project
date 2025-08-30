class bmu_environment extends uvm_env;

//register it into UVM factory
`uvm_component_utils(bmu_environment)

bmu_scoreboard scoreboard;
bmu_agent agent;


//override the constructor 
function new(string name="bmu_environment",uvm_component parent);
super.new(name,parent);
endfunction


//override the build_phase()
function void build_phase(uvm_phase phase);
super.build_phase(phase);
//crete the other components using create()
agent=bmu_agent::type_id::create("agent",this);
scoreboard=bmu_scoreboard::type_id::create("scoreboard",this);


endfunction



//override connect_phase()
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
agent.monitor.port.connect(scoreboard.exp);
endfunction

endclass