module ALU(
	input 			[15:0]	a,
	input 			[15:0]	b,
	input 			[3:0] 	opcode,
	output	reg 	[15:0]	out
);

/**
----==== INSTANTIATION ====----

ALU Alu (
	.a(),
	.b(),
	.opcode(),
	.out()
);

----==== DESCRIPTION ====----
The Arithmetic logic unit performs the neccesary arithmetic calculations for the processor
It takes two 16 bit numbers and performs an operation determined by the opcode
*/


always @(a, b, opcode) begin
	case (opcode)
		4'b0000: out <= b;			// Move b into a
		4'b0001: out <= a + b;
		4'b0010: out <= a * b;
		4'b0011: out <= a / b;
		4'b0100: out <= a > b;
		4'b0101: out <= a == b;
		4'b0110: out <= a >> b;
		4'b0111: out <= a << b;
		4'b1000: out <= a - b;
		4'b1001: out <= a >>> b;	// shift right arithmetic (fills with MSB)
		4'b1010: out <= ~a;
		4'b1011: out <= a < b;		
		4'b1100: out <= a & b;		// AND
		4'b1101: out <= a | b;		// OR
		4'b1110: out <= a ^ b;		// XOR
		4'b1111: out <= 16'd0;		// replace a with 0
		default: out <= 16'd0;
	endcase
end

endmodule 