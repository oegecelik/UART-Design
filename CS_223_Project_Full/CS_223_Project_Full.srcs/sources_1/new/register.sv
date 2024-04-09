`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 11:59:23 PM
// Design Name: 
// Module Name: register
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


module register #(parameter N = 8)(input logic clk,
input logic reset,
input logic [N-1:0] d,
input logic btnd,
output logic [N-1:0] q);
always_ff @(posedge clk)
    if(reset) q <= 0;
    else if (btnd) q <= d;
endmodule