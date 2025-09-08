module Register_file(
	input							clk,
	input 						read_enable,
	input							write_enable,
	input 			[3:0]		reg1,
	input				[3:0]		reg2,
	input				[15:0] 	in_data,
	output	reg	[15:0]	out_data1,
	output	reg	[15:0]	out_data2
);

/**
----==== INSTANTIATION ====----

Register_file R0 (
	.clk(),
	.read_enable(),
	.write_enable(),
	.reg1(),
	.reg2(),
	.in_data(),
	.out_data1(),
	.out_data2()
);

----==== DESCRIPTION ====----
The register file writes to register 1 and reads from register 1 and 2 it itself is not exclusivley edge triggered
but the registers that make it up are positively edge triggered. 

*/

	reg [15:0]	enable;
	wire [15:0] r_out [0:15];
	
	Reg r0 (.enable(enable[0]), .clk(clk), .D(in_data), .Q(r_out[0]));
	Reg r1 (.enable(enable[1]), .clk(clk), .D(in_data), .Q(r_out[1]));
	Reg r2 (.enable(enable[2]), .clk(clk), .D(in_data), .Q(r_out[2]));
	Reg r3 (.enable(enable[3]), .clk(clk), .D(in_data), .Q(r_out[3]));
	Reg r4 (.enable(enable[4]), .clk(clk), .D(in_data), .Q(r_out[4]));
	Reg r5 (.enable(enable[5]), .clk(clk), .D(in_data), .Q(r_out[5]));
	Reg r6 (.enable(enable[6]), .clk(clk), .D(in_data), .Q(r_out[6]));
	Reg r7 (.enable(enable[7]), .clk(clk), .D(in_data), .Q(r_out[7]));
	Reg r8 (.enable(enable[8]), .clk(clk), .D(in_data), .Q(r_out[8]));
	Reg r9 (.enable(enable[9]), .clk(clk), .D(in_data), .Q(r_out[9]));
	Reg r10 (.enable(enable[10]), .clk(clk), .D(in_data), .Q(r_out[10]));
	Reg r11 (.enable(enable[11]), .clk(clk), .D(in_data), .Q(r_out[11]));
	Reg r12 (.enable(enable[12]), .clk(clk), .D(in_data), .Q(r_out[12]));
	Reg r13 (.enable(enable[13]), .clk(clk), .D(in_data), .Q(r_out[13]));
	Reg r14 (.enable(enable[14]), .clk(clk), .D(in_data), .Q(r_out[14]));
	Reg r15 (.enable(enable[15]), .clk(clk), .D(in_data), .Q(r_out[15]));
	

always @(clk, read_enable, write_enable, reg1, reg2, in_data) begin
	case (read_enable)
		1'b1:	begin
			out_data1 <= r_out[reg1];
			out_data2 <= r_out[reg2];
		end
		default: begin
			out_data1 <= 16'd0;
			out_data2 <= 16'd0;
		end
	endcase
	
	case (write_enable)
		1'b1: enable[reg1] <= 1'b1;
		default: enable <= 16'd0;
	endcase
end

endmodule 