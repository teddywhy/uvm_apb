

   import uvm_pkg::*;

   `include "uvm_macros.svh"

   `include "uvm_reset.svh"

   `include "uvm_apb.svh"
                                   
   `include "uvm_apb_master_test.svh"     



module testbench;

  bit clk     ;
 
  apb_interface #(apb_parameter)     intf       (.clk(clk));

  reset_interface                    intf_reset (.clk(clk));
   
  initial
  begin
  	clk = 1;
  	
  	forever  #5ns clk = ~clk ;  	
  end

  initial 
  begin
     uvm_config_db#(virtual apb_interface#(apb_parameter))::set(null, "*.apb_master_agent", "vif", intf);

     uvm_config_db#(virtual reset_interface              )::set(null, "*.reset_agent",      "vif", intf_reset);

     run_test();
  end
  

//  apb_v3_sram #
//  (  
//      .ADDR_BUS_WIDTH     (apb_parameter.ADDR_WIDTH   ),    // ADDR BUS Width
//      .DATA_BUS_WIDTH     (apb_parameter.DATA_WIDTH   ),    // Data Bus Width
//      .MEMSIZE            (2*1024*1024                ),    // RAM Size
//      .MEM_BLOCK_SIZE     (16                         ),    // Each memory block size in RAM
//      .RESET_VAL          (0                          ),    // Reset value of RAM
//      .EN_WAIT_DELAY_FUNC (0                          ),    // Enable Slv wait state
//      .MIN_RAND_WAIT_CYC  (1                          ),    // Min Slv wait delay in clock cycles
//      .MAX_RAND_WAIT_CYC  (2                          )     // Max Slv wait delay in clock cycles
//  )                       
//  dut                     
//  (                       
//      .PRESETn            (reset_n                    ),     // Active low Reset
//      .PCLK               (clk                        ),     // 100MHz clock
//      .PSEL               (intf.psel                  ),     // Select Signal
//      .PENABLE            (intf.penable               ),     // Enable Signal
//      .PWRITE             (intf.pwrite                ),     // Write Strobe
//      .PADDR              (intf.paddr                 ),     // Addr
//      .PWDATA             (intf.pwdata                ),     // Write data
//      .PRDATA             (intf.prdata                ),     // Read data
//      .PREADY             (intf.pready                ),     // Slave Ready
//      .PSLVERR            (intf.pslverr               )      // Slave Error Response
//  );


  apb_sram #
  (
      .DATA_WIDTH (apb_parameter.DATA_WIDTH   ), 
      .ADDR_WIDTH (apb_parameter.ADDR_WIDTH   ),
//    .DEPTH      (                           ),
      .DELAY      (1                          )  
  )
  dut
  (
      .clk        (clk                        ), // input                                
      .reset_n    (intf_reset.reset_n         ), // input                                
                                          
      .paddr      (intf.paddr                 ), // input           [ADDR_WIDTH  -1:0]   
      .pprot      (intf.pprot                 ), // input                                
      .psel       (intf.psel                  ), // input                                
      .penable    (intf.penable               ), // input                                
      .pwrite     (intf.pwrite                ), // input                                
      .pwdata     (intf.pwdata                ), // input           [DATA_WIDTH  -1:0]   
      .pstrb      (intf.pstrb                 ), // input           [DATA_WIDTH/8-1:0]   
      .pready     (intf.pready                ), // output                               
      .prdata     (intf.prdata                ), // output logic    [DATA_WIDTH  -1:0]   
      .pslverr    (intf.pslverr               )  // output                               
  );


  
endmodule

