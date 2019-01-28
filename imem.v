module imem(input  [31:0] a,
            output [31:0] rd1,
            output [31:0] rd2,
            output [31:0] rd3,
            output [31:0] rd4);

  reg [31:0] RAM [127:0];
  
  assign rd1 = RAM[a[31:2]];
  assign rd2 = RAM[a[31:2] + 'd1];
  assign rd3 = RAM[a[31:2] + 'd2]; 
  assign rd4 = RAM[a[31:2] + 'd3];
  
endmodule
