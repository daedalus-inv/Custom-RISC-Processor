module Control_unit(
	input 						clk,
	input							enable,
	input 			[15:0] 	instruction,
	input				[4:0]		tick,
	input 			[15:0]	alu_out,
	output			[3:0]		Reg_a,
	output			[3:0] 	Reg_b,
	output 			[7:0] 	Sign_ext_in,
	output	reg				Reg_r_enable,
	output	reg				Reg_w_enable,
	output 	reg				ALU_mux,				// Mux to determine the input to the ALU
	output	reg				Sign_mux,			// To determine if the sign extender or 0 is passed to the ALU mux
	output 	reg				write_data_mux,
	output 	reg				disp_enable,
	output 	reg	[2:0] 	PC_enables,
	output	reg	[3:0] 	ALU_op
);
/**
----==== INSTANTIATION ====----

Control_unit C0 (
	.clk(),
	.enable(),
	.instruction(),
	.tick(),
	.Reg_a(),
	.Reg_b(),
	.Sign_ext_in(),
	.Reg_r_enable(),
	.Reg_w_enable(),
	.ALU_mux(),
	.write_data_mux(),
	.disp_enable(),
	.PC_enables(),
	.ALU_op()
);


----==== INSTRUCTION FORMAT ====----
R-type
	 0000	 	XXXX	 	XXXX 	  	XXXX
	opcode    ra		 rb     r-code
	
	R-type performs opperations on registers, eg add (r-code 0000) adds the contents of two registers 
	ra and rb and stores the result in ra

I-type

	XXXX	 	XXXX	 	XXXX XXXX
  opcode     ra		Immidiate
	
	I-type performs opperations with an immediate value, eg addi (opcode 0001) addi adds the immediate value 
	and the contents of ra and stores the result in ra

J-type

	1111		XXXX XXXX XXXX
  opcode		   Immidiate
  
  
	
*/

assign Reg_a = instruction[11:8];
assign Reg_b = instruction[7:4];
assign Sign_ext_in = instruction[7:0];


always @(tick, enable, instruction, clk, alu_out) begin
	case (enable)
		1'b1: begin
			case (tick)
			
				// ----==== INSTRUCTION FETCH ====----
				5'b10000: begin
					Reg_w_enable <= 1'b0;
					disp_enable <= 1'b0;
					case (instruction[15:12])
						// ---- R-TYPE ----
						4'b0000: begin
						end
						// ---- j-TYPE ----
						4'b1111: begin
						end
						// ---- I-TYPE ----
						default: begin
						end
					endcase
				end
				
				// ----==== INSTRUCTION DECODE ====----
				5'b01000: begin
					Sign_mux <= 1'b1;
					case (instruction[15:12])
						// ---- R-TYPE ----
						4'b0000: begin
							Reg_r_enable <= 1'b1;
						end
						// ---- j-TYPE ----
						4'b1111: begin
						end
						// ---- I-TYPE ----
						default: begin
							Reg_r_enable <= 1'b1;
						end
					endcase
				end
				
				// ----==== EXECUTION ====----
				5'b00100: begin
					Reg_r_enable <= 1'b0;
					case (instruction[15:12])
						// ---- R-TYPE ----
						4'b0000: begin
							ALU_mux <= 1'b0;					// alu mux delivers rb to the alu (instead of sign extender)
							ALU_op <= instruction[3:0];		// Pass the r-code to the alu
						end
						// ---- j-TYPE ----
						4'b1111: begin
						end
						// ---- I-TYPE ----
						default: begin
							ALU_mux <= 1'b1;		// alu mux delivers sign extender to the alu (instead of rb)
							case (instruction[15:12])
								4'b0001: ALU_op <= 4'b0001;	// addi
								4'b0010: ALU_op <= 4'b0000;	// movi
								4'b0011: ALU_op <= 4'b1100;	// andi
								4'b0100: ALU_op <= 4'b1101;	// ori
								4'b0101: ALU_op <= 4'b1110;	// xori
								4'b0110: ALU_op <= 4'b0111;	// sli
								4'b0111: ALU_op <= 4'b0110;	// sri
								4'b1000: ALU_op <= 4'b1001;	// srli
								4'b1001: ALU_op <= 4'b1010;	// disp (the ALU will invert the bits)
								4'b1010: begin 					// beqz	NOT SET UP
									Sign_mux <= 1'b0;
									ALU_op <= 4'b0101;
								end
								4'b1011: begin						// bgtz 	NOT SET UP
									Sign_mux <= 1'b0;
									ALU_op <= 4'b0100;	
								end
								4'b1100: begin						// bltz	NOT SET UP
									Sign_mux <= 1'b0;
									ALU_op <= 4'b1011;	
								end
								4'b1101: ALU_op <= 4'bXXXX;	//	lw		NOT SET UP
								4'b1110: ALU_op <= 4'bXXXX;	// sw		NOT SET UP
								default: ALU_op <= 4'b0000;
							endcase
						end
					endcase
				end
				
				// ----==== MEMORY ====----
				5'b00010: begin
					case (instruction[15:12])
						// ---- R-TYPE ----
						4'b0000: begin
						end
						// ---- j-TYPE ----
						4'b1111: begin
						end
						// ---- I-TYPE ----
						default: begin
//							case (instruction[15:12])
//								4'b1101: ALU_op <= 4'bXXXX;	//	lw		NOT SET UP
//								4'b1110: ALU_op <= 4'bXXXX;	// sw		NOT SET UP
//								default: 
//							endcase
						end
					endcase
				end
				
				// ----==== WRITE BACK ====----
				5'b00001: begin
					case (instruction[15:12])
						// ---- R-TYPE ----
						4'b0000: begin
							write_data_mux <= 1'b0;
							Reg_w_enable <= 1'b1;
							PC_enables <= 3'b010;
						end
						// ---- j-TYPE ----
						4'b1111: begin
						end
						// ---- I-TYPE ----
						default: begin
							case (instruction[15:12])
								4'b1001: disp_enable <= 1'b1;	// disp (the ALU will invert the bits)
								4'b1010: begin 					// beqz	NOT SET UP
									// 0 = FALSE, 1= TRUE
									PC_enables <= alu_out[0]? 3'b100 : 3'b010;
								end
								4'b1011: begin						// bgtz 	NOT SET UP
									// 0 = FALSE, 1= TRUE
									PC_enables <= alu_out[0]? 3'b100 : 3'b010;
								end
								4'b1100: begin						// bltz	NOT SET UP
									// 0 = FALSE, 1= TRUE
									PC_enables <= alu_out[0]? 3'b100 : 3'b010;
								end
								4'b1101: ALU_op <= 4'bXXXX;	//	lw		NOT SET UP
								4'b1110: ALU_op <= 4'bXXXX;	// sw		NOT SET UP
								default: begin
									write_data_mux <= 1'b0;
									Reg_w_enable <= 1'b1;
									PC_enables <= 3'b010;
								end
							endcase
						end
					endcase
				end
				default: begin	// tick is undefined
				end
			endcase
		end
		default: begin
			Reg_r_enable <= 1'b0;
			Reg_w_enable <= 1'b0;
			ALU_op <= 3'b0;
		end
	endcase
end

endmodule 