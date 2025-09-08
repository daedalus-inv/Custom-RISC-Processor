module PC_counter(
	input 						replace,		// replace the contents of the register with a new value
	input 						increment,	// increment the contents of the register by 1	
	input 						add,			// add the input to the contents of the register
	input 						clk,
	input 			[15:0] 	D,
	output 	reg	[15:0] 	Q
);

initial begin
	Q = 16'd0;
end

always @(posedge clk) begin
	if (replace) begin
		Q <= D;
	end else if (increment) begin
		Q <= Q + 1'b1;
	end else if (add) begin
		Q <= Q + D;
	end
end

endmodule 
