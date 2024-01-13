
class uvm_reset_driver 
extends uvm_driver #
(
   uvm_reset_sequence_item
);

  virtual reset_interface.master vif;

  `uvm_component_utils(uvm_reset_driver)

  function new (string name="uvm_reset_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase

  task run_phase(uvm_phase phase);

    this.vif.mcb.reset_n <= '1;

    forever
    begin
          seq_item_port.get_next_item(req);

          repeat(req.delay) @(this.vif.mcb);

          this.vif.mcb.reset_n <= '0;

          repeat(req.duration) @(this.vif.mcb);

          this.vif.mcb.reset_n <= '1;

          @(this.vif.mcb);

          seq_item_port.item_done();
    end // forever end

  endtask : run_phase

endclass : uvm_reset_driver
