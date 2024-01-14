
//   `include "apb_parameter.svh"
//   `include "apb_interface.svh"

package uvm_apb_agent_pkg;

/////////////////////////////////////////////////

   import uvm_pkg::*;

   `include "uvm_macros.svh"

/////////////////////////////////////////////////

// `include "apb_parameter.svh"
// `include "apb_interface.svh"

/////////////////////////////////////////////////

   `include "uvm_apb_sequence_item.svh"       
                                              
   `include "uvm_apb_monitor.svh"             
                                              
   `include "uvm_apb_master_driver.svh"       
   `include "uvm_apb_master_sequencer.svh"    
   `include "uvm_apb_master_agent.svh"        
                                              
   `include "uvm_apb_slave_driver.svh"        
   `include "uvm_apb_slave_sequencer.svh"     
   `include "uvm_apb_slave_agent.svh"         

/////////////////////////////////////////////////

   `include "uvm_apb_sequence.svh"
   `include "uvm_apb_master_sequence_r.svh"
   `include "uvm_apb_master_sequence_w.svh"
   
   `include "uvm_apb_master_scoreboard.svh"
   
   `include "uvm_apb_master_env.svh"
   `include "uvm_apb_master_test.svh"

endpackage: uvm_apb_agent_pkg     
