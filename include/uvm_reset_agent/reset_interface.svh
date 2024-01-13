
interface reset_interface 
(
    input                        clk      
);

    wire  reset_n    ;

    clocking mcb @(posedge clk);
      default input #2ns output #2ns;     // default delay skew
      output   reset_n   ;
    endclocking 
    
    clocking pcb @(posedge clk);
      default input #2ns output #2ns;
      input    reset_n   ;
    endclocking

    modport master  (clocking mcb);
    modport passive (clocking pcb);
 
endinterface : reset_interface

