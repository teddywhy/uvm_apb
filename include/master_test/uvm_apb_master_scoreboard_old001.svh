
`uvm_analysis_imp_decl(_from_apb_master_agent)
`uvm_analysis_imp_decl(_from_reset_monitor)
class uvm_apb_master_scoreboard #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_scoreboard;

  `uvm_component_utils(uvm_apb_master_scoreboard#(PM))

  uvm_apb_sequence_item#(PM)   queue_item[$];

  uvm_reset_sequence_item      queue_reset_item[$];

  uvm_analysis_imp_from_reset_monitor #(uvm_reset_sequence_item   , uvm_apb_master_scoreboard#(PM)) analysis_imp_from_reset_monitor ;
  
  uvm_analysis_imp_from_apb_master_agent             #(uvm_apb_sequence_item#(PM), uvm_apb_master_scoreboard#(PM)) analysis_imp_from_apb_master_agent;

  function new (string name="uvm_apb_master_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    analysis_imp_from_apb_master_agent = new("analysis_imp_from_apb_master_agent", this);
    analysis_imp_from_reset_monitor = new("analysis_imp_from_reset_monitor" ,  this); 
    
  endfunction: build_phase

  // write from monitor to scoreboard
  function void write_from_apb_master_agent(uvm_apb_sequence_item#(PM) item);

      `uvm_info(get_type_name(), $sformatf("\n%s\n%s:\n%s"           ,
                                  get_full_name()                    ,
                                  "write_from_apb_master_agent"      ,
                                  item.sprint()                     ),
                                  UVM_LOW                             )
  
      queue_item.push_back(item);
  endfunction  


  function void write_from_reset_monitor(uvm_reset_sequence_item item);
    `uvm_info(get_type_name(), $sformatf("\nwrite_from_reset_monitor item:\n%s", item.sprint()), UVM_LOW)    
    
    queue_reset_item.push_back(item);
  endfunction


  task run_phase (uvm_phase phase);
  
    uvm_apb_sequence_item#(PM) item;

    forever begin
      wait(queue_item.size > 0);
      
      if(queue_item.size > 0) begin
        item = queue_item.pop_front();
        
        // Checking comparing logic ...

      end

    end

  endtask : run_phase


endclass : uvm_apb_master_scoreboard

// teddywhy@gmail.com

