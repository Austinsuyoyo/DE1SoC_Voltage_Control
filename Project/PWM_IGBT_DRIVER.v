module PWM_IGBT_DRIVER(
	V_feedback,
	V_target,
	clock_50Min,
	reset_n,
	PWM,
	Test_pin,
	Test_pin2,
	Switch
);
input 	[11:0]	V_target;
input 	[11:0]	V_feedback;
input					clock_50Min;
input					reset_n;
input		[9:0]		Switch;
output	[4:3]		PWM;
output	[12:0]	Test_pin;
output	[12:0]	Test_pin2;

wire  				w_clock_2048;
wire     [12:0]	w_PID_out;
wire     [8:0]		w_Scale_PID_out;
wire		[11:0]	w_u_prev;
wire		[8:0]		w_Fix_Duty;
wire		[12:0]	V_error;
wire					w_100Hz;

Subtractor ErrorOfVoltage(
	.A(V_target),
	.B(V_feedback),
	.clk(clock_50Min),
	.Y(V_error)								// Y = A - B
);
PID V_PID(
	.u_out(w_PID_out), 					// output
	.e_in(V_error),	 					// input
	.clk(w_100Hz),
	.reset_n(reset_n),
	.u_prev(w_u_prev)
);
Scale Signed13bit_Unsigned9bit(		// -4096~4095 (12bits) ->  0~511 (9bits)
	.in(w_PID_out),
	.clk(clock_50Min),
	.out(w_Scale_PID_out)
);
Lock Lock42Percent(
	.Duty(~w_Scale_PID_out),			// invert signal  //if use SWITCH test : ~Switch[9:0]
	.clk(clock_50Min),
	.Fix_Duty(w_Fix_Duty)
);
PWM WithDeadTimeControl(
	.clock_in(w_clock_2048),
	.reset_n(reset_n),
	.Duty_data(512),
	.Dead_time(w_Fix_Duty),
	.PWM_out1(PWM[3]),
	.PWM_out2(PWM[4]),
);
PLL ForPWM_20_48M(
	.refclk   (clock_50Min),   		//  refclk.clk
	.rst      (!reset_n),      		//  reset.reset
	.outclk_0 (w_clock_2048),  		//  outclk0.clk

);

Divisor ForPID(
	.clock_in(clock_50Min),
	.iHz_in(100),
	.reset_n(reset_n),
	.clock_div(w_100Hz)
);
assign Test_pin = w_PID_out;
assign Test_pin2= w_Fix_Duty;
endmodule 