module Display_on_SEG(
	clock_in, 	//clock for counter
	reset_n,		//Reset
	data_from,
	dig1,
	dig01,
	dig001
);

input 						clock_in;
input 						reset_n;
input 			[11:0]	data_from;
output	reg	[6:0]		dig1;
output	reg	[6:0]		dig01;
output	reg	[6:0]		dig001;
reg				[21:0]	Digit;
reg				[3:0]		Digit1;
reg				[3:0]		Digit01;
reg				[3:0]		Digit001;

always@(negedge clock_in or negedge reset_n)
begin
	Digit = data_from * 500;	// should be 4097000 max
	
	Digit1		= 	Digit / 409400;														//x.00
	Digit01		=	(Digit - (Digit1 * 409400)) / 40940;							//0.x0
	Digit001		=	(Digit - (Digit1 * 409400) - (Digit01 * 40940)) / 4094;	//0.0x

	
    case(Digit1)
      0: dig1 <= 7'b1000000;
      1: dig1 <= 7'b1111001;
      2: dig1 <= 7'b0100100;
      3: dig1 <= 7'b0110000;
      4: dig1 <= 7'b0011001;
      5: dig1 <= 7'b0010010;
      6: dig1 <= 7'b0000010;
      7: dig1 <= 7'b1111000;
      8: dig1 <= 7'b0000000;
      9: dig1 <= 7'b0010000;
		default: dig1 <= 7'b0111111;
    endcase
	 case(Digit01)
      0: dig01 <= 7'b1000000;
      1: dig01 <= 7'b1111001;
      2: dig01 <= 7'b0100100;
      3: dig01 <= 7'b0110000;
      4: dig01 <= 7'b0011001;
      5: dig01 <= 7'b0010010;
      6: dig01 <= 7'b0000010;
      7: dig01 <= 7'b1111000;
      8: dig01 <= 7'b0000000;
      9: dig01 <= 7'b0010000;
		default: dig01 <= 7'b0111111;
    endcase
	 case(Digit001)
      0: dig001 <= 7'b1000000;
      1: dig001 <= 7'b1111001;
      2: dig001 <= 7'b0100100;
      3: dig001 <= 7'b0110000;
      4: dig001 <= 7'b0011001;
      5: dig001 <= 7'b0010010;
      6: dig001 <= 7'b0000010;
      7: dig001 <= 7'b1111000;
      8: dig001 <= 7'b0000000;
      9: dig001 <= 7'b0010000;
		default: dig001 <= 7'b0111111;
    endcase
end
endmodule