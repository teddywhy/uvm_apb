
class uvm_apb_master_sequence_w #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_apb_master_sequence#(PM);
 
   `uvm_object_utils(uvm_apb_master_sequence_w)
    
   function new(string name="uvm_apb_master_sequence_w");
       super.new(name);
   endfunction : new
   
   virtual task body();
              
     `uvm_do_with(req, {req.address=='h100; req.pwrite==1; req.strobe=='1;})
    
     `uvm_do_with(req, {req.address=='h200; req.pwrite==1; req.strobe=='1;})  

     `uvm_do_with(req, {req.address=='h300; req.pwrite==1; req.strobe=='1;})  

     `uvm_do_with(req, {req.address=='h400; req.pwrite==1; req.strobe=='1;})  

     `uvm_do_with(req, {req.address=='h500; req.pwrite==1; req.strobe=='1;})         

   endtask : body
  
endclass : uvm_apb_master_sequence_w

// teddywhy@gmail.com


