module Sign_ext_8(
	input 	[7:0] 	a,
	output 	[15:0] 	out
);

/**
----==== INSTANTIATION ====----

sign_ext_8 sign_x (
	.a(),
	.out()
);

----==== DESCRIPTION ====----
Extends an 8 bit input to 16 bits by replicating the MSB

*/

assign out = {{8{a[7]}}, a};

endmodule 