
// `ifndef __UVM_APB_MASTER_DRIVER_SVH__
// `define __UVM_APB_MASTER_DRIVER_SVH__

class uvm_apb_master_driver #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_driver #
(
   uvm_apb_sequence_item #(PM)
);

  virtual apb_interface #(PM) vif;      

  `uvm_component_utils(uvm_apb_master_driver)

  function new (string name="uvm_apb_master_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

//function void build_phase(uvm_phase phase);
//    super.build_phase(phase);
//
//   if(!uvm_config_db#(virtual apb_interface#(PM))::get(this, "", "vif", vif))
//     `uvm_fatal("NO_VIF",{"virtual interface must be set for: ", get_full_name(), ".vif"});
//
//endfunction: build_phase
  
  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH) 
  endfunction : start_of_simulation_phase

  task run_phase(uvm_phase phase);
    // Gets packets from the sequencer and passes them to the driver. 

    vif.master_cb.psel    <= '0;
    vif.master_cb.penable <= '0;
    vif.master_cb.pstrb   <= '0;
    vif.master_cb.pwrite  <= '0;
    vif.master_cb.pwdata  <= '0;
    vif.master_cb.paddr   <= '0;
    vif.master_cb.pprot   <= '0;

    wait(vif.reset_n==0); 
    @(vif.master_cb);

    wait(vif.reset_n==1);
    @(vif.master_cb);

    forever 
    begin

      seq_item_port.get_next_item(req);       // Get new item from the sequencer

      `uvm_info(get_name(), "Write Packet received in master driver", UVM_LOW)
      req.print();
      
      trans(req);
      
      seq_item_port.item_done();              // Communicate item done to the sequencer

    end

  endtask : run_phase

  task trans(uvm_apb_sequence_item#(PM) item);
  
    if(item.pwrite)
    begin
      vif.master_cb.psel     <= 1             ;
      vif.master_cb.pwrite   <= 1             ;
      vif.master_cb.paddr    <= item.address  ;
      vif.master_cb.pwdata   <= item.data     ;
      vif.master_cb.penable  <= 0             ;
      vif.master_cb.pstrb    <= item.strobe   ;
      vif.master_cb.pprot    <= 0             ;
      @(vif.master_cb);
      
      vif.master_cb.penable  <= 1             ;
      @(vif.master_cb);                       
                                              
      wait(vif.master_cb.pready)              ;   
      vif.master_cb.penable  <= 0             ;
      vif.master_cb.psel     <= 0             ;      
      @(vif.master_cb);
    end         
    else
    begin
      vif.master_cb.psel     <= 1             ;
      vif.master_cb.pwrite   <= 0             ;
      vif.master_cb.paddr    <= item.address  ;
      vif.master_cb.penable  <= 0             ;
      vif.master_cb.pstrb    <= item.strobe   ;
      vif.master_cb.pprot    <= 0             ;
      @(vif.master_cb);
      
      vif.master_cb.penable  <= 1             ;
      @(vif.master_cb);                       
                                              
      wait(vif.master_cb.pready)              ;   
      vif.master_cb.penable  <= 0             ;
      vif.master_cb.psel     <= 0             ;      
      @(vif.master_cb);    	
    end
  
  endtask

endclass : uvm_apb_master_driver


// `endif

    