
`uvm_analysis_imp_decl(_mon2sb_master)
`uvm_analysis_imp_decl(_mon2sb_slave)
class uvm_apb_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(uvm_apb_scoreboard)

  uvm_apb_sequence_item queue_item[$];

  uvm_analysis_imp_mon2sb_master#(uvm_apb_sequence_item#(apb_parameter), uvm_apb_scoreboard) analysis_imp_mon2sb_master;
  uvm_analysis_imp_mon2sb_slave #(uvm_apb_sequence_item#(apb_parameter), uvm_apb_scoreboard) analysis_imp_mon2sb_slave ;

  function new (string name="uvm_apb_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    analysis_imp_mon2sb_master = new("analysis_imp_mon2sb_master", this);
    analysis_imp_mon2sb_slave  = new("analysis_imp_mon2sb_slave",  this);
  endfunction: build_phase

  // monitor to scoreboard write function
  function void write_mon2sb_master(uvm_apb_sequence_item item);
//  `uvm_info("SCB", $sformatf("Seq_item written from driver: \n"), UVM_HIGH)
//  item.print();  

    `uvm_info(get_type_name(), $sformatf("\nwrite_mon2sb_master item:\n%s", item.sprint()), UVM_LOW)    
  
    queue_item.push_back(item);
  endfunction  

  function void write_mon2sb_slave(uvm_apb_sequence_item item);
    `uvm_info(get_type_name(), $sformatf("\nwrite_mon2sb_slave item:\n%s", item.sprint()), UVM_LOW)    
    
    queue_item.push_back(item);
  endfunction

  task run_phase (uvm_phase phase);
  
    uvm_apb_sequence_item item;

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
