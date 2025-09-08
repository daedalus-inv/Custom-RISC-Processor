module Reg(
	input 						enable,
	input 						clk,
	input 			[15:0] 	D,
	output 	reg	[15:0] 	Q
);

initial begin
	Q = 16'd0;
end

always @(posedge clk) begin
	case (enable)
		1'b1:		Q <= D;
		1'b0:		Q <= Q;
		default: Q <= Q;
	endcase
end

endmodule 
