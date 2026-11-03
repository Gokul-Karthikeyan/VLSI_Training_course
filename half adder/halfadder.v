`timescale 1ns/1ps
module halfadder(
	input A,
	input B,
	output reg Sum,
	output reg Carry
);

always @(*) begin
	Sum = A^B;
	Carry=A&B;
end
endmodule