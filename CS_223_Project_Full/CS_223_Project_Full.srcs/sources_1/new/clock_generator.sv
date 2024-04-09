`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 12:04:33 AM
// Design Name: 
// Module Name: clock_generator
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


module clock_generator# (parameter N = 9600)(input logic clk_in,
                     output logic clk);
reg [30:0] counter;
reg clk_out = 0;
    always@(posedge clk_in)
    begin
    counter <= counter+1;
    if(counter == 50000000/N)
    begin
    counter <= 0;
    clk_out = ~clk_out;
    end
    end
    
assign clk = clk_out;
    
endmodule
