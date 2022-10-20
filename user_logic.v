module adder (input wire clk,
              input reg [31:0] a,
              input reg [31:0] b,
              output reg [31:0] c);

  always@(posedge clk)
	begin
	    c <= a + b;
	end
endmodule

