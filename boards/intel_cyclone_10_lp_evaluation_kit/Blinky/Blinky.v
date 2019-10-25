module Blinky(

// 50 MHz input clock
input CLK_IN1,

// Output LED
output BLINK_OUT
);

	// Generate a 1 Hz clock from a 50 MHz input clock
	clock_divider clock_divider_1 (
		 .CLK_IN(CLK_IN1), 
		 .CLK_OUT(BLINK_OUT)
		 );
		 
 endmodule
 