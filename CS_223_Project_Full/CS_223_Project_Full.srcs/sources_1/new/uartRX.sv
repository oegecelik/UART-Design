`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 12:04:15 AM
// Design Name: 
// Module Name: uartRX
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


module uartRX #(parameter N = 8)(input logic clk, reset, RX,
output logic [N-1:0] q,
output reg [N-1:0] RXBUF [3:0] 
    );

logic sreg_clr;
logic rxreg_clr;
logic counter_clr;
logic sreg_ld;
logic shift;
logic rxreg_ld;
logic cnt;
logic counter_lt_N;
logic sout;
logic [N-1:0] toRxReg;

shr shr2(clk, sreg_clr, 0, shift, RX, 0, sout, toRxReg);
register rxReg(clk, rxreg_clr, toRxReg, rxreg_ld, q);
upCounter counter2(clk, cnt, counter_clr, counter_lt_N);

typedef enum logic [2:0]{S0, S1, S2, S3, S4, S5, S6, loadRXBUF} statetype;
statetype[1:0] state, nextstate;

//state register
always_ff@(posedge clk)
     if(reset) state <= S0;
     else state <= nextstate;

//next state logic
always_comb
    case(state)
        S0:                     nextstate = S1;
        S1: if (RX)             nextstate = S1;
            else                nextstate = S2;
        S2: if(counter_lt_N)    nextstate = S2;
            else                nextstate = S3;
        S3: if(RX)              nextstate = S4;
            else                nextstate = S0;
        S4: if(RX)              nextstate = S5;
            else                nextstate = S0;
        S5:                     nextstate = loadRXBUF;
        loadRXBUF:              nextstate = S1;
        default:                nextstate = S0;
     endcase;
     
//output logic
assign rxreg_clr = (state == S0);
assign sreg_clr = (state == S0 | state == S1);
assign counter_clr = (state == S0 | state == S1);
assign rxreg_ld = (state == S5);
assign sreg_ld = 0;
assign cnt = (state == S2);
assign shift = (state == S2);

always_ff@(posedge clk)
if(state == S0)begin
RXBUF[0] <= 0;
RXBUF[1] <= 0;
RXBUF[2] <= 0;
RXBUF[3] <= 0;
end

else if(state == loadRXBUF)begin
RXBUF[0] <= toRxReg;
RXBUF[1] <= RXBUF[0];
RXBUF[2] <= RXBUF[1];
RXBUF[3] <= RXBUF[2];
end

endmodule
