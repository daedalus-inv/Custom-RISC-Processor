module tick_FSM(
	// Each clock pulse will increment the tick finite state machine to move through its 5 states
	input					clk,
	output reg	[4:0]	tick
);
/**
----==== INSTANTIATION ====----

tick_FSM Tick (
	.clk(),
	.tick()
);

----==== DESCRIPTION ====----
FSM is ones hot encoded, transitions on the positive edge
STATES: 10000 -> 01000 -> 00100 -> 00010 -> 00001
          ^___________________________________|

*/
initial begin
tick = 5'b10000;
end


always @(posedge clk) begin
	case (tick)
		5'b10000: 	tick <= 5'b01000;		// Instruction Fetch -> Instruction Decode
		5'b01000: 	tick <= 5'b00100;		// Instruction Decode -> Instruction Execution
		5'b00100: 	tick <= 5'b00010;		// Instruction Execution -> Memory access
		5'b00010: 	tick <= 5'b00001;		// Memory access -> Write back
		5'b00001: 	tick <= 5'b10000;		// Write back -> Instruction Fetch
		default: 	tick <= 5'b10000;
	endcase
end

endmodule 