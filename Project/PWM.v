module PWM(
	clock_in, 	//clock for counter
	reset_n,		//Reset
   Duty_data,   //Duty = Vol_data/Counter  fixed 512
	Dead_time,	//50%  from PID
	PWM_out1,	//PWM signal out
	PWM_out2	//PWM signal out
);
input 					clock_in; 	
input						reset_n;
input 		[9:0] 	Duty_data;
output reg		 		PWM_out1,PWM_out2;		//PWM signal out
input			[8:0]		Dead_time;

reg [9:0] 	Counter = 0;

parameter Dead_time80	=10'd82;	//dead time ? clock

always@(negedge clock_in or negedge reset_n) begin
	if(!reset_n) Counter <= 10'd0;
	else 			
		begin
			if ( Counter < Duty_data-Dead_time)
				begin
				PWM_out1 <= 1;
				PWM_out2 <= 0;
				end
			else if ((Counter > Duty_data-Dead_time)&&(Counter < Duty_data))
				begin
				PWM_out1 <= 0;
				PWM_out2 <= 0;
				end
			else if ((Counter > Duty_data)&&(Counter < Duty_data*2-Dead_time))
				begin
				PWM_out1 <= 0;
				PWM_out2 <= 1;
				end
			else if (Counter > Duty_data*2-Dead_time)
				begin
				PWM_out1 <= 0;
				PWM_out2 <= 0;
				end
			Counter <= Counter+1;
		end
end

endmodule