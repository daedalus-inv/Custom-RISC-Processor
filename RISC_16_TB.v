`timescale 10ns/1ns
module RISC_16_TB();
	// ----==== WIRES ====----
	wire 	[4:0] 	tick;
	wire 	[15:0] 	display;
	wire 	[15:0]	alu_in1;
	wire 	[15:0]	alu_in2;
	wire	[15:0]	alu_out;
	// ----==== REGISTERS ====----
	reg [15:0] 	instruction;
	reg [15:0] 	expected_in1;
	reg [15:0] 	expected_in2;
	reg [15:0] 	expected_out;
	reg [2:0]	clk_counter;
	reg 			clk_enable;
	reg			clk;
	// ----==== INTEGERS ====----
	integer count, errors, num_tests;
	
	// ----==== INITIALISATIONS ====----
	initial begin
		count = 0;
		errors = 0;
		clk = 0;
		num_tests = 1;
	end
	RISC_16 Proc(
		.t_alu_in1(alu_in1), 
		.t_alu_in2(alu_in2),
		.t_alu_out(alu_out),
		.clk(clk),
		.enable(1'b1),
		.instruction(instruction),
		.tick_out(tick),
		.display(display)
	);
	
	// ----==== CLK CREATION ====----
	always begin
		if (clk_enable) begin
			#1;
			clk <= ~clk;
		end else clk <= 0;
	end
	// ----==== INCREMENTING TESTS ====----
	always begin
		#2;
		instruction <= 16'b0001000000000001;
		clk_enable <= 1'b1;
		#10;
		clk_enable <= 1'b0;
		#8;
	end
	// ----==== COMPARING OUTPUT ====----
	always begin
	#18;
		if (count == num_tests) begin
			$display("Done with test.");
			$display("There were %0d errors.", errors);
			$stop;
		end
		if (alu_in1 != expected_in1 || alu_in2 != expected_in1 || alu_out != expected_out) begin
			$display("Error for instruction %b", instruction);
			if (alu_in1 != expected_in1) $display("Expected alu in1 %b, actual", expected_in1, alu_in1);
			if (alu_in2 != expected_in2) $display("Expected alu in2 %b, actual", expected_in2, alu_in2);
			if (alu_out != expected_out) $display("Expected alu out %b, actual", expected_out, alu_out);
			errors = errors + 1;
		end
	#2;
	end
endmodule 