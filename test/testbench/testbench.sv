
   import uvm_pkg::*;

   `include "uvm_macros.svh"

   `include "uvm_reset.svh"

   `include "uvm_apb.svh"

   `include "uvm_apb_test.svh"

module testbench;

  bit clk     ;
 
  apb_interface     #(apb_parameter) intf_m     (.clk(clk));
  apb_interface     #(apb_parameter) intf_s     (.clk(clk));
  
  reset_interface                    intf_reset (.clk(clk));
 
  initial
  begin
  	clk = 0;
  	
  	forever  #5ns clk = ~clk ;  	
  end


  initial 
  begin
  	  	
     uvm_config_db#(virtual apb_interface#(apb_parameter))::set(null, "*.apb_master_agent", "vif", intf_m);
     uvm_config_db#(virtual apb_interface#(apb_parameter))::set(null, "*.apb_slave_agent",  "vif", intf_s);

     uvm_config_db#(virtual reset_interface              )::set(null, "*.reset_agent",      "vif", intf_reset);

     run_test();
  end
  

  bypass #
  (
     .ADDR_WIDTH       (apb_parameter.ADDR_WIDTH           )
   , .DATA_WIDTH       (apb_parameter.DATA_WIDTH           )
  
  )
  dut
  (
     .clk              (clk                                )  // input                     
   , .reset_n          (intf_reset.reset_n                 )  // input                     

   , .master_paddr     (intf_s.paddr                       )  // output  [ADDR_WIDTH  -1:0]
   , .master_pprot     (intf_s.pprot                       )  // output                    
   , .master_psel      (intf_s.psel                        )  // output                    
   , .master_penable   (intf_s.penable                     )  // output                    
   , .master_pwrite    (intf_s.pwrite                      )  // output                    
   , .master_pwdata    (intf_s.pwdata                      )  // output  [DATA_WIDTH  -1:0]
   , .master_pstrb     (intf_s.pstrb                       )  // output  [DATA_WIDTH/8-1:0]
   , .master_pready    (intf_s.pready                      )  // input                     
   , .master_prdata    (intf_s.prdata                      )  // input   [DATA_WIDTH  -1:0]
   , .master_pslverr   (intf_s.pslverr                     )  // input                     

   , .slave_paddr      (intf_m.paddr                       )  // input   [ADDR_WIDTH  -1:0]
   , .slave_pprot      (intf_m.pprot                       )  // input                     
   , .slave_psel       (intf_m.psel                        )  // input                     
   , .slave_penable    (intf_m.penable                     )  // input                     
   , .slave_pwrite     (intf_m.pwrite                      )  // input                     
   , .slave_pwdata     (intf_m.pwdata                      )  // input   [DATA_WIDTH  -1:0]
   , .slave_pstrb      (intf_m.pstrb                       )  // input   [DATA_WIDTH/8-1:0]
   , .slave_pready     (intf_m.pready                      )  // output                    
   , .slave_prdata     (intf_m.prdata                      )  // output  [DATA_WIDTH  -1:0]
   , .slave_pslverr    (intf_m.pslverr                     )  // output                    
  );


  
endmodule