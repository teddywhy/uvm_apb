
`uvm_analysis_imp_decl(_mon2sb)
class uvm_apb_master_scoreboard #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_scoreboard;

  `uvm_component_utils(uvm_apb_master_scoreboard#(PM))

  uvm_apb_sequence_item queue_item[$];

  uvm_analysis_imp_mon2sb#(uvm_apb_sequence_item#(PM), uvm_apb_master_scoreboard#(PM)) analysis_imp_mon2sb;

  function new (string name="uvm_apb_master_scoreboard", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    analysis_imp_mon2sb = new("analysis_imp_mon2sb", this);
  endfunction: build_phase

  // monitor to scoreboard write function
  function void write_mon2sb(uvm_apb_sequence_item#(PM) item);
//  `uvm_info("SCB", $sformatf("Seq_item written from driver: \n"), UVM_HIGH)
//  item.print();  

//  `uvm_info(get_type_name(), $sformatf("Item Collected :\n%s", item.sprint()), UVM_LOW)    

          `uvm_info(get_type_name(), $sformatf("\n%s\n%s:\n%s"           ,
                                      get_full_name()                    ,
                                      "write_mon2sb"                     ,
                                      item.sprint()                     ),
                                      UVM_LOW                             )
  
//  `uvm_info(get_type_name, $sformatf("Received transaction = %s", item), UVM_LOW);

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


endclass : uvm_apb_master_scoreboard

// teddywhy@gmail.com

