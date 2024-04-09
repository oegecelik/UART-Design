`timescale 1ns / 1ps

module button_debouncer(
    input button,
    input clk,
     input reset,
    output result
    );

/*********** Internal Variables **********/

wire Q1,Q2,SCLR,Q3,Cout;
wire HIGH = 1;
wire LOW = 0;

/************** Main Code ******************/

D_FF D1(clk,reset,button,HIGH,LOW,Q1);
D_FF D2(clk,reset,Q1,HIGH,LOW,Q2);

xor g1(SCLR,Q1,Q2); 

N_bit_counter C1(clk,reset,~Cout,SCLR,Cout);

D_FF D3(clk,reset,Q2,Cout,LOW,Q3);

assign result = Q3;

endmodule

/************** D Flip Flop Module ***************/

module D_FF(
    input clk,
     input reset,
    input D,
    input enable,
    input clear,
    output reg Q
    );
     
         // Active "HIGH " clear, reset, enable signals //

always @(posedge clk) 
    begin
            if (reset) Q<=0;     
            else 
                begin
                    case({clear,enable})  
                        2'b00 : Q<=Q;
                        2'b01 : Q<=D;
                        default : Q<=0;
                    endcase
                end
    end
endmodule

/******************** Counter Module **********************/

module N_bit_counter(
    input clk,
     input reset,
    input enable,
    input clear,
     output Cout
    );
     
     // Active "HIGH " clear, reset, enable signals //

parameter N = 8; // Counts from 0 to 2^[N-1]
reg [N-1:0] count;

assign Cout = count[N-1];

always @(posedge clk) 
    begin   
        if (reset) count <= 8'b0;     
        else 
            begin
                case({clear,enable})     
                    2'b00 : count <= count;
                    2'b01 : count <= count+1;
                    default : count <= 8'b0;
                endcase
          end
    end
endmodule