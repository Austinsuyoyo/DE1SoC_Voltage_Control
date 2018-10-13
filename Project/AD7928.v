module AD7928(
	input 				Clock_in,
	input 				rstn,
	output reg 			ad7928_sclk,
	output reg 			ad7928_din,
	output reg 			ad7928_csn,
	input 				ad7928_dout, 
//	output reg			oRead_data_Sig,
	output reg [11:0]	vin0,
	output reg [11:0]	vin1
//	output reg [11:0]	vin2,
//	output reg [11:0]	vin3,
//	output reg [11:0]	vin4,
//	output reg [11:0]	vin5,
//	output reg [11:0]	vin6,
//	output reg [11:0]	vin7
	);
/*－－－－－－－－－－－－－－－－－－Control Regisger－－－－－－－－－－－－－－－－－－//

MSB                                                                            LSB
－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
| WRITHE | SEQ | X | ADD2 | ADD1 | ADD0 | PM1 | PM0 | SHADOW | X | RANGE | CODING |
－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－

*/
reg [14:0] ad7928_reg_in;
reg [14:0] ad7928_reg_out; 


reg [7:0] seq;
reg [3:0] rout_no, rin_no;
reg 		 idx;


always@(negedge Clock_in or negedge rstn) 
begin
	if (!rstn)
		begin
			vin0 = 0;
			vin1 = 0;
//			vin2 = 0;
//			vin3 = 0;
//			vin4 = 0;
//			vin5 = 0;
//			vin6 = 0;
//			vin7 = 0;
			idx = 0;
			seq = 0;
			ad7928_csn = 1;
			ad7928_sclk = 1;
			ad7928_din = 1;
//			oRead_data_Sig <= 0;
			ad7928_reg_out = 15'b100_0001_1000_1000;
		end
	else 
		begin
				case (seq)
					0:	begin
							ad7928_csn = 0; 
							ad7928_reg_out = 15'b100_0001_1000_1000;//Control Register + 000;
							ad7928_reg_out[11:9] = idx;				 //Chanel
							rout_no = 14;
							rin_no = 0;
							seq = seq + 1;
						end
					1: begin
							ad7928_din = (ad7928_reg_out >> rout_no) & 1;
							rout_no = rout_no - 1;
							seq = seq + 1;
						end
					2: begin
							ad7928_sclk = 0;
							seq = seq + 1;
						end
					3: begin
							ad7928_sclk = 1;
							ad7928_reg_in = (ad7928_reg_in << 1);
							ad7928_reg_in = ad7928_reg_in | ad7928_dout;
							rin_no = rin_no + 1;
						if (rin_no > 14) 
                        seq = seq + 1;
						else 
								seq = 1;
						end
					4: begin
							ad7928_sclk = 0;
							seq = seq + 1;
						end
					5: begin
							ad7928_sclk = 1;
							seq = seq + 1;
                end
					6:	begin
							ad7928_csn = 1;
							seq = seq + 1;
						end
					7: begin
							case (ad7928_reg_in[14:12])
							0: begin
									vin0 = ad7928_reg_in[11:0];
//									oRead_data_Sig <= 0;
								end
							1:	begin 
//									oRead_data_Sig <= 1;
									vin1 = ad7928_reg_in[11:0];
								end
//							2: vin2 = ad7928_reg_in[11:0];
//							3: vin3 = ad7928_reg_in[11:0];
//							4: vin4 = ad7928_reg_in[11:0];
//							5: vin5 = ad7928_reg_in[11:0];
//							6: vin6 = ad7928_reg_in[11:0];
//							7: vin7 = ad7928_reg_in[11:0];
                     endcase
                     idx = idx + 1; //Channel switch 
							seq = 0; 
						end
				endcase // end of case(seq)
        //    end // end if
      end // end else
end // end always




endmodule