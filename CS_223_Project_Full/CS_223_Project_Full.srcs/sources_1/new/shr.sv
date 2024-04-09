`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 10:24:43 PM
// Design Name: 
// Module Name: shift_register
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


module shr #(parameter N = 8)
        (input logic clk,
        input logic reset, load, shift,
        input logic sin,
        input logic [N-1:0] d,
        output logic sout,
        output logic [N-1:0] q
);
always_ff @(posedge clk)
    if (reset) q <= 0;
    else if (load) q <= d;
    else if (shift) q <= {sin, q[N-1:1]};  
    assign sout = q[0];
endmodule