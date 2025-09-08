module Mux_2(
	input 	 		select,
	input [15:0] 	a,
	input [15:0] 	b,
	output [15:0] 	out
);


/**
----==== INSTANTIATION ====----

Mux_2 ALU_mux (
	.select(),
	.a(),
	.b(),
	.out()
);

----==== DESCRIPTION ====----
A simple 2 to 1 multiplexer where the inputs are 16 bits

*/

assign out = select? b : a;

endmodule 