
class uvm_apb_master_sequence_r #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_apb_master_sequence#(PM);
 
   `uvm_object_utils(uvm_apb_master_sequence_r)
    
   function new(string name="uvm_apb_master_sequence_r");
       super.new(name);
   endfunction : new
   
   virtual task body();

     `uvm_do_with(req, {req.address=='h100; req.pwrite==0; req.strobe=='1;})
     
     `uvm_do_with(req, {req.address=='h200; req.pwrite==0; req.strobe=='1;})
     `uvm_do_with(req, {req.address=='h300; req.pwrite==0; req.strobe=='1;})
     
     `uvm_do_with(req, {req.address=='h100; req.pwrite==0; req.strobe=='1;})

     `uvm_do_with(req, {req.address=='h000; req.pwrite==0; req.strobe=='1;})

     `uvm_do_with(req, {req.address=='h300; req.pwrite==0; req.strobe=='1;})
     `uvm_do_with(req, {req.address=='h200; req.pwrite==0; req.strobe=='1;})
     `uvm_do_with(req, {req.address=='h100; req.pwrite==0; req.strobe=='1;})
     `uvm_do_with(req, {req.address=='h300; req.pwrite==0; req.strobe=='1;})
     `uvm_do_with(req, {req.address=='h500; req.pwrite==0; req.strobe=='1;})
    
   endtask : body
  
endclass : uvm_apb_master_sequence_r

// teddywhy@gmail.com

