
// `ifndef __UVM_APB_MONITOR_SVH__   
// `define __UVM_APB_MONITOR_SVH__   

class uvm_apb_monitor #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_monitor;

   `uvm_component_param_utils(uvm_apb_monitor#(PM))

  virtual interface apb_interface #(PM) vif;

  uvm_analysis_port#(uvm_apb_sequence_item#(PM)) analysisport ; // analysis port to be connected with scoreboard

  function new (string name="uvm_apb_monitor", uvm_component parent);
    super.new(name, parent);

    analysisport  = new("analysisport", this);
  endfunction : new

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)

    forever begin
    	uvm_apb_sequence_item #(PM) item = uvm_apb_sequence_item#(PM)::type_id::create("item", this); // Create collected item instance

      // capture the signals of the virtual interface and collected items as item_collected.
      // ...

      if(vif.monitor_cb.psel && vif.monitor_cb.penable && vif.monitor_cb.pready)
      begin
      	item.address = vif.monitor_cb.paddr  ;
      	item.pwrite  = vif.monitor_cb.pwrite ;

        if(vif.monitor_cb.pwrite)
          item.data = vif.monitor_cb.pwdata ;
        else
      	  item.data = vif.monitor_cb.prdata ;

        `uvm_info(get_type_name(), $sformatf("Item Collected :\n%s", item.sprint()), UVM_LOW)

        analysisport.write(item); // send the item to scoreboard for checking
      end
      @(vif.monitor_cb);
    end

  endtask: run_phase

endclass : uvm_apb_monitor

// `endif
