module Divisor(
	input					clock_in,
	input 		[20:0]iHz_in,
	input 				reset_n,
	output reg 			clock_div
	);
	
reg [31:0] counter;

always@(negedge clock_in ) begin
	if(!reset_n) begin
			clock_div=0;
			counter=0;
	end
	else begin
		if(counter < 50000000/(2* iHz_in)) begin	 //i HZ          
 
				counter  <= counter  +1;		
				clock_div <= clock_div ;	
		end
		else begin
				counter  <= 0;
				clock_div <= ~clock_div ;	
		end
	end
end			
endmodule