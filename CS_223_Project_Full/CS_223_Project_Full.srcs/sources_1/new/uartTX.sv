`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 12:03:58 AM
// Design Name: 
// Module Name: uartTX
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


module uartTX #(parameter N = 8)(input logic [N-1:0] data,
                                 input logic reset,
                                 input logic btnd,
                                 input logic btnc,
                                 input logic clk,
                                 output logic [N-1:0] toShr,
                                 output logic tx,
                                 output reg [N-1:0] TXBUF [3:0],
                                 input logic mode                              
                                 );
logic cnt;
logic sout;
logic sreg_ld;
logic shift;
logic treg_ld;
logic treg_clr;
logic sreg_clr;
logic counter_clr;
logic [1:0] sel;   
logic counter_lt_N;  
logic isPressed = 0;
reg[10:0] counter  = 0;
reg[10:0] counterLimit = 11'b00010000000;
reg [1:0] modeCount = 0;
reg [1:0] modeLimit = 2'b11;

register transmitReg(clk, treg_clr, data, treg_ld, toShr);
shr shiftReg(clk, sreg_clr, sreg_ld, shift, 0, TXBUF[3], sout);
mux4 mux(0,1, sout, 0, sel, tx);
upCounter counter1(clk, cnt, counter_clr, counter_lt_N);

typedef enum logic [3:0]{S0, S1, debounceD, S2, waitLoad, S3, 
S4, S5, S6, S7, stopMode, waitMode, load0, loadLast} statetype;
statetype[1:0] state, nextstate;

//state register
always_ff@(posedge clk)
      if(reset) state <= S0;  
      else state <= nextstate;

//next state logic
always_comb
    case(state)
        S0:                     nextstate = S1;
        S1: begin 
        if(btnd)                nextstate = debounceD;
            else if (btnc)      nextstate = S4;
            else                nextstate = S1;
            end
        debounceD: 
        if(btnd)                nextstate = debounceD;
        else                    nextstate = S2;
        S2:                     nextstate = waitLoad;
        waitLoad:               nextstate = S3;
        S3: begin
          if(btnd)              nextstate = debounceD;
          else if (btnc)        nextstate = S4;  
                               
            else                nextstate = S3;
            end
        S4:                     nextstate = S5;
        S5: if(counter_lt_N)    nextstate = S5;
            else                nextstate = S6;
        S6: if(!mode)           nextstate = S7;
        else if (mode & modeCount >= modeLimit) nextstate = loadLast;
        else                    nextstate = stopMode;
        stopMode:               nextstate = waitMode;
        waitMode:               nextstate = load0;
        load0:                  nextstate = S4;
        loadLast:               nextstate = S7;
        S7: if(btnc)            nextstate = S7;
        else                    nextstate = S1;
        default:                nextstate = S0;
     endcase;
     
//output logic
assign sel[1] = (state == S5);
assign sel[0] = (state == S0 | state == S1 | state == debounceD |
  state == S2 | state == waitLoad | 
 state == S3 | state == S6 | state == S7
 | state == stopMode | state == waitMode | state == load0 | state == loadLast);
assign treg_clr = (state == S0);
assign sreg_clr = (state == S0);
assign counter_clr = (state == S0 | state == S4);
assign treg_ld = (state == S2 | state == load0 | state == loadLast);
assign sreg_ld = (state == S4);
assign cnt = (state == S5);
assign shift = (state == S5);

always_ff@(posedge clk)
if(state == S0)begin
TXBUF[0] = 0;
TXBUF[1] = 0;
TXBUF[2] = 0;
TXBUF[3] = 0;
end

else if (state == stopMode)
modeCount = modeCount + 1;

else if(state == load0 | state == loadLast)begin
TXBUF[0] <= 0;
TXBUF[1] <= TXBUF[0];
TXBUF[2] <= TXBUF[1];
TXBUF[3] <= TXBUF[2];
end

else if(state == waitLoad)begin
TXBUF[0] <= toShr;
TXBUF[1] <= TXBUF[0];
TXBUF[2] <= TXBUF[1];
TXBUF[3] <= TXBUF[2];
end

else if(state == S2 | state == S1)begin
modeCount = 0;
end             
endmodule
