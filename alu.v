module alu(input		    [31:0]	a, 
           input		    [31:0]	b, 
	         input		    [3:0]	 alucontrol,
           output	reg	[31:0]	result,
	         output				        zero,
	         output	reg			     overflow);
	         
	assign zero = (result == 32'b0);
	
	always @(*)
	begin
		overflow = 1'b0;
		case (alucontrol)
			4'b0000: {overflow,result} = $signed(a) + $signed(b);
			4'b0001: result = a + b;
			4'b0010: {overflow,result} = $signed(a) - $signed(b);
			4'b0011: result = a - b;
			4'b0100: result = a & b;
			4'b0101: result = a | b;
			4'b0110: result = a ^ b;
			4'b0111: result = ~(a | b);
			4'b1100: result = ($signed(a) < $signed(b));
			4'b1101: result = (a < b);
		endcase
	end
	
endmodule
