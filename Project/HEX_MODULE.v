module HEX_MODULE
(
	input		[3:0]	Num0,
	input		[3:0]	Num1,
	input		[3:0]	Num2,
	input		[3:0]	Num3,
	input		[3:0]	Num4,
	input		[3:0]	Num5,
	output	[6:0]	Hex0,
	output	[6:0]	Hex1,
	output	[6:0]	Hex2,
	output	[6:0]	Hex3,
	output	[6:0]	Hex4,
	output	[6:0]	Hex5,
	input 	[12:0]data
);
Seg7 H0(.num(Num0),.seg(Hex0));
Seg7 H1(.num(Num1),.seg(Hex1));
Seg7 H2(.num(Num2),.seg(Hex2));
Seg7 H3(.num((50-(data*100/1024))%10),.seg(Hex3));  
Seg7 H4(.num((50-(data*100/1024))/10),.seg(Hex4));	
Seg7 H5(.num(15),.seg(Hex5));

endmodule
