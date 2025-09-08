module RISC_16_Manual_test(
	input 	[1:0] 	KEY,
	input 	[9:0] 	SW,
	output	[9:0]		LEDR,
	output	[6:0] 	HEX5
);

wire					clk;
wire 	[4:0]			tick;	
wire 	[15:0]		display;
wire	[6:0] 		bcd_out;

reg 	[15:0]		instruction; 
reg 	[3:0]			tick_count;

assign clk = KEY[0];
assign LEDR = display[9:0];
assign HEX5 = bcd_out;

always @(posedge clk) begin
	case (tick)
		5'b10000: begin
			tick_count <= 4'd1;
			instruction <= {SW[9:6], SW[5:2], 4'b0, SW[1:0]};
		end
		5'b01000:	tick_count <= 4'd2;
		5'b00100:	tick_count <= 4'd3;
		5'b00010:	tick_count <= 4'd4;
		5'b00001:	tick_count <= 4'd5;
		default: 	tick_count <= 4'd0;
	endcase
end

bcd_1 bcd(
	.in(tick_count),
	.out(bcd_out)
);

RISC_16 Proc(
	.clk(clk),
	.enable(1'b1),
	.instruction(instruction),
	.tick_out(tick),
	.display(display)
);
endmodule 