// !! NOTE : in logical ops in general we dont have edge cases so all of them are applicavle without any errors thats why i implement them in one sequence class !

class reset_max_seq extends uvm_sequence #(bmu_sequence_item);
  
  //register the class into uvm factory
  `uvm_object_utils(reset_max_seq)
 


  //overriden new()
  function new(string name ="reset_max_seq");
    super.new(name);
  endfunction
  
  
  //task stimul
  task body(); 
      
    //declare&initialize sequence_item ( packet , transaction .. )
    bmu_sequence_item seq=bmu_sequence_item::type_id::create("seq");
    
    seq.rst_l=1'b0;
    start_item(seq);
    `uvm_info(get_type_name(),"Reset Case",UVM_LOW);
    finish_item(seq);

    
  endtask
  

 endclass