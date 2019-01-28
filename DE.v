`timescale 1ns/100ps

module DE(input         CLK,
          input         reset,
          
          input         ROBstall,
          input  [3:0]  ROBRFTag,
          input  [4:0]  ROBRFDst,
          input         ROBRFE,
          
          input         BTAPstall,
          input         BTAPpred,
          
          input         WE1,
          input         WE2,
          input  [4:0]  WA1,
          input  [4:0]  WA2,
          input  [31:0] WD1,
          input  [31:0] WD2,
          input  [3:0]  WT1,
          input  [3:0]  WT2,
          
          input  [31:0] InstrD1,
          input  [31:0] InstrD2,
          input  [31:0] InstrD3,
          input  [31:0] InstrD4,
          
          input  [31:0] PCPlus4D1,
          input  [31:0] PCPlus4D2,
          input  [31:0] PCPlus4D3,
          input  [31:0] PCPlus4D4,
          
          input  [3:0]  ROBRSTag,
          input  [31:0] ROBRSResult,
          input         ROBRSModify,
          input         ROBFlush,
          input  [3:0]  ROBhead,
          
          input  [31:0] RDM,
          input  [3:0]  RToM,
          input         MRSModify,
          
          output reg [2:0] PCPlusSrc,
          
          output [31:0] RDD11,
          output [31:0] RDD21,
          output [31:0] RDD12,
          output [31:0] RDD22,
          output [31:0] RDD13,
          output [31:0] RDD23,
          output [31:0] RDD14,
          output [31:0] RDD24,
          
          output [4:0] WriteRegD1,
          output [4:0] WriteRegD2,
          output [4:0] WriteRegD3,
          output [4:0] WriteRegD4,
          
          output [31:0] ExtImmD1,
          output [31:0] ExtImmD2,
          output [31:0] ExtImmD3,
          output [31:0] ExtImmD4,
          
          output [31:0] PCPlus41,
          output [31:0] PCPlus42,
          output [31:0] PCPlus43,
          output [31:0] PCPlus44,
          
          output [3:0]  ALUControlD1,
          output [3:0]  ALUControlD2,
          output [3:0]  ALUControlD3,
          output [3:0]  ALUControlD4,
          
          output        RegWriteD1,
          output        RegWriteD2,
          output        RegWriteD3,
          output        RegWriteD4,
          
          output        MemtoRegD1,
          output        MemtoRegD2,
          output        MemtoRegD3,
          output        MemtoRegD4,
          
          output        MemWriteD1,
          output        MemWriteD2,
          output        MemWriteD3,
          output        MemWriteD4,
          
          output        ALUSrcD1,
          output        ALUSrcD2,
          output        ALUSrcD3,
          output        ALUSrcD4,
          
          output        BranchD1,
          output        BranchD2,
          output        BranchD3,
          output        BranchD4,
          
          output        BranchND1,
          output        BranchND2,
          output        BranchND3,
          output        BranchND4,
          
          output [3:0]  TagD1,
          output [3:0]  TagD2,
          output [3:0]  TagD3,
          output [3:0]  TagD4,
          
          output        PredD1,
          output        PredD2,
          
          output reg    RSstall,
          
          output reg [4:0] WriteReg,
          output reg [1:0] InstrType,
          output reg [1:0] idx,
          
          output reg [4:0] BTAPTag);
  
  reg  [3:0] RFTag;
  reg  [4:0] RFDst;        
  reg RFE;            
          
  reg [4:0]  RA1 [3:0];
  reg [4:0]  RA2 [3:0];
  wire [4:0] A1 [3:0];
  wire [4:0] A2 [3:0];
  wire  [31:0] RD1 [3:0];
  wire  [31:0] RD2 [3:0];
  wire         V1 [3:0];
  wire         V2 [3:0];
  wire [4:0]  RsD [3:0];
  wire [4:0]  RtD [3:0];
  wire [4:0]  RdD [3:0];
  wire [31:0] ExtImm [3:0];
  wire [31:0] PCPlus4[3:0];
  wire [31:0] PC[3:0];
  
  //-------------
  
  assign A1[0] = InstrD1[25:21];
  assign A2[0] = InstrD1[20:16];
  assign RsD[0] = InstrD1[25:21];
  assign RtD[0] = InstrD1[20:16];
  assign RdD[0] = InstrD1[15:11];
  
  assign PCPlus4[0] = PCPlus4D1;
  assign PC[0] = PCPlus4[0] - 32'd4;
  
  //-------------
 
  assign A1[1] = InstrD2[25:21];
  assign A2[1] = InstrD2[20:16];
  assign RsD[1] = InstrD2[25:21];
  assign RtD[1] = InstrD2[20:16];
  assign RdD[1] = InstrD2[15:11];
  
  assign PCPlus4[1] = PCPlus4D2;
  assign PC[1] = PCPlus4[1] - 32'd4;
  
  //-------------
  
  assign A1[2] = InstrD3[25:21];
  assign A2[2] = InstrD3[20:16];
  assign RsD[2] = InstrD3[25:21];
  assign RtD[2] = InstrD3[20:16];
  assign RdD[2] = InstrD3[15:11];
  
  assign PCPlus4[2] = PCPlus4D3;
  assign PC[2] = PCPlus4[2] - 32'd4;
  
  //-------------
  
  assign A1[3] = InstrD4[25:21];
  assign A2[3] = InstrD4[20:16];
  assign RsD[3] = InstrD4[25:21];
  assign RtD[3] = InstrD4[20:16];
  assign RdD[3] = InstrD4[15:11];
  
  assign PCPlus4[3] = PCPlus4D4;
  assign PC[3] = PCPlus4[3] - 32'd4;
  
  //-------------

  //assign RD1D1 = ((A11 == WriteReg1) & (A11 != 0) & RegWrite1) ? ResultW1 : (((A11 == WriteReg2) & (A11 != 0) & RegWrite2) ? ResultW2 : RD11);
  //assign RD2D1 = ((A21 == WriteReg1) & (A21 != 0) & RegWrite1) ? ResultW1 : (((A21 == WriteReg2) & (A21 != 0) & RegWrite2) ? ResultW2 : RD21);
  
  //assign RD1D2 = ((A12 == WriteReg1) & (A12 != 0) & RegWrite1) ? ResultW1 : (((A12 == WriteReg2) & (A12 != 0) & RegWrite2) ? ResultW2 : RD12);
  //assign RD2D2 = ((A22 == WriteReg1) & (A22 != 0) & RegWrite1) ? ResultW1 : (((A22 == WriteReg2) & (A22 != 0) & RegWrite2) ? ResultW2 : RD22);

  //assign RD1D3 = ((A13 == WriteReg1) & (A13 != 0) & RegWrite1) ? ResultW1 : (((A13 == WriteReg2) & (A13 != 0) & RegWrite2) ? ResultW2 : RD13);
  //assign RD2D3 = ((A23 == WriteReg1) & (A23 != 0) & RegWrite1) ? ResultW1 : (((A23 == WriteReg2) & (A23 != 0) & RegWrite2) ? ResultW2 : RD23);

  //assign RD1D4 = ((A14 == WriteReg1) & (A14 != 0) & RegWrite1) ? ResultW1 : (((A14 == WriteReg2) & (A14 != 0) & RegWrite2) ? ResultW2 : RD14);
  //assign RD2D4 = ((A24 == WriteReg1) & (A24 != 0) & RegWrite1) ? ResultW1 : (((A24 == WriteReg2) & (A24 != 0) & RegWrite2) ? ResultW2 : RD24);
  
  //-------------------------------------------
  
  wire [5:0] Op [3:0];
  wire [5:0] Funct [3:0];
  wire [3:0] ALUControl [3:0];
  wire       RegWrite [3:0];
  wire       MemtoReg [3:0]; 
  wire       MemWrite [3:0];
  wire       ALUSrc   [3:0];
  wire       RegDst   [3:0];
  wire       Branch   [3:0]; 
  wire       BranchN  [3:0];
  wire       SignExt  [3:0];
  
  //---------------
  
  assign Op[0] = InstrD1[31:26];
  assign Funct[0] = InstrD1[5:0];
  
  CU cu1(Op[0], Funct[0], RegWrite[0], MemtoReg[0], MemWrite[0], ALUControl[0], ALUSrc[0], RegDst[0], Branch[0], BranchN[0], SignExt[0]);
  
  assign ExtImm[0] = SignExt[0] ? {{16{InstrD1[15]}}, InstrD1[15:0]} : {{16'd0}, InstrD1[15:0]};
  
  //---------------
  
  assign Op[1] = InstrD2[31:26];
  assign Funct[1] = InstrD2[5:0];
  
  CU cu2(Op[1], Funct[1], RegWrite[1], MemtoReg[1], MemWrite[1], ALUControl[1], ALUSrc[1], RegDst[1], Branch[1], BranchN[1], SignExt[1]);
  
  assign ExtImm[1] = SignExt[1] ? {{16{InstrD2[15]}}, InstrD2[15:0]} : {{16'd0}, InstrD2[15:0]};
  
  //---------------
  
  assign Op[2] = InstrD3[31:26];
  assign Funct[2] = InstrD3[5:0];
  
  CU cu3(Op[2], Funct[2], RegWrite[2], MemtoReg[2], MemWrite[2], ALUControl[2], ALUSrc[2], RegDst[2], Branch[2], BranchN[2], SignExt[2]);
  
  assign ExtImm[2] = SignExt[2] ? {{16{InstrD3[15]}}, InstrD3[15:0]} : {{16'd0}, InstrD3[15:0]};
  
  //---------------
   
  assign Op[3] = InstrD4[31:26];
  assign Funct[3] = InstrD4[5:0];
  
  CU cu4(Op[3], Funct[3], RegWrite[3], MemtoReg[3], MemWrite[3], ALUControl[3], ALUSrc[3], RegDst[3], Branch[3], BranchN[3], SignExt[3]);
  
  assign ExtImm[3] = SignExt[3] ? {{16{InstrD4[15]}}, InstrD4[15:0]} : {{16'd0}, InstrD4[15:0]};
  
  //---------------
  
  reg [31:0] RSd1 [2:0]; 
  reg        RSv1 [2:0]; 
  reg [31:0] RSd2 [2:0]; 
  reg        RSv2 [2:0]; 
  reg [3:0]  RStag [2:0]; 
  reg [4:0]  RSwritereg [2:0];
  reg [3:0]  RSalucontrol [2:0];
  reg        RSregwrite [2:0];
  reg        RSmemtoreg [2:0];
  reg        RSmemwrite [2:0];
  reg        RSalusrc [2:0]; 
  reg        RSbranch [2:0];
  reg        RSbranchn [2:0];
  reg [31:0] RSextimm [2:0];
  reg [31:0] RSPCPlus4 [2:0];
  reg        RSPred;
  
  wire        RSstall1;
  wire        RSstall2;
  wire        RSstall3;
  
  parameter [1:0] load = 2'd3;
  parameter [1:0] store = 2'd2;
  parameter [1:0] branch = 2'd1;
  parameter [1:0] arith = 2'd0;
  
  integer i;
  
  always @(posedge CLK) begin
    RSstall = 0;
  end
  
  always @(posedge CLK)
  begin
    idx = 2'dx;
    BTAPTag = 5'dx;
    #0.5
    for (i=0; (i<4) & (!ROBstall) & (!RSstall) & (!ROBFlush) & (!BTAPstall); i=i+1)
    begin
       RA1[i] = A1[i];
       RA2[i] = A2[i];
      
       #0.5;
             
       if (RegDst[i]) WriteReg = RdD[i]; else WriteReg = RtD[i];
       
       if (MemtoReg[i]) begin
          InstrType = load;
       end
       else if (MemWrite[i]) begin
          InstrType = store;
       end
       else if (Branch[i] | BranchN[i]) begin
          InstrType = branch;
       end
       else if (A1[i] === 5'dx) begin
          InstrType = 2'dx;
       end
       else begin
          InstrType = arith;
       end
      	
      	idx = i;
      	
      	#1;
      	
      	if (!RSstall & ROBRFE) begin
         RFE = 1;
         RFTag = ROBRFTag;
         RFDst = ROBRFDst;
       end
       else
       begin
         RFE = 0;
  	    end
    	
       if (RSstall | ROBstall) begin
          PCPlusSrc = idx + 1;
       end
       else if (BTAPstall) begin
          PCPlusSrc = 3'd0;
       end
       else if (reset)
       begin
          PCPlusSrc = 3'd0;
       end
       else
       begin   
          PCPlusSrc = 3'd0;
       end
    end 
  end
  
  always @(ROBRFTag) begin
    if (!ROBstall)
       begin
         case(InstrType)
           arith:
           begin
             BTAPTag = 5'dx;
             RStag[0] = 4'dx;
             #0.1;
             RSd1[0] = RD1[i]; 
             RSv1[0] = V1[i]; 
             RSd2[0] = RD2[i];
             if (Op[i] == 6'd0 | InstrType == branch) 
              RSv2[0] = V2[i];
             else
              RSv2[0] = 1'b1;
             RStag[0] = ROBRFTag; 
             RSwritereg[0] = WriteReg;
             RSalucontrol[0] = ALUControl[i];
             RSregwrite[0] = RegWrite[i];
             RSmemtoreg[0] = MemtoReg[i];
             RSmemwrite[0] = MemWrite[i];
             RSalusrc[0] = ALUSrc[i]; 
             RSbranch[0] = Branch[i];
             RSbranchn[0] = BranchN[i];
             RSextimm[0] = ExtImm[i];
             RSPCPlus4[0] = PCPlus4[i];
             RSPred = BTAPpred;
             #0.4;
             RSstall = RSstall1;
           end
           
           branch:
           begin
             BTAPTag = PC[i][6:2];
             RStag[0] = 4'dx;
             #0.1;
             RSd1[0] = RD1[i]; 
             RSv1[0] = V1[i]; 
             RSd2[0] = RD2[i];
             if (Op[i] == 6'd0 | InstrType == branch) 
              RSv2[0] = V2[i];
             else
              RSv2[0] = 1'b1;
             RStag[0] = ROBRFTag; 
             RSwritereg[0] = WriteReg;
             RSalucontrol[0] = ALUControl[i];
             RSregwrite[0] = RegWrite[i];
             RSmemtoreg[0] = MemtoReg[i];
             RSmemwrite[0] = MemWrite[i];
             RSalusrc[0] = ALUSrc[i]; 
             RSbranch[0] = Branch[i];
             RSbranchn[0] = BranchN[i];
             RSextimm[0] = ExtImm[i];
             RSPCPlus4[0] = PCPlus4[i];
             RSPred = BTAPpred;
             #0.4;
             RSstall = RSstall1;
           end
           
           store:
           begin
             BTAPTag = 5'dx;
             RStag[1] = 4'dx;
             #0.1;
             RSd1[1] = RD1[i]; 
             RSv1[1] = V1[i]; 
             RSd2[1] = RD2[i]; 
             RSv2[1] = V2[i];
             RStag[1] = ROBRFTag; 
             RSwritereg[1] = WriteReg;
             RSalucontrol[1] = ALUControl[i];
             RSregwrite[1] = RegWrite[i];
             RSmemtoreg[1] = MemtoReg[i];
             RSmemwrite[1] = MemWrite[i];
             RSalusrc[1] = ALUSrc[i]; 
             RSbranch[1] = Branch[i];
             RSbranchn[1] = BranchN[i];
             RSextimm[1] = ExtImm[i];
             RSPCPlus4[1] = PCPlus4[i];
             #0.4;
             RSstall = RSstall2;
           end
           
           load:
           begin
             BTAPTag = 5'dx;
             RStag[2] = 4'dx;
             #0.1;
             RSd1[2] = RD1[i]; 
             RSv1[2] = V1[i]; 
             RSd2[2] = RD2[i]; 
             RSv2[2] = 1'b1;
             RStag[2] = ROBRFTag; 
             RSwritereg[2] = WriteReg;
             RSalucontrol[2] = ALUControl[i];
             RSregwrite[2] = RegWrite[i];
             RSmemtoreg[2] = MemtoReg[i];
             RSmemwrite[2] = MemWrite[i];
             RSalusrc[2] = ALUSrc[i]; 
             RSbranch[2] = Branch[i];
             RSbranchn[2] = BranchN[i];
             RSextimm[2] = ExtImm[i];
             RSPCPlus4[2] = PCPlus4[i];
             #0.4;
             RSstall = RSstall3;
           end
         endcase
         
       end
  end

  regfile rf1(CLK, reset, RA1[0], RA2[0], RA1[1], RA2[1], RA1[2], RA2[2], RA1[3], RA2[3], WE1, WE2, WA1, WA2,
              WD1, WD2, WT1, WT2, RFTag, RFDst, RFE, ROBFlush, RD1[0], RD2[0], RD1[1], RD2[1], RD1[2], RD2[2], RD1[3], RD2[3], V1[0], V2[0], V1[1], V2[1],
              V1[2], V2[2], V1[3], V2[3]);
  
  RS2 rs1(CLK, reset, RSd1[0], RSv1[0], RSd2[0], RSv2[0], RStag[0], RSwritereg[0], 
                    RSalucontrol[0], RSregwrite[0], RSmemtoreg[0], RSmemwrite[0], 
                    RSalusrc[0], RSbranch[0], RSbranchn[0], RSextimm[0], RSPCPlus4[0], RSPred,
                    ROBRSTag, ROBRSResult, ROBRSModify, ROBFlush, ROBhead, RDM, RToM, MRSModify,
                    WT1, WD1, WE1, WT2, WD2, WE2,
                    RSstall1, RDD11, RDD21, WriteRegD1, ExtImmD1, PCPlus41,
                    ALUControlD1, RegWriteD1, MemtoRegD1, MemWriteD1, ALUSrcD1, BranchD1, BranchND1, TagD1, PredD1, 
                    RDD12, RDD22, WriteRegD2, ExtImmD2, PCPlus42,
                    ALUControlD2, RegWriteD2, MemtoRegD2, MemWriteD2, ALUSrcD2, BranchD2, BranchND2, TagD2, PredD2);
                    
  RS1 rs2(CLK, reset, RSd1[1], RSv1[1], RSd2[1], RSv2[1], RStag[1], RSwritereg[1], 
                    RSalucontrol[1], RSregwrite[1], RSmemtoreg[1], RSmemwrite[1], 
                    RSalusrc[1], RSbranch[1], RSbranchn[1], RSextimm[1], RSPCPlus4[1],
                    ROBRSTag, ROBRSResult, ROBRSModify, ROBFlush, ROBhead, RDM, RToM, MRSModify, 
                    WT1, WD1, WE1, WT2, WD2, WE2,
                    RSstall2, RDD13, RDD23, WriteRegD3, ExtImmD3, PCPlus43,
                    ALUControlD3, RegWriteD3, MemtoRegD3, MemWriteD3, ALUSrcD3, BranchD3, BranchND3, TagD3); 
  
  RS1 rs3(CLK, reset, RSd1[2], RSv1[2], RSd2[2], RSv2[2], RStag[2], RSwritereg[2], 
                    RSalucontrol[2], RSregwrite[2], RSmemtoreg[2], RSmemwrite[2], 
                    RSalusrc[2], RSbranch[2], RSbranchn[2], RSextimm[2], RSPCPlus4[2],
                    ROBRSTag, ROBRSResult, ROBRSModify, ROBFlush, ROBhead, RDM, RToM, MRSModify,
                    WT1, WD1, WE1, WT2, WD2, WE2,
                    RSstall3, RDD14, RDD24, WriteRegD4, ExtImmD4, PCPlus44,
                    ALUControlD4, RegWriteD4, MemtoRegD4, MemWriteD4, ALUSrcD4, BranchD4, BranchND4, TagD4);
  
                      
endmodule
  
  

    


