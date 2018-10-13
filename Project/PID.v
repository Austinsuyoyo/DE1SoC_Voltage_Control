module PID #(parameter W=12) 			// bit width 1
(	u_out, 									// output
	e_in,  									// input
	clk,
	reset_n,
	u_prev
	);
output signed	 [W: 0] u_out; 		// output
input signed	 [W: 0] e_in; 			// input
input clk; 									// clock in
input reset_n;								// reset

parameter 	Kp = 1;	   				
parameter 	Ki = 20;							
parameter 	Kd = 1;	

parameter	T  = 0.05;
parameter	Ti = Kp/Ki;
parameter	Td = Kd/Kp;
//parameter 	k1 = Kp+Ki+Kd;				//delta t 需要配合PID輸出頻率
//parameter 	k2 = Kp+2*Kd;
//parameter 	k3 = Kd;
//0914嘗試新公式============================================
//parameter k1 = Kp*(1+(T/Ti)+(Td/T));		
//parameter k2 = Kp*(1+(2*Td/T));
//parameter k3 = Kp*(Td/T);

//parameter k1 = Kp;						// if Ki = Kd = 0;
//parameter k2 = Kp;
//parameter k3 = Kp;

//parameter k1 = Kp*(1+(Td*20));		// if Ki=0
//parameter k2 = Kp*(1+(2*Td*20));
//parameter k3 = Kp*(Td*20);

parameter k1 = Kp*(1+(1)+(Td*20));				//if Ki=20 , Kd=0
parameter k2 = Kp*(1+(2*Td*20));
parameter k3 = Kp*(Td*20);
output reg signed	[W: 0] 	u_prev;
reg 	signed 		[W: 0] 	e_prev2;
reg 	signed 		[W: 0] 	e_prev1;
reg 	signed  		[W+2: 0]	u_temp;
reg								seq;

/*assign u_out= 	(~u_temp[W+1] &  u_temp[W]) ? 13'b0_1111_1111_1111 : // + overflow
               ( u_temp[W+1] & ~u_temp[W]) ? 13'b1_0000_0000_0000 : // - overflow
               u_temp[W:0];*/							//0921BUGGG:只能抓到4096~8191 & -8192~-4097
/*assign u_out= 	(~u_temp[W+2] &  u_temp[W+1]) ? 13'b0_1111_1111_1111 : // + overflow
               ( u_temp[W+2] & ~u_temp[W+1]) ? 13'b1_0000_0000_0000 : // - overflow
               u_temp[W:0];*/							
assign u_out= 	(~u_temp[W+2] &  u_temp[W+1]) ? 13'b0_1111_1111_1111 : 		// + overflow
					( u_temp[W+2] & ~u_temp[W+1]) ? 13'b1_0000_0000_0000 : 		// - overflow
					(~u_temp[W+1] &  u_temp[W]) 	? 13'b0_1111_1111_1111 : 		// + overflow
               ( u_temp[W+1] & ~u_temp[W]) 	? 13'b1_0000_0000_0000 : 		// - overflow
               u_temp[W:0];
					
always @ (posedge clk)
begin
if (!reset_n) begin
		u_prev <= 0;
		e_prev1 <= 0;
		e_prev2 <= 0;
		u_temp <=  0;
		seq <= 0;
	end
	else begin
		case (seq)
			0: begin
				e_prev2 <= e_prev1;
				e_prev1 <= e_in;
				u_prev <= u_out; //修改 不應為u_temp
				seq <= 1;
				end
			1: begin
				u_temp <= u_prev + (k1*e_in) - (k2*e_prev1) + (k3*e_prev2);//{u_prev[W],u_prev} + k1 * {e_in[W]+e_in} - k2 * {e_prev1[W]+e_prev1} + k3 * {e_prev2[W]+e_prev2}; //Signed Extension
				seq <= 0;
				end
		endcase
	end
end

endmodule