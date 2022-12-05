//
// Switch between two clock sources.
// In this design the output clock stays LOW between switching clocks.
// After a reset clk1 is selected.
// sel_clk2 is assumed to have a high/low duration of at least 2 clock
// periods of the slowest of clk1 or clk2.
// (If the above rule is not followed, certain pathological patterns of
//  sel_clk2 against the input clocks will produce low period violations)
//

// 
// Design by G.J. van Loo, FenLogic Ltd, 3-January-2017.
//
// This program is free software. It comes without any guarantees or
// warranty to the extent permitted by applicable law. Although the
// author has attempted to find and correct any bugs in this free software
// program, the author is not responsible for any damage or losses of any
// kind caused by the use or misuse of the program. You can redistribute
// the program and or modify it in any form without obligations, but the
// author would appreciated if the credits stays in.
// 


module clock_mux
   (
   input    clk1,      // Clock 1 supposed to be faster
   input    clk2,      // Clock 2  supposed to be slower
   input    reset_n,   // System reset
   input    sel_clk2,  // Select clock2 when high
   output   clk1or2    // Selected clock
   );

reg [1:0] meta1_off,sync1_off;
reg [1:0] meta1_on, sync1_on;
reg [1:0] meta2_off,sync2_off;
reg [1:0] meta2_on, sync2_on;


   always @(posedge clk1 or negedge reset_n)
   begin
      if (!reset_n)
      begin
         meta1_off <= 1'b0;
         sync1_off <= 1'b0;
         meta1_on  <= 1'b1;
         sync1_on  <= 1'b1;
      end
      else
      begin
         // Switch off when not selected
         meta1_off <= sel_clk2;
         sync1_off <= meta1_off;
         // Switch on when other clock (clk2) is off 
         meta1_on  <= sync2_off;
         sync1_on  <= meta1_on;
      end
   end

   always @(posedge clk2 or negedge reset_n)
   begin
      if (!reset_n)
      begin
         meta2_off <= 1'b1;
         sync2_off <= 1'b1;
         meta2_on  <= 1'b0;
         sync2_on  <= 1'b0;
      end
      else
      begin
         // Switch off when not selected
         meta2_off <= ~sel_clk2;
         sync2_off <= meta2_off;
         // Switch on when other clock (clk1) is off 
         meta2_on  <= sync1_off;
         sync2_on  <= meta2_on;
      end
   end

   assign clk1or2 = (clk1 & ~sync1_off & sync1_on  ) | 
                    (clk2 & ~sync2_off & sync2_on  );

endmodule // clock_rnux

