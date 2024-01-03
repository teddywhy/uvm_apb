

class uvm_apb_request_monitor #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_monitor;

   `uvm_component_param_utils(uvm_apb_request_monitor#(PM))
   
   virtual interface apb_interface #(PM) vif;
   
   uvm_analysis_port#(uvm_apb_sequence_item#(PM)) analysis_port ; // analysis port

   function new (string name="uvm_apb_monitor", uvm_component parent);
     super.new(name, parent);
   
     analysis_port  = new("analysis_port", this);
   endfunction : new

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)

    forever begin
    	uvm_apb_sequence_item #(PM) item = uvm_apb_sequence_item#(PM)::type_id::create("item", this); // Create collected item instance

      // capture the signals of the virtual interface and collected items as item_collected.
      // ...

      @(posedge this.vif.clk)
      begin
         if(this.vif.psel & (!this.vif.penable))
         begin
         	item.address = this.vif.paddr  ; 
         	item.strobe  = this.vif.pstrb  ;
         	item.pwrite  = this.vif.pwrite ;
         
          if(this.vif.pwrite)
            item.data = this.vif.pwdata ;
         
//        `uvm_info(get_type_name(), $sformatf("\n+++uvm_apb_request_monitor|item requested:\n%s", item.sprint()), UVM_LOW)

          $display("TEDDY REQUEST MONITOR");  

          `uvm_info(get_type_name(), $sformatf("\n%s\n%s:\n%s" , 
                                      get_full_name()          ,
                                      "item requested"         , 
                                      item.sprint()            ), 
                                      UVM_LOW                      )  
         
          analysis_port.write(item); // send the item to analysis port
         end
      end
      
    end // forever

  endtask: run_phase


endclass : uvm_apb_request_monitor
