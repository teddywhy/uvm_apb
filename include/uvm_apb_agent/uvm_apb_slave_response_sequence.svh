

class uvm_apb_slave_response_sequence #
(
  parameter apb_parameter_t PM  = apb_parameter
)
extends uvm_sequence#(uvm_apb_sequence_item#(PM), uvm_apb_sequence_item#(PM));

   `uvm_object_utils(uvm_apb_slave_response_sequence)

   uvm_tlm_analysis_fifo #(uvm_apb_sequence_item#(PM)) apb_slave_analysis_fifo       ;

// uvm_event                                           event_analysis_fifo           ;

   byte      memory [];

   function new(string name="uvm_apb_slave_response_sequence");
       super.new(name);
   endfunction : new


   virtual task pre_start();
      super.pre_start();

      memory = new[2**PM.ADDR_WIDTH];

//    event_analysis_fifo  = new();

      if ( !uvm_config_db #(uvm_tlm_analysis_fifo#(uvm_apb_sequence_item#(apb_parameter)))
                      ::get(null, "", "apb_slave_analysis_fifo", apb_slave_analysis_fifo)  )
          `uvm_fatal(get_type_name(),"The response uvm_tlm_analysis_fifo must be set!")

//    fork
//       forever begin
//          apb_slave_analysis_fifo.get(rsp);
//
//
//          `uvm_info(get_type_name(), $sformatf("pre_start() Item Got:\n%s", rsp.sprint()), UVM_LOW)
//
//          event_analysis_fifo.trigger;
//
//          `uvm_info(get_type_name(), "event_analysis_fifo triggered.", UVM_LOW)
//       end
//    join_none

   endtask


   virtual task body();
       uvm_apb_sequence_item#(PM) item;

       `uvm_info(get_type_name(), "uvm_apb_slave_response_sequence body() thread", UVM_LOW)

       item = new();

       fork
       	  forever begin

             apb_slave_analysis_fifo.get(rsp); // get sequence_item from TLM FIFO

             if(rsp.pwrite) begin
             	   for(int i=rsp.address[$clog2(PM.DATA_WIDTH/8)-1:0]; i<PM.DATA_WIDTH; i=i+1)
             	   	  if(rsp.strobe[i])  memory [rsp.address+i] = rsp.data[i*8 +: 8];
             end
             else begin
             	   for(int i=rsp.address[$clog2(PM.DATA_WIDTH/8)-1:0]; i<PM.DATA_WIDTH; i=i+1)
             	      rsp.data[i*8 +: 8] = memory[rsp.address+i];
             end

             // generate random number for rsp.wait_state
             item.randomize();
             rsp.wait_state = item.wait_state;

             `uvm_info(get_type_name(), $sformatf("\n%s\n%s:\n%s"          ,
                                                  get_full_name()          ,
                                                  "item responsed"         ,
                                                  rsp.sprint()            ),
                                                  UVM_LOW                   )

             `uvm_do_with(req, {
                                 req.address     ==  rsp.address     ;
                                 req.pwrite      ==  rsp.pwrite      ;
                                 req.strobe      ==  rsp.strobe      ;
                                 req.data        ==  rsp.data        ;
                                 req.slave_error ==  rsp.slave_error ;
                                 req.wait_state  ==  rsp.wait_state  ;
                               })

       	  end
       join_none

   endtask : body

endclass : uvm_apb_slave_response_sequence

// teddywhy@gmail.com

