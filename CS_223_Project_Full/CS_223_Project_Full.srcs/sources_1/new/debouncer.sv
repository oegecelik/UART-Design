`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 03:30:23 PM
// Design Name: 
// Module Name: debouncer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//DISCLAIMER: I got this code from https://alchitry.com/metastability-and-debouncing-verilog.

module debouncer (
    input clk,
    input btn,
    output out
  );
 
  reg [19:0] ctr_d, ctr_q;
  reg [1:0] sync_d, sync_q;
 
  assign out = ctr_q == {20{1'b1}};
 
  always @(*) begin
    sync_d[0] = btn;
    sync_d[1] = sync_q[0];
    ctr_d = ctr_q + 1'b1;
 
    if (ctr_q == {20{1'b1}}) begin
      ctr_d = ctr_q;
    end
 
    if (!sync_q[1])
      ctr_d = 20'd0;
  end
 
  always @(posedge clk) begin
    ctr_q <= ctr_d;
    sync_q <= sync_d;
  end
 
endmodule
