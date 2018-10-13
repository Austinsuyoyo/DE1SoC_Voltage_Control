module SWITCH_ADC_CHANNEL_MODULE 
(	
	input					Switch,
	input		[11:0] 	Channel0,
	input		[11:0] 	Channel1,
	output 	[11:0] 	oSelectChannel
	);

assign oSelectChannel = (Switch)? Channel1 : Channel0;
endmodule
