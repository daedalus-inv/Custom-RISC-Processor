module RISC_16(
	input 				clk,
	input 				enable,
	input 	[15:0] 	instruction,
	output 	[4:0] 	tick_out,
	output 	[15:0] 	display
);


// ----==== CONTROL SIGNALS ====----
wire 	[15:0] 	alu_out;
wire 	[3:0]		reg_a, reg_b;
wire 	[3:0] 	alu_op;
wire	[2:0]		pc_enables;
wire 				reg_r_enable, reg_w_enable, alu_mux, w_data_mux, sign_mux, disp_enable; 

// ----==== OTHER WIRES ====----
wire 	[15:0] 	alu_in1, alu_in2, reg_in1, reg_in2, reg_out2, reg_data_in, sign_out, sign_mux_out, pc_out;
wire 	[7:0] 	sign_in;
wire	[4:0]		tick;

// ----==== ASSIGNMENTS ====----
assign tick_out = tick;

// ----==== INSTANTIATIONS ====----
Control_unit C0 (
	.clk(clk),
	.enable(enable),
	.instruction(instruction),
	.tick(tick),
	.alu_out(alu_out),
	.Reg_a(reg_a),
	.Reg_b(reg_b),
	.Sign_ext_in(sign_in),
	.Reg_r_enable(reg_r_enable),
	.Reg_w_enable(reg_w_enable),
	.ALU_mux(alu_mux),
	.Sign_mux(sign_mux),
	.write_data_mux(w_data_mux),
	.disp_enable(disp_enable),
	.PC_enables(pc_enables),
	.ALU_op(alu_op)
);

Register_file R0 (
	.clk(clk),
	.read_enable(reg_r_enable),
	.write_enable(reg_w_enable),
	.reg1(reg_a),
	.reg2(reg_b),
	.in_data(reg_data_in),
	.out_data1(alu_in1),
	.out_data2(reg_out2)
);

PC_counter PC(
	.replace(pc_enables[0]),
	.increment(pc_enables[1]),
	.add(pc_enables[2]),
	.clk(clk),
	.D(sign_out),
	.Q(pc_out)
);

ALU Alu (
	.a(alu_in1),
	.b(alu_in2),
	.opcode(alu_op),
	.out(alu_out)
);

tick_FSM Tick (
	.clk(clk),
	.tick(tick)
);

Mux_2 ALU_mux (
	.select(alu_mux),
	.a(reg_out2),
	.b(sign_mux_out),
	.out(alu_in2)
);

Mux_2 Write_data_mux (
	.select(w_data_mux),
	.a(alu_out),
	.b(alu_out),		// TO BE UPDATED LATER
	.out(reg_data_in)
);

Mux_2 Sign_ext_mux(
	.select(sign_mux),
	.a(16'd0),
	.b(sign_out),		
	.out(sign_mux_out)
);

Sign_ext_8 sign_x (
	.a(sign_in),
	.out(sign_out)
);


Reg disp_register(
	.enable(disp_enable),
	.clk(clk),
	.D(~alu_out),
	.Q(display)
);

endmodule 