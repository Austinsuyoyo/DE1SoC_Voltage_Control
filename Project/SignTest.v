module Sign (
	A, 
	B, 
	Y3
);
 
input		signed		[2:0] 	A, B;
output	reg signed	[8:0]		Y3;

 
always @(A or B) begin
		Y3 <= A*-B;
	end

endmodule