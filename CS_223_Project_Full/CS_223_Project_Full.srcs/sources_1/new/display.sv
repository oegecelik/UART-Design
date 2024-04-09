`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 02:23:32 AM
// Design Name: 
// Module Name: display
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


module display #(parameter N = 8)(input logic clk,
input logic reset,
input logic btnl,
input logic btnr,
input logic btnu,
input reg [N-1:0] TXBUF [3:0],
input reg [N-1:0] RXBUF [3:0],
output logic [1:0] ld,
output logic ld15,
output logic [6:0] seg,
output logic [3:0] an);

reg[3:0] fourth, third, second, first;

typedef enum logic [3:0]{S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11} statetype;
statetype[1:0] state, nextstate;

//state register
always_ff@(posedge clk)
      if(reset) state <= S0;  
      else state <= nextstate;


//next state logic
always_comb
    case(state)
        S0: if(btnu)            nextstate = S1;
        else if(btnl | btnr)    nextstate = S4;
        else                    nextstate = S0; 
        S1: if(btnu)            nextstate = S1;
            else                nextstate = S2;
        S2: if(btnu)            nextstate = S3;
        else if(btnl | btnr)    nextstate = S10;
        else                    nextstate = S2;                      
        S3: if(btnu)            nextstate = S3;             
            else                nextstate = S0;
        S4: if(btnr | btnl)     nextstate = S4;
        else                    nextstate = S5;
        S5: if(btnu)            nextstate = S7;
        else if (btnr | btnl)   nextstate = S6;
        else                    nextstate = S5;
        S6: if(btnr|btnl)       nextstate = S6;
        else                    nextstate = S0;
        S7: if(btnu)            nextstate = S7;
        else                    nextstate = S8;
        S8: if(btnu)            nextstate = S9;
        else if (btnl | btnr)   nextstate = S11;
        else                    nextstate = S8;
        S9: if(btnu)            nextstate = S9;
        else                    nextstate = S5;
        S10: if(btnr | btnl)    nextstate = S10;
        else                    nextstate = S8;
        S11: if(btnr | btnl)    nextstate = S11;
        else                    nextstate = S2;
        default:                nextstate = S0;
     endcase;

always @ (*)
begin
    case(state)
    S0: begin
            first = TXBUF[0][7:4];
            second = TXBUF[0][3:0];
            third = TXBUF[1][7:4];
            fourth = TXBUF[1][3:0];
            ld15 = 0;
            ld = 2'b10;
        end
    S1: begin
            first = RXBUF[0][7:4];
            second = RXBUF[0][3:0];
            third = RXBUF[1][7:4];
            fourth = RXBUF[1][3:0];
            ld15 = 1;
            ld = 2'b10;
        end
     S2: begin
            first = RXBUF[0][7:4];
            second = RXBUF[0][3:0];
            third = RXBUF[1][7:4];
            fourth = RXBUF[1][3:0];
            ld15 = 1;
            ld = 2'b10;
        end
     S3: begin
            first = TXBUF[0][7:4];
            second = TXBUF[0][3:0];
            third = TXBUF[1][7:4];
            fourth = TXBUF[1][3:0];
            ld15 = 0;
            ld = 2'b10;
        end
    S4: begin
            first = TXBUF[2][7:4];
            second = TXBUF[2][3:0];
            third = TXBUF[3][7:4];
            fourth = TXBUF[3][3:0];
            ld15 = 0;
            ld = 2'b01;
        end
    S5: begin
            first = TXBUF[2][7:4];
            second = TXBUF[2][3:0];
            third = TXBUF[3][7:4];
            fourth = TXBUF[3][3:0];
            ld15 = 0;
            ld = 2'b01;
        end 
    S6: begin
            first = TXBUF[0][7:4];
            second = TXBUF[0][3:0];
            third = TXBUF[1][7:4];
            fourth = TXBUF[1][3:0];
            ld15 = 0;
            ld = 2'b10;
        end
    S7: begin
            first = RXBUF[2][7:4];
            second = RXBUF[2][3:0];
            third = RXBUF[3][7:4];
            fourth = RXBUF[3][3:0];
            ld15 = 1;
            ld = 2'b01;
        end
    S8: begin
            first = RXBUF[2][7:4];
            second = RXBUF[2][3:0];
            third = RXBUF[3][7:4];
            fourth = RXBUF[3][3:0];
            ld15 = 1;
            ld = 2'b01;
        end   
    S9: begin
            first = TXBUF[2][7:4];
            second = TXBUF[2][3:0];
            third = TXBUF[3][7:4];
            fourth = TXBUF[3][3:0];
            ld15 = 0;
            ld = 2'b01;
        end 
    S10: begin
            first = RXBUF[2][7:4];
            second = RXBUF[2][3:0];
            third = RXBUF[3][7:4];
            fourth = RXBUF[3][3:0];
            ld15 = 1;
            ld = 2'b01;
        end
    S11: begin
            first = RXBUF[0][7:4];
            second = RXBUF[0][3:0];
            third = RXBUF[1][7:4];
            fourth = RXBUF[1][3:0];
            ld15 = 1;
            ld = 2'b10;
        end                    
    endcase
    
end

reg[1:0] count;
always @ (posedge clk)
begin
    if(reset)
        count <=0;
    else
        count <= count + 1;
end

reg[3:0] Y;
reg[3:0]an_temp;

always @(*)
begin
    case(count[1:0])
    
    2'b00: begin
        Y = fourth;
        an_temp = 4'b1110;
    end
    
     2'b01: begin
        Y = third;
        an_temp = 4'b1101;
    end
    
     2'b10: begin
        Y = second;
        an_temp = 4'b1011;
    end
    
     2'b11: begin
        Y = first;
        an_temp = 4'b0111;
    end
    
    endcase
end

assign an = an_temp;
sSegHex unit(Y, seg);

endmodule
