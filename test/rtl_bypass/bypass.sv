

module bypass #
(
    parameter ADDR_WIDTH = 11 ,
    parameter DATA_WIDTH = 32
)
(
     input                      clk
   , input                      reset_n

   , output  [ADDR_WIDTH  -1:0] master_paddr   
   , output                     master_pprot   
   , output                     master_psel    
   , output                     master_penable 
   , output                     master_pwrite  
   , output  [DATA_WIDTH  -1:0] master_pwdata  
   , output  [DATA_WIDTH/8-1:0] master_pstrb   
   , input                      master_pready  
   , input   [DATA_WIDTH  -1:0] master_prdata  
   , input                      master_pslverr 

   , input   [ADDR_WIDTH  -1:0] slave_paddr   
   , input                      slave_pprot   
   , input                      slave_psel    
   , input                      slave_penable 
   , input                      slave_pwrite  
   , input   [DATA_WIDTH  -1:0] slave_pwdata  
   , input   [DATA_WIDTH/8-1:0] slave_pstrb   
   , output                     slave_pready  
   , output  [DATA_WIDTH  -1:0] slave_prdata  
   , output                     slave_pslverr 
   
);

   
   assign master_paddr    = slave_paddr    ;    
   assign master_pprot    = slave_pprot    ;
   assign master_psel     = slave_psel     ;
   assign master_penable  = slave_penable  ;
   assign master_pwrite   = slave_pwrite   ;
   assign master_pwdata   = slave_pwdata   ;
   assign master_pstrb    = slave_pstrb    ;

   assign slave_pready    = master_pready  ;  
   assign slave_prdata    = master_prdata  ;  
   assign slave_pslverr   = master_pslverr ;  

endmodule
