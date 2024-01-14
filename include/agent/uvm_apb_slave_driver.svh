// `ifndef __UVM_APB_SLAVE_DRIVER_SVH__
// `define __UVM_APB_SLAVE_DRIVER_SVH__


class uvm_apb_slave_driver #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_driver #
(
   uvm_apb_sequence_item #(PM)
);

  virtual apb_interface #(PM).slave vif;

  `uvm_component_utils(uvm_apb_slave_driver)

  function new (string name="uvm_apb_slave_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

//function void build_phase(uvm_phase phase);
//   super.build_phase(phase);
//
//   if(!uvm_config_db#(virtual apb_interface#(PM))::get(this, "", "vif", vif))
//     `uvm_fatal("NO_VIF",{"virtual interface must be set for: ", get_full_name(), ".vif"});
//
//endfunction: build_phase

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase

  task run_phase(uvm_phase phase);

    typedef enum {IDLE='0, SETUP, WAIT_READY, READY} state_t;

    state_t state;

    state             = IDLE ;

    this.vif.scb.pready    <= '0;
    this.vif.scb.pslverr   <= '0;

//  @(negedge this.vif.scb.reset_n);
//
//  @(posedge this.vif.scb.reset_n);
//  `uvm_info(get_type_name(),"reset_n asserted!", UVM_LOW)

    forever
    begin
          seq_item_port.get_next_item(req);

          `uvm_info(get_type_name(), $sformatf("\n%s\n%s:\n%s"           ,
                                      get_full_name()                    ,
                                      "seq_item_port.get_next_item(req)" ,
                                      req.sprint()                      ),
                                      UVM_LOW                             )

          repeat(req.wait_state) @(this.vif.scb);

          this.vif.scb.prdata    <= req.data;
          this.vif.scb.pslverr   <= req.slave_error;
          this.vif.scb.pready    <= '1;

          @(this.vif.scb);

          this.vif.scb.prdata    <= ~req.data;
          this.vif.scb.pready    <= '0;
          this.vif.scb.pslverr   <= '0;

          seq_item_port.item_done();
    end // forever end

  endtask : run_phase

endclass : uvm_apb_slave_driver

// `endif

// teddywhy@gmail.com

