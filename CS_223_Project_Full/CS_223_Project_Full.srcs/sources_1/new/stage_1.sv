`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 12:02:54 PM
// Design Name: 
// Module Name: stage_1
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

//output logic [N-1:0] q for stage 2
module stage_1 #(parameter N = 8)(input logic [N-1:0] data,
                                 input logic mode,
                                 input logic reset,
                                 input logic btnL,
                                 input logic btnR,
                                 input logic btnU,
                                 input logic btnD,
                                 input logic btnC,
                                 input logic clk_in,
                                 output logic [N-1:0] toShr,
                                 output logic TX,
                                 input logic RX,
                                 output logic [1:0] ld,
                                 output logic ld15,
                                 output logic [6:0] seg,
                                 output logic [3:0] an
                                                              

    );
    
reg [N-1:0] TXBUF [3:0];
reg [N-1:0] RXBUF [3:0];

debouncer deb4(clk_in, btnC, btnc);
debouncer deb5(clk_in, btnD, btnd);

clock_generator newClock(clk_in, clk);
uartTX(data, reset, btnd, btnc, clk, toShr, TX, TXBUF, mode);
uartRX(clk, reset, RX, q, RXBUF);

clock_generator #(.N(10000)) newClock2 (clk_in, clkO);
debouncer deb1(clk_in, btnU, btnu);
debouncer deb2(clk_in, btnL, btnl);
debouncer deb3(clk_in, btnR, btnr);
display(clkO, reset, btnl, btnr, btnu, TXBUF, RXBUF, ld, ld15, seg, an);



endmodule
