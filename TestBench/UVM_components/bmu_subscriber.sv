class bmu_subscriber extends uvm_subscriber #(bmu_sequence_item); 

 

  `uvm_component_utils(bmu_subscriber)
    bmu_sequence_item sub; 

 
 covergroup bmuCoverage; 
  a_in: coverpoint sub.a_in;
  b_in: coverpoint sub.b_in; 
  ap: coverpoint sub.ap ; 
  csr_rddata_in:coverpoint sub.csr_rddata_in;
  result_ff: coverpoint sub.result_ff; 
  error: coverpoint sub.error; 
endgroup 

  function new(string name="bmu_subscriber",uvm_component parent); 
    super.new(name,parent); 
    bmuCoverage = new; 
    sub = new(); 
  endfunction 
 
 
function void write (bmu_sequence_item t); 
  sub.a_in = t.a_in; 
  sub.b_in = t.b_in; 
  sub.ap = t.ap; 
  sub.rst_l = t.rst_l; 
  sub.valid_in=t.valid_in;
  sub.scan_mode=t.scan_mode;
  sub.csr_rddata_in=t.csr_rddata_in;
  sub.csr_ren_in=t.csr_ren_in;
  sub.result_ff = t.result_ff; 
  sub.error = t.error; 
  bmuCoverage.sample(); 
endfunction 
  
  
  
function void report_phase(uvm_phase phase); 
  super.report_phase(phase); 
  `uvm_info(get_type_name(),$sformatf("coverage: %d",bmuCoverage.get_coverage()), UVM_NONE); 
endfunction 
  
  
endclass 

//NOTE : the covergae almost will = 0% but that doesnot mean that no hit has been detected , no but the idea since i hdont define the bins 
//so the automatic ones will be consdered so taht mean for inputs w will have 2^32 bin !!! the same with each coverpoint so the number of 
//combinations is very very large !! , so the percentage of hitting will be ~=0 so since the overall number of transaction also ~=0
//(at most 20 test case i have !!) so thats why , so the solution simply define my own pins(small ones )with teh values i need to analyze !