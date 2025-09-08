module bcd_1(
	input 	[3:0] in,
	output	[6:0] out
);

reg [6:0] temp;
assign out = ~temp;

always @(in) begin
	case (in)
		4'b0000:	temp <= 7'b1111110;	// 0 
		4'b0001:	temp <= 7'b0110000;
		4'b0010:	temp <= 7'b1101101;
		4'b0011:	temp <= 7'b1111001;
		4'b0100:	temp <= 7'b0110011;
		4'b0101:	temp <= 7'b1011011;
		4'b0110:	temp <= 7'b1011111;
		4'b0111:	temp <= 7'b1110000;
		4'b1000:	temp <= 7'b1111111;
		4'b1001:	temp <= 7'b1111011;
		default: temp <= 7'b1111110;	// undef (but displays 0)
	endcase
end 
endmodule 