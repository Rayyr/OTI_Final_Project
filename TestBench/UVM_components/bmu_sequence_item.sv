class bmu_sequence_item extends uvm_sequence_item;


//data feilds for the BMU unit
//inputs 
rand logic signed [31:0]a_in;//1st operand input
rand logic signed [31:0]b_in;//2nd operand input 
rand bit rst_l;
rand bit scan_mode;
rand bit valid_in;
rand bit csr_ren_in ;
rand logic signed [31:0] csr_rddata_in ;
//add struct opcode
rand rtl_alu_pkt_t ap;


//outputs
logic signed [31:0] result_ff;
logic  error;


  
  //register the class feilds to the UVM factory using the macros below 
  `uvm_object_utils_begin (bmu_sequence_item) 
  `uvm_field_int(rst_l,UVM_ALL_ON);
  //to register struct i use this macro since it is not int 
  `uvm_field_int(ap,UVM_ALL_ON);
  `uvm_field_int(a_in,UVM_ALL_ON);
  `uvm_field_int(b_in,UVM_ALL_ON);
  `uvm_field_int(valid_in,UVM_ALL_ON);
  `uvm_field_int(scan_mode,UVM_ALL_ON);
  `uvm_field_int(csr_rddata_in,UVM_ALL_ON);
  `uvm_field_int(csr_ren_in,UVM_ALL_ON);
  `uvm_field_int(result_ff,UVM_ALL_ON);
  `uvm_field_int(error,UVM_ALL_ON);
  `uvm_object_utils_end


   //the overriden constructor 
  function new(string name="bmu_sequence_item");
    super.new(name);
  endfunction




 
endclass
//note : solve the ap registeration into factory issue 