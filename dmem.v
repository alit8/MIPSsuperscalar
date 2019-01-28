`timescale 1ns/1ns

module dmem(clk, we, a, wd, rd);
  
  parameter BLOCK_SIZE = 8;
  
  input                        clk;
  input                        we;
  input  [31:0]                a;
  input  [BLOCK_SIZE*32 - 1:0] wd;
  output [BLOCK_SIZE*32 - 1:0] rd;
  
  reg [31:0] RAM [999:0];
  
  reg dwe;
  reg [31:0] da;
  reg [BLOCK_SIZE*32 - 1:0] dwd;
  
  always @(*)
  begin
    dwe <= #30 we;
    da <= #30 a;
    dwd <= #30 wd;
  end

  assign rd = {RAM[{da[31:5],3'd7}], RAM[{da[31:5],3'd6}], RAM[{da[31:5],3'd5}], RAM[{da[31:5],3'd4}], RAM[{da[31:5],3'd3}], RAM[{da[31:5],3'd2}], RAM[{da[31:5],3'd1}], RAM[{da[31:5],3'd0}]};

  always @(posedge clk)
  begin
    if (dwe) 
      begin
        {RAM[{da[31:5],3'd7}], RAM[{da[31:5],3'd6}], RAM[{da[31:5],3'd5}], RAM[{da[31:5],3'd4}], RAM[{da[31:5],3'd3}], RAM[{da[31:5],3'd2}], RAM[{da[31:5],3'd1}], RAM[{da[31:5],3'd0}]} <= dwd;
      end   
  end
  
endmodule
