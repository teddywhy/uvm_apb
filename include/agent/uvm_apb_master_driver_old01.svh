
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

    typedef enum {IDLE='0, SETUP, WAIT_READY, READY} state_t;

    state_t state;

    state             = IDLE ;

    this.vif.psel    <= '0;
    this.vif.penable <= '0;
    this.vif.pstrb   <= '0;
    this.vif.pwrite  <= '0;
    this.vif.pwdata  <= '0;
    this.vif.paddr   <= '0;
    this.vif.pprot   <= '0;

    @(negedge vif.reset_n);

    @(posedge vif.reset_n);
    `uvm_info(get_type_name(),"reset_n asserted!", UVM_MEDIUM)


    forever begin

      @(posedge this.vif.clk)      
      begin
        case(state)
        IDLE:        begin
                       
                       seq_item_port.try_next_item(req);
                       
                       if(req != null)
                       begin

                          `uvm_info(get_type_name(), $sformatf("\n%s\n%s:\n%s" , 
                                                      get_full_name()          ,
                                                      "item received"          , 
                                                      req.sprint()            ), 
                                                      UVM_LOW                      )  
                  	  
                          this.vif.psel    <= '1;
                          this.vif.penable <= '0; 
                          this.vif.pstrb   <= req.strobe;
                          this.vif.pprot   <= '0;
                          this.vif.pwrite  <= req.pwrite;
                          this.vif.paddr   <= req.address;
                          
                          if(req.pwrite)
                          begin
                            this.vif.pwdata  <= req.data;
                          end
                       
                          state = SETUP;
                       end
                       else
                       begin
                          this.vif.psel    <= '0;
                          this.vif.penable <= '0;
                       end                     
                       
                     end
                     
        SETUP:       begin
                       this.vif.penable <= '1;
                       state = WAIT_READY ;       	
        	           end
        	           
        WAIT_READY:  begin
                          if(this.vif.pready)
                          begin                                                        
                          	   seq_item_port.item_done();   
                          
                              seq_item_port.try_next_item(req);
                              
                              if(req != null)
                              begin

                                  `uvm_info(get_type_name(), $sformatf("\n%s\n%s:\n%s" , 
                                                              get_full_name()          ,
                                                              "item received"          , 
                                                              req.sprint()            ), 
                                                              UVM_LOW                      )  
                              	
                                  this.vif.psel    <= '1;
                                  this.vif.penable <= '0; 
                                  this.vif.pstrb   <= req.strobe;
                                  this.vif.pprot   <= '0;
                                  this.vif.pwrite  <= req.pwrite;
                                  this.vif.paddr   <= req.address;
                                  
                                  if(req.pwrite)
                                  begin
                                    this.vif.pwdata  <= req.data;
                                  end
                                  
                              	   state = SETUP;
                              end                     
                              else
                              begin
                                  this.vif.psel    <= '0;
                                  this.vif.penable <= '0;
                                  this.vif.pstrb   <= ~this.vif.pstrb  ;
                                  this.vif.pwrite  <= ~this.vif.pwrite ;
                                  this.vif.paddr   <= ~this.vif.paddr  ;
                                  this.vif.pwdata  <= ~this.vif.pwdata ;
                                  
                                  state = IDLE ;       	                       	                                          
                              end
                          end
                     end
        
        endcase
      end
    end // forever

  endtask : run_phase

//  task trans(uvm_apb_sequence_item#(PM) item);
//  
//    if(item.pwrite)
//    begin
//      vif.master_cb.psel     <= 1             ;
//      vif.master_cb.pwrite   <= 1             ;
//      vif.master_cb.paddr    <= item.address  ;
//      vif.master_cb.pwdata   <= item.data     ;
//      vif.master_cb.penable  <= 0             ;
//      vif.master_cb.pstrb    <= item.strobe   ;
//      vif.master_cb.pprot    <= 0             ;
//      @(vif.master_cb);
//      
//      vif.master_cb.penable  <= 1             ;
//      @(vif.master_cb);                       
//                                              
//      wait(vif.master_cb.pready)              ;   
//      vif.master_cb.penable  <= 0             ;
//      vif.master_cb.psel     <= 0             ;      
//      @(vif.master_cb);
//    end         
//    else
//    begin
//      vif.master_cb.psel     <= 1             ;
//      vif.master_cb.pwrite   <= 0             ;
//      vif.master_cb.paddr    <= item.address  ;
//      vif.master_cb.penable  <= 0             ;
//      vif.master_cb.pstrb    <= item.strobe   ;
//      vif.master_cb.pprot    <= 0             ;
//      @(vif.master_cb);
//      
//      vif.master_cb.penable  <= 1             ;
//      @(vif.master_cb);                       
//                                              
//      wait(vif.master_cb.pready)              ;   
//      vif.master_cb.penable  <= 0             ;
//      vif.master_cb.psel     <= 0             ;      
//      @(vif.master_cb);    	
//    end
//  
//  endtask

endclass : uvm_apb_master_driver


// `endif

    