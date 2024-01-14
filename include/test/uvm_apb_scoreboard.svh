
`uvm_analysis_imp_decl(_from_apb_master_agent)
`uvm_analysis_imp_decl(_from_apb_slave_agent)
`uvm_analysis_imp_decl(_from_reset_monitor)
class uvm_apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(uvm_apb_scoreboard)

  uvm_apb_sequence_item    #(apb_parameter)     queue_item[$];
  
  uvm_reset_sequence_item                       queue_reset_item[$];

  // uvm_analysis_imp
  uvm_analysis_imp_from_apb_master_agent  #(uvm_apb_sequence_item#(apb_parameter), uvm_apb_scoreboard) analysis_imp_from_apb_master_agent ;
  uvm_analysis_imp_from_apb_slave_agent   #(uvm_apb_sequence_item#(apb_parameter), uvm_apb_scoreboard) analysis_imp_from_apb_slave_agent  ;
  uvm_analysis_imp_from_reset_monitor     #(uvm_reset_sequence_item              , uvm_apb_scoreboard) analysis_imp_from_reset_monitor    ;

  function new (string name="uvm_apb_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    analysis_imp_from_apb_master_agent  = new("analysis_imp_from_apb_master_agent"  ,  this);
    analysis_imp_from_apb_slave_agent   = new("analysis_imp_from_apb_slave_agent"   ,  this); 
    analysis_imp_from_reset_monitor     = new("analysis_imp_from_reset_monitor"     ,  this); 
  endfunction: build_phase

  // monitor to scoreboard write function
  function void write_from_apb_master_agent(uvm_apb_sequence_item#(apb_parameter) item);
    `uvm_info(get_type_name(), $sformatf("\nwrite_from_apb_master_agent item:\n%s", item.sprint()), UVM_LOW)    
  
    queue_item.push_back(item);
  endfunction  

  function void write_from_apb_slave_agent(uvm_apb_sequence_item#(apb_parameter) item);
    `uvm_info(get_type_name(), $sformatf("\nwrite_from_apb_slave_agent item:\n%s", item.sprint()), UVM_LOW)    
    
    queue_item.push_back(item);
  endfunction

  function void write_from_reset_monitor(uvm_reset_sequence_item item);
    `uvm_info(get_type_name(), $sformatf("\nwrite_from_reset_monitor item:\n%s", item.sprint()), UVM_LOW)    
    
    queue_reset_item.push_back(item);
  endfunction


  task run_phase (uvm_phase phase);
  
    uvm_apb_sequence_item#(apb_parameter) item;

    forever begin
      wait(queue_item.size > 0);
      
      if(queue_item.size > 0) begin
        item = queue_item.pop_front();
        
        // Checking comparing logic ...

      end

    end

  endtask : run_phase


endclass : uvm_apb_scoreboard

// teddywhy@gmail.com

