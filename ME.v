module ME(input         CLK,
          input         reset,
          input  [31:0] Addr,
          input  [3:0]  RT,
          input  [4:0]  RWriteReg,
          input         RRegWrite,
          input         MemWrite,
          input  [31:0] WriteData,
          output [31:0] ReadData,
          output [3:0]  RTo,
          output [4:0]  RWriteRego,
          output        RRegWriteo,
          output reg    MRSModify,
          output        out2enable,
          output        CacheReady);
          
  wire MemtoReg;      
  assign out2enable = 0;
  assign MemtoReg = (RT !== 4'dx);         
  assign RTo = RT;
  assign RWriteRego = RWriteReg;
  assign RRegWriteo = RRegWrite;
  
  always @(*) begin
    if (RT !== 4'dx & CacheReady) MRSModify = 1; else MRSModify = 0;
  end
         
  cache c1(CLK, reset, MemWrite, Addr, WriteData, MemtoReg, ReadData, CacheReady);

endmodule