


module apb_sram #
(
     parameter     DATA_WIDTH      = 32             
   , parameter     ADDR_WIDTH      = 11             
   , parameter     DEPTH           = 2**(ADDR_WIDTH-$clog2(DATA_WIDTH/8))
   , parameter     DELAY           = 1

)
(
     input                               clk
   , input                               reset_n
                     
   , input           [ADDR_WIDTH  -1:0]  paddr    
   , input                               pprot    
   , input                               psel     
   , input                               penable  
   , input                               pwrite   
   , input           [DATA_WIDTH  -1:0]  pwdata   
   , input           [DATA_WIDTH/8-1:0]  pstrb    
   , output                              pready   
   , output logic    [DATA_WIDTH  -1:0]  prdata   
   , output                              pslverr     
);

  logic  [DATA_WIDTH-1:0] mem [DEPTH-1:0] ;
  
  logic  [4:0]              delay_count;
  
//logic  [DATA_WIDTH-1:0] t;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  // state machine 
  enum logic [1:0] 
  {
     IDLE   = '0 ,
     ACCESS      ,
     READY       ,
     ERROR
  }
  state, next_state;

  always_ff @(posedge clk or negedge reset_n)
    if(!reset_n) state <= IDLE ;
    else         state <= next_state ;

  always_comb
    case(state)
      IDLE   : if(psel && (!penable)) next_state = DELAY       ? ACCESS : READY  ;         
      ACCESS : if(psel && penable )   next_state = delay_count ? ACCESS : READY  ;
               else                   next_state = ERROR ;
      READY  : next_state = IDLE ; 
      ERROR  : next_state = IDLE ;
      default: next_state = IDLE ;  	
    endcase

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////   
  // delay_count 
  always_ff @(posedge clk or negedge reset_n)
    if(!reset_n)
      delay_count <= DELAY ; 
    else begin
    	if(state==READY || state==ERROR)
    	  delay_count <= DELAY;
    	else begin
    	     if(psel && (delay_count>0))
    	       delay_count <= delay_count - 1 ;
    	     else
    	       delay_count <= DELAY;
    	end
    end
      

  assign pready  = (state==ERROR) || (state==READY);
  assign pslverr = (state==ERROR) ;
  
  ///////////////////////////////////////////////////////
  
  // prdata
  always_ff @(posedge clk)
  begin
  	if(psel & (!pwrite)) prdata <= mem[ paddr[ADDR_WIDTH-1:$clog2(DATA_WIDTH/8)] ] ;
//  if(psel && (!pwrite)) prdata <= 32'h1234ABCD ;
  end
  
  // pwdata
  generate
  genvar i;
        
    for(i=0; i<DATA_WIDTH/8; i=i+1) begin
    
        always_ff @(posedge clk)        
        	if(psel & penable & pwrite & pstrb[i]) mem[ paddr[ADDR_WIDTH-1:$clog2(DATA_WIDTH/8)] ][i*8 +: 8] <= pwdata [i*8 +: 8] ;
  
    end

  endgenerate

//  always_ff @(posedge clk)
//  if(psel & penable & pwrite) t <= pwdata;
    
endmodule


