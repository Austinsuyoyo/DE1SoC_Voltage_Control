module ADC_SCALE_DISPLAY(
	input 				Clock_in, 
	input 				reset_n, 
	input 		[11:0]bindata, 
	output reg 	[3:0] dig_5,
	output reg 	[3:0] dig_4, 
	output reg 	[3:0] dig_3, 
	output reg 	[3:0] dig_2, 
	output reg 	[3:0] dig_1,
	output reg 	[3:0] dig_0
);

always@(negedge reset_n or negedge Clock_in)
begin
    if (reset_n == 0)
        begin
            dig_5 = 0;
            dig_4 = 0;
            dig_3 = 0;
            dig_2 = 0;
            dig_1 = 0;
            dig_0 = 0;
        end
    else
        begin
				//0~4096 scale to 0~5V
				dig_0 =  bindata*500000/4095 %10;
            dig_1 = ( bindata*500000/4095 / 10 ) % 10;
            dig_2 = ( bindata*500000/4095 / 100 ) % 10;
            dig_3 = ( bindata*500000/4095 / 1000 ) % 10;
            dig_4 = ( bindata*500000/4095 / 10000 ) % 10;
				dig_5 = ( bindata*500000/4095 / 100000 ) % 10;	 

        end
end

endmodule