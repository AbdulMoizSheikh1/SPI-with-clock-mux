module top_tukka2(
`ifdef USE_POWER_PINS
    inout vdd,		// User area 5.0V supply
    inout vss,		// User area ground
`endif
input clk1,
input clk2,
input reset_n,
input sel_clk2,
input ss,
input mosi,
output miso,
input sck,
output done,
input [7:0] din,
output [7:0] dout
);


wire clk1or2;


spi_slave s1(
    .clk(clk1or2),
    .rst(reset_n),
    .ss(ss),
    .mosi(mosi),
    .miso(miso),
    .sck(sck),
    .done(done),
    .din(din),
    .dout(dout)
  );



clock_mux m1
   (
       .clk1(clk1),      // Clock 1 supposed to be faster
       .clk2(clk2),      // Clock 2  supposed to be slower
       .reset_n(reset_n),   // System reset
       .sel_clk2(sel_clk2),  // Select clock2 when high
       .clk1or2(clk1or2)    // Selected clock
   );

endmodule
