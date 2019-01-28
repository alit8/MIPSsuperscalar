module EX(input         ALUSrc,
          input  [3:0]  ALUControl,
          input         Branch,
          input         BranchN,
          input  [31:0] RD1,
          input  [31:0] RD2,
          input  [31:0] ExtImm,
          input  [31:0] PCPlus4,
          //input  [4:0]  WriteReg,
          //input         RegWrite,
          //input         MemtoReg,
          //input         MemWrite,
          input  [3:0]  Tag,
          input         Pred,
          output        PCSrc,
          output [31:0] ALUOut,
          output [31:0] WriteData,
          //output [4:0]  WriteRego,
          output [31:0] PCBranch,
          //output        RegWriteo,
          //output        MemtoRego,
          //output        MemWriteo,
          output [3:0]  Tago,
          output [4:0]  BTAPTag,
          output [31:0] BTAPAddr);
          
  wire [31:0] SrcA;
  wire [31:0] SrcB;
  wire Zero;
  wire BranchTaken;
  
  assign SrcA = RD1; 
  assign SrcB = ALUSrc ? ExtImm : RD2;
  assign WriteData = RD2;

  //assign RegWrtieo = RegWrite;
  //assign MemtoRego = MemtoReg;
  //assign MemWriteo = MemWrite;
  //assign WriteRego = WriteReg;
  assign Tago = Tag; 
    
  alu a1(.a(SrcA), .b(SrcB), .alucontrol(ALUControl), .result(ALUOut), .zero(Zero));
  
  assign BranchTaken = (Branch & Zero) | (BranchN & (!Zero));
  assign PCSrc = (BranchTaken != Pred);
  assign BTAPTag = PCSrc ? PCPlus4[6:2] - 5'd1 : 5'dx;
  assign BTAPAddr = (ExtImm << 2) + PCPlus4;
  assign PCBranch = BranchTaken ? (ExtImm << 2) + PCPlus4 : PCPlus4;
  
endmodule
  
  