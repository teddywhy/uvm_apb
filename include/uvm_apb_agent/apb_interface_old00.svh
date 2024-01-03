

interface apb_interface #
(
  parameter apb_parameter_t PM  = apb_parameter
)
(
  input                        clk      ,
  input                        reset_n  
);

  wire [PM.ADDR_WIDTH  -1:0]  paddr    ; // master  //
  wire                        pprot    ; // master  //
  wire                        psel     ; // master  // Select signal
  wire                        penable  ; // master  //
  wire                        pwrite   ; // master  //
  wire [PM.DATA_WIDTH  -1:0]  pwdata   ; // master  //
  wire [PM.DATA_WIDTH/8-1:0]  pstrb    ; // master  // Write Strobes
  wire                        pready   ; // slave   // Slave Ready Signal
  wire [PM.DATA_WIDTH  -1:0]  prdata   ; // slave   //
  wire                        pslverr  ; // slave   // Slave Error Response

    clocking master_cb @(posedge clk);
      default input #2ns output #2ns;     // default delay skew
      output   paddr   ;
      output   pprot   ;
      output   psel    ;
      output   penable ;
      output   pwrite  ;
      output   pwdata  ;
      output   pstrb   ;
      input    pready  ;
      input    prdata  ;
      input    pslverr ;
    endclocking 
  
    clocking slave_cb @(posedge clk);
      default input #2ns output #2ns;     // default delay skew
      input    paddr   ;
      input    pprot   ;
      input    psel    ;
      input    penable ;
      input    pwrite  ;
      input    pwdata  ;
      input    pstrb   ;
      output   pready  ;
      output   prdata  ;
      output   pslverr ;
    endclocking 
  
    clocking monitor_cb @(posedge clk);
      default input #2ns output #2ns;
      input    paddr   ;
      input    pprot   ;
      input    psel    ;
      input    penable ;
      input    pwrite  ;
      input    pwdata  ;
      input    pstrb   ;
      input    pready  ;
      input    prdata  ;
      input    pslverr ;
    endclocking

endinterface : apb_interface
