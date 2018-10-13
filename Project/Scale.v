module Scale(             //-4096~4095 (12bits) ->  0~511 (9bits)
	input			[12:0] in,
	input					 clk,
	output reg	[8:0]  out
);

always@(negedge clk)
begin
		if(!in[12]) out<=256+(in>>4);
		else			out<=256-(~in>>4);
end
endmodule