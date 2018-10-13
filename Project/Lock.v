module Lock(
	input			[8:0] 	Duty,			//Duty Cycle 
	input					 	clk,			//trigger clk
	output reg	[8:0]  	Fix_Duty		//output to PWM module
);

always@(negedge clk)
begin
		if(Duty<200) Fix_Duty<=200;
		else Fix_Duty<=Duty;
end
endmodule