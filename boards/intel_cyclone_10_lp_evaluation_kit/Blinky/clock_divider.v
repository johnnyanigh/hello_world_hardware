// Generates a 1 Hz output clock from a 50 MHz input clock.

module clock_divider(
	input CLK_IN,
	output reg CLK_OUT
);

	// Max. count is 50,000,000 (which would require 26 bits)
	reg [31:0] count;
	
	initial begin
		count <= 32'h00000000;
	end
	
	//	Divider
	always @ (posedge CLK_IN)
	begin
		if(count < 25000000)
		begin
			count <= count + 1'b1;
			CLK_OUT <= 1;
		end
									
		else if ((count >= 25000000) && (count < 50000000))
		begin
			count <= count + 1'b1;
			CLK_OUT <= 0;
		end
									
		else
		begin
			count <= 1;
			CLK_OUT <= 1;
		end
	end
	
endmodule
