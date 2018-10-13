module Subtractor(
	input		[11:0] 	A,			//target
	input		[11:0] 	B,			//feedback
	input				 	clk,
	output	[12:0] 	Y
);
assign Y=A-B;

endmodule