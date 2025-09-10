module bcd_1(
	input 	[3:0] in,
	output	[6:0] out
);

reg [6:0] temp;
assign out = ~temp;

always @(in) begin
	case (in)
		4'b0000:	temp <= 7'b0111111;	// 0 
		4'b0001:	temp <= 7'b0000110;	// 1
		4'b0010:	temp <= 7'b1011011;	// 2
		4'b0011:	temp <= 7'b1001111;	// 3
		4'b0100:	temp <= 7'b1100110;	// 4
		4'b0101:	temp <= 7'b1101101;	// 5
		4'b0110:	temp <= 7'b1111101;	// 6
		4'b0111:	temp <= 7'b0000111;	// 7
		4'b1000:	temp <= 7'b1111111;	// 8
		4'b1001:	temp <= 7'b1101111;	// 9
		default: temp <= 7'b0111111;	// undef (but displays 0)
	endcase
end 
endmodule 