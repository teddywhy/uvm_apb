
class uvm_reset_monitor 
extends uvm_monitor;

   `uvm_component_param_utils(uvm_reset_monitor)

  virtual interface reset_interface.passive vif;

  uvm_analysis_port#(uvm_reset_sequence_item) analysis_port ; // analysis port to be connected with scoreboard

  function new (string name="uvm_reset_monitor", uvm_component parent);
    super.new(name, parent);

    analysis_port  = new("analysis_port", this);
  endfunction : new

  task run_phase(uvm_phase phase);

//  super.run_phase(phase);

    int count;

    typedef enum 
    {
       IDLE          = '0 ,
       ASSERT_RESET          
    } state_t;

    state_t state;

    state             = IDLE ;

    count             = '0   ;

    forever begin
      uvm_reset_sequence_item item = uvm_reset_sequence_item::type_id::create("item", this); // Create collected item instance

      // capture the signals of the virtual interface and collected items as item_collected.

      @(this.vif.pcb)
      begin
      	 case(state)
      	 IDLE:         begin
      	 	                if(!this.vif.pcb.reset_n) begin
      	 	                   count = count + 1 ;
      	 	                   state = ASSERT_RESET ;
      	 	                end
      	 	                else
      	 	                   count = '0 ;
      	               end
      	 ASSERT_RESET: begin
      	 	               if(this.vif.pcb.reset_n) begin
      	 	               	  state = IDLE ;
      	 	               	  item.duration = count;
                            count = '0 ;
                            `uvm_info(get_type_name(), $sformatf("\n%s\n%s:\n%s" , 
                                                        get_full_name()          ,
                                                        "item collected"         , 
                                                        item.sprint()            ), 
                                                        UVM_LOW                      )  
                            
                            analysis_port.write(item); // send the item to scoreboard for checking
      	 	               end
      	 	               else 
      	 	                  count = count + 1 ;
      	               end            
         endcase
      end
      
    end // forever

  endtask: run_phase

endclass : uvm_reset_monitor
