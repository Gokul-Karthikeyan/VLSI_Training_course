`timescale 1ns/1ps

module tb_halfadder;

reg A, B;
wire Sum, Carry;

// Connect the Half Adder module
halfadder uut (
    .A(A),
    .B(B),
    .Sum(Sum),
    .Carry(Carry)
);

// Apply all input combinations
initial begin

    A = 0; B = 0;
    #10;

    A = 0; B = 1;
    #10;

    A = 1; B = 0;
    #10;

    A = 1; B = 1;
    #10;

    $finish;
end

// Display the simulation results
initial begin
    $monitor("Time=%0t A=%b B=%b Sum=%b Carry=%b",
             $time, A, B, Sum, Carry);
end

endmodule