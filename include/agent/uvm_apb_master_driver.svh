
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

  virtual apb_interface #(PM).master vif;      

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

  // drive sequence_item to interface signals
  virtual task drive(uvm_apb_sequence_item#(PM) item);
   
                               `uvm_info(get_type_name(), $sformatf("\n%s\n%s:\n%s"                     , 
                                                           get_full_name()                              ,
                                                           "drive sequence_item to interface signals "  , 
                                                           item.sprint()                               ), 
                                                           UVM_LOW                      )  
                  	           
                               this.vif.mcb.psel    <= '1;
                               this.vif.mcb.penable <= '0; 
                               this.vif.mcb.pstrb   <= item.strobe;
                               this.vif.mcb.pprot   <= '0;
                               this.vif.mcb.pwrite  <= item.pwrite;
                               this.vif.mcb.paddr   <= item.address;
                               
                               if(item.pwrite)
                               begin
                                  this.vif.mcb.pwdata  <= item.data;
                               end  
  endtask


  task run_phase(uvm_phase phase);

    uvm_apb_sequence_item #(PM) item_tmp;

    int delay_count;
    
    typedef enum 
    {
       IDLE        = '0 ,
       DELAY            , 
       SETUP            , 
       WAIT_READY       , 
       READY
    } state_t;

    state_t state;

    state             = IDLE ;

    this.vif.mcb.psel    <= '0;
    this.vif.mcb.penable <= '0;
    this.vif.mcb.pstrb   <= '0;
    this.vif.mcb.pwrite  <= '0;
    this.vif.mcb.pwdata  <= '0;
    this.vif.mcb.paddr   <= '0;
    this.vif.mcb.pprot   <= '0;

//  @(negedge this.vif.mcb.reset_n);
//
//  @(negedge this.vif.mcb.reset_n);
//  `uvm_info(get_type_name(),"reset_n asserted!", UVM_MEDIUM)


    forever begin

      @(this.vif.mcb)      
      begin
        case(state)
        IDLE:        begin
                       
                        seq_item_port.try_next_item(req);
                        
                        if(req != null)
                        begin                        	       
                           `uvm_info(get_type_name(), $sformatf("\n%s\n%s:\n%s"                 , 
                                                       get_full_name()                          ,
                                                       "seq_item_port.try_next_item(req) IDLE"  , 
                                                       req.sprint()                            ), 
                                                       UVM_LOW                      )  

                        	 item_tmp = req;
                        	 
                        	 if(req.delay>0)
                        	 begin
                        	 	   delay_count = req.delay - 1 ;
                        	 	   
                        	 	   this.vif.mcb.psel    <= '0               ; 
                               this.vif.mcb.penable <= '0               ;  
                               this.vif.mcb.pstrb   <= ~req.strobe      ;
                               this.vif.mcb.pwrite  <= ~req.pwrite      ;
                               this.vif.mcb.paddr   <= ~req.address     ;
                               this.vif.mcb.pwdata  <= ~req.data        ;
                               
                        	 	   state = DELAY;
                        	 end
                        	 else
                        	 begin
                               
                               drive(req);
                               
                               state = SETUP;
                           end
                        end
                        else
                        begin
                            this.vif.mcb.psel    <= '0;
                            this.vif.mcb.penable <= '0;
                        end                     
                       
                     end
                     
        DELAY:       begin
        	              if(delay_count)
        	              begin
        	              	 delay_count = delay_count - 1;
        	              end
        	              else
        	              begin
                           
                           drive(req);
                           
                           state = SETUP;        	              	 
        	              end
                     end 
                                 
        SETUP:       begin
                        this.vif.mcb.penable <= '1;
                        state = WAIT_READY ;       	
        	           end
        	           
        WAIT_READY:  begin
                          if(this.vif.mcb.pready)
                          begin                                                        
                          	  seq_item_port.item_done();   
                          
                              seq_item_port.try_next_item(req); // try to get next sequence_item
                              
                              if(req != null)
                              begin
                                  `uvm_info(get_type_name(), $sformatf("\n%s\n%s:\n%s"                       , 
                                                              get_full_name()                                ,
                                                              "seq_item_port.try_next_item(req) WAIT_READY"  , 
                                                              req.sprint()                                  ), 
                                                              UVM_LOW                      )  
                              	  
                              	  item_tmp = req;
                              	
                                	if(req.delay)
                                	begin
                                		   delay_count = req.delay - 1 ;
                        	 	           
                        	 	           this.vif.mcb.psel    <= '0               ;
                                       this.vif.mcb.penable <= '0               ;                                		   
                                       this.vif.mcb.pstrb   <= ~req.strobe      ;
                                       this.vif.mcb.pwrite  <= ~req.pwrite      ;
                                       this.vif.mcb.paddr   <= ~req.address     ;
                                       this.vif.mcb.pwdata  <= ~req.data        ;
                                		   
                                		   state = DELAY;
                                	end
                               	  else
                               	  begin
                                       drive(req);
                                     
                              	       state = SETUP;
                              	  end
                              end                     
                              else
                              begin
                                  this.vif.mcb.psel    <= '0;
                                  this.vif.mcb.penable <= '0;

                                  this.vif.mcb.pstrb   <= ~item_tmp.strobe   ;
                                  this.vif.mcb.pwrite  <= ~item_tmp.pwrite   ;
                                  this.vif.mcb.paddr   <= ~item_tmp.address  ;
                                  this.vif.mcb.pwdata  <= ~item_tmp.data     ;

//                                this.vif.mcb.pstrb   <= '0;
//                                this.vif.mcb.pwrite  <= '0;
//                                this.vif.mcb.paddr   <= '0;
//                                this.vif.mcb.pwdata  <= '0;
                                  
                                  state = IDLE ;       	                       	                                          
                              end
                          end
                     end
        
        endcase
      end
    end // forever

  endtask : run_phase


endclass : uvm_apb_master_driver


// `endif

    