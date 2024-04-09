`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 10:31:48 PM
// Design Name: 
// Module Name: upCounter
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


module upCounter #(parameter N = 8)
(input logic clk,
input logic cnt,
input logic reset,
output logic counter_lt_N
);
logic [N-1: 0] q;
always_ff @(posedge clk)
if (reset) q <= 0;
else if(cnt) q <= q + 1;

assign counter_lt_N = (q < N-1);
endmodule