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


module shift_register #(parameter N = 8)
        (input logic clk,
        input logic reset, load,
        input logic sin,
        input logic [N-1:0] d,
        output logic [N-1:0] q,
        output logic sout);
        
always_ff @(posedge clk, posedge reset)

    if (reset) q <= 0;
    else if (load) q <= d;
    else q <= {q[N-2:0], sin};

    assign sout = q[N-1];
endmodule