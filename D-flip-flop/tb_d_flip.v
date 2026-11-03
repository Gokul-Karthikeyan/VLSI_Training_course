`timescale 1ns / 1ps

module tb_d_flip;
    
    reg clk;
    reg reset;
    reg [3:0] d;

    wire [3:0] q;

    d_flip_flop_4bit uut (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    always #5 clk = ~clk;

    initial begin
       
        clk = 0;
        reset = 1;
        d = 4'b0000;
        
        #10;
        reset = 0;
        
        d = 4'b1010;
        #13; 

        d = 4'b0101;
        #17;
        
        d = 4'b1111;
        #10;
        
        $finish;
    end
endmodule