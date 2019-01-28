module Top_Ph4(input CLK,
               input reset);
         
  wire        PCSrc;
  wire [31:0] PCBranch;
  wire [2:0]  PCPlusSrc;
  wire [31:0] InstrF1;
  wire [31:0] InstrF2;
  wire [31:0] InstrF3;
  wire [31:0] InstrF4;
  wire [31:0] PCPlus4F;
  wire [31:0] PCPlus8F;
  wire [31:0] PCPlus12F;
  wire [31:0] PCPlus16F;
  
  //--------
  
  wire       ROBstall;
  wire [3:0] ROBRFTag;
  wire [4:0] ROBRFDst;
  wire       ROBRFE;
  
  wire       WE1;
  wire       WE2;
  wire [4:0] WA1;
  wire [4:0] WA2;
  wire [31:0] WD1;
  wire [31:0] WD2;
  wire [3:0]  WT1;
  wire [3:0]  WT2;
  
  reg [31:0] InstrD1;
  reg [31:0] InstrD2;
  reg [31:0] InstrD3;
  reg [31:0] InstrD4;
  
  reg [31:0] PCPlus4D1;
  reg [31:0] PCPlus4D2;
  reg [31:0] PCPlus4D3;
  reg [31:0] PCPlus4D4;
          
  wire [31:0] RDD11;
  wire [31:0] RDD21;
  wire [31:0] RDD12;
  wire [31:0] RDD22;
  wire [31:0] RDD13;
  wire [31:0] RDD23;
  wire [31:0] RDD14;
  wire [31:0] RDD24;
          
  wire [4:0] WriteRegD1;
  wire [4:0] WriteRegD2;
  wire [4:0] WriteRegD3;
  wire [4:0] WriteRegD4;
          
  wire [31:0] ExtImmD1;
  wire [31:0] ExtImmD2;
  wire [31:0] ExtImmD3;
  wire [31:0] ExtImmD4;
          
  wire [31:0] PCPlus41;
  wire [31:0] PCPlus42;
  wire [31:0] PCPlus43;
  wire [31:0] PCPlus44;
          
  wire [3:0]  ALUControlD1;
  wire [3:0]  ALUControlD2;
  wire [3:0]  ALUControlD3;
  wire [3:0]  ALUControlD4;
          
  wire        RegWriteD1;
  wire        RegWriteD2;
  wire        RegWriteD3;
  wire        RegWriteD4;
          
  wire        MemtoRegD1;
  wire        MemtoRegD2;
  wire        MemtoRegD3;
  wire        MemtoRegD4;
          
  wire        MemWriteD1;
  wire        MemWriteD2;
  wire        MemWriteD3;
  wire        MemWriteD4;
          
  wire        ALUSrcD1;
  wire        ALUSrcD2;
  wire        ALUSrcD3;
  wire        ALUSrcD4;
          
  wire        BranchD1;
  wire        BranchD2;
  wire        BranchD3;
  wire        BranchD4;
          
  wire        BranchND1;
  wire        BranchND2;
  wire        BranchND3;
  wire        BranchND4;
          
  wire [3:0]  TagD1;
  wire [3:0]  TagD2;
  wire [3:0]  TagD3;
  wire [3:0]  TagD4;
  
  wire        PredD1;
  wire        PredD2;
          
  wire        RSstall;
  
  wire [4:0] WriteReg;
  wire [1:0] InstrType;
  wire [1:0] idx; 
  
  //---------------
  
  reg         ALUSrcE1;
  reg  [3:0]  ALUControlE1;
  reg         BranchE1;
  reg         BranchNE1;
  reg  [31:0] RD1E1;
  reg  [31:0] RD2E1;
  reg  [31:0] ExtImmE1;
  reg  [31:0] PCPlus4E1;
  reg  [3:0]  TagE1;
  reg         PredE1;
  wire [31:0] ALUOutE1;
  wire [31:0] WriteDataE1;
  wire [3:0]  TagoE1;
  wire [31:0] PCBranch1;
  wire [4:0]  BTAPTag1;
  wire [31:0] BTAPAddr1;
  
  reg         ALUSrcE2;
  reg  [3:0]  ALUControlE2;
  reg         BranchE2;
  reg         BranchNE2;
  reg  [31:0] RD1E2;
  reg  [31:0] RD2E2;
  reg  [31:0] ExtImmE2;
  reg  [31:0] PCPlus4E2;
  reg  [3:0]  TagE2;
  reg         PredE2;
  wire [31:0] ALUOutE2;
  wire [31:0] WriteDataE2;
  wire [3:0]  TagoE2;
  wire [31:0] PCBranch2;
  wire [4:0]  BTAPTag2;
  wire [31:0] BTAPAddr2;
  
  reg         ALUSrcE3;
  reg  [3:0]  ALUControlE3;
  reg         BranchE3;
  reg         BranchNE3;
  reg  [31:0] RD1E3;
  reg  [31:0] RD2E3;
  reg  [31:0] ExtImmE3;
  reg  [31:0] PCPlus4E3;
  reg  [3:0]  TagE3;
  wire [31:0] ALUOutE3;
  wire [31:0] WriteDataE3;
  wire [3:0]  TagoE3;
  
  reg         ALUSrcE4;
  reg  [3:0]  ALUControlE4;
  reg         BranchE4;
  reg         BranchNE4;
  reg  [31:0] RD1E4;
  reg  [31:0] RD2E4;
  reg  [31:0] ExtImmE4;
  reg  [31:0] PCPlus4E4;
  reg  [3:0]  TagE4;
  wire [31:0] ALUOutE4;
  wire [31:0] WriteDataE4;
  wire [3:0]  TagoE4;
  
  //---------------
  
  wire [31:0] RDM;
  wire [3:0]  RToM;
  wire [4:0]  RWriteRegM;
  wire        RRegWriteM;
  wire        MRSModifyM;
  wire        out2enable;
          
  //---------------
  
  wire        branchFlush;
  wire        branchStall;
           
  wire [3:0]  ROBRSTag;//
  wire [31:0] ROBRSResult;
  wire        ROBRSModify;
  wire [3:0]  ROBhead;
  wire        ROBFlush;
  wire        ROBPCSrc;
  wire [31:0] ROBPCBranch;
  
  wire [3:0]  ROBTag;
  wire [31:0] ROBResult;
  wire [4:0]  ROBWriteReg;
  wire        ROBRegWrite;
  
  wire [3:0]  ROBTag2;
  wire [31:0] ROBResult2;
  wire [4:0]  ROBWriteReg2;
  wire        ROBRegWrite2;
  
  wire        ROBMWE;
  wire [31:0] ROBMWA;
  wire [31:0] ROBMWD;
  
  wire [31:0] ROBMRA;
  wire [3:0]  ROBMTag;
  wire [4:0]  ROBMWriteReg;
  wire        ROBMRegWrite;
   
  //---------------
  
  reg [3:0]  ROBTagW;
  reg [31:0] ROBResultW;
  reg [4:0]  ROBWriteRegW;
  reg        ROBRegWriteW;
  
  reg [3:0]  ROBTag2W;
  reg [31:0] ROBResult2W;
  reg [4:0]  ROBWriteReg2W;
  reg        ROBRegWrite2W;
  
  reg        ROBMWEW;
  reg [31:0] ROBMWAW;
  reg [31:0] ROBMWDW;
  
  reg [31:0] ROBMRAW;
  reg [3:0]  ROBMTagW;
  reg [4:0]  ROBMWriteRegW;
  reg        ROBMRegWriteW;
  
  //----------------
  
  assign WE1 = ROBRegWriteW; 
  assign WA1 = ROBWriteRegW;
  assign WD1 = ROBResultW;
  assign WT1 = ROBTagW;
  
  //----------------
  
  reg [3:0] MTagW;
  reg [31:0] MResultW;
  reg [4:0] MWriteRegW;
  reg       MRegWriteW;
  reg       out2enableW;
  wire      CacheReady;
  
  //-----------------
  
  assign WE2 = out2enableW ? ROBRegWrite2W : MRegWriteW; 
  assign WA2 = out2enableW ? ROBWriteReg2W : MWriteRegW;
  assign WD2 = out2enableW ? ROBResult2W : MResultW;
  assign WT2 = out2enableW ? ROBTag2W : MTagW;
  
  //-----------------
  
  wire [4:0]  BTAPTag;
  wire        BTAPpred;
  wire [31:0] BTAPAddr;
  wire        BTAPflush;
  
  assign PCSrc = BTAPflush | ROBPCSrc;
  assign PCBranch = ROBPCSrc ? ROBPCBranch : BTAPAddr;
  
  //-----------------
  
  wire [31:0] Addr;
  assign Addr = (ROBMTagW !== 4'dx) ? ROBMRAW : ROBMWAW;
  
  
  IF if1(CLK, reset, branchStall, PCSrc, PCBranch, PCPlusSrc, InstrF1, InstrF2, InstrF3, InstrF4, PCPlus4F,
         PCPlus8F, PCPlus12F, PCPlus16F);
         
  DE de1(CLK, reset, ROBstall, ROBRFTag, ROBRFDst, ROBRFE, BTAPflush, BTAPpred, WE1, WE2, WA1, WA2, WD1, WD2, WT1, WT2,
          InstrD1, InstrD2, InstrD3, InstrD4, PCPlus4D1, PCPlus4D2, PCPlus4D3, PCPlus4D4,
          ROBRSTag, ROBRSResult, ROBRSModify, ROBFlush, ROBhead, RDM, RToM, MRSModifyM,
          PCPlusSrc, RDD11, RDD21, RDD12, RDD22, RDD13, RDD23, RDD14, RDD24, WriteRegD1, WriteRegD2,
          WriteRegD3, WriteRegD4, ExtImmD1, ExtImmD2, ExtImmD3, ExtImmD4, PCPlus41, PCPlus42, PCPlus43,
          PCPlus44, ALUControlD1, ALUControlD2, ALUControlD3, ALUControlD4, RegWriteD1, RegWriteD2,
          RegWriteD3, RegWriteD4, MemtoRegD1, MemtoRegD2, MemtoRegD3, MemtoRegD4, MemWriteD1,
          MemWriteD2, MemWriteD3, MemWriteD4, ALUSrcD1, ALUSrcD2, ALUSrcD3, ALUSrcD4,
          BranchD1, BranchD2, BranchD3, BranchD4, BranchND1, BranchND2, BranchND3, BranchND4,
          TagD1, TagD2, TagD3, TagD4, PredD1, PredD2, RSstall, WriteReg, InstrType, idx, BTAPTag);
          
  EX ex1(.ALUSrc(ALUSrcE1), .ALUControl(ALUControlE1), .Branch(BranchE1), .BranchN(BranchNE1), 
         .RD1(RD1E1), .RD2(RD2E1), .ExtImm(ExtImmE1), .PCPlus4(PCPlus4E1), .Tag(TagE1), .Pred(PredE1),
         .PCSrc(PCSrc1), .ALUOut(ALUOutE1), .WriteData(WriteDataE1), .PCBranch(PCBranch1), .Tago(TagoE1), .BTAPTag(BTAPTag1), .BTAPAddr(BTAPAddr1));
    
  EX ex2(.ALUSrc(ALUSrcE2), .ALUControl(ALUControlE2), .Branch(BranchE2), .BranchN(BranchNE2), 
         .RD1(RD1E2), .RD2(RD2E2), .ExtImm(ExtImmE2), .PCPlus4(PCPlus4E2), .Tag(TagE2), .Pred(PredE2),
         .PCSrc(PCSrc2), .ALUOut(ALUOutE2), .WriteData(WriteDataE2), .PCBranch(PCBranch2), .Tago(TagoE2), .BTAPTag(BTAPTag2), .BTAPAddr(BTAPAddr2));
         
  EX ex3(.ALUSrc(ALUSrcE3), .ALUControl(ALUControlE3), .Branch(BranchE3), .BranchN(BranchNE3), 
         .RD1(RD1E3), .RD2(RD2E3), .ExtImm(ExtImmE3), .PCPlus4(PCPlus4E3), .Tag(TagE3),
         .ALUOut(ALUOutE3), .WriteData(WriteDataE3), .Tago(TagoE3));
         
  EX ex4(.ALUSrc(ALUSrcE4), .ALUControl(ALUControlE4), .Branch(BranchE4), .BranchN(BranchNE4), 
         .RD1(RD1E4), .RD2(RD2E4), .ExtImm(ExtImmE4), .PCPlus4(PCPlus4E4), .Tag(TagE4),
         .ALUOut(ALUOutE4), .WriteData(WriteDataE4), .Tago(TagoE4));
         
  ME me1(CLK, reset, Addr, ROBMTagW, ROBMWriteRegW, ROBMRegWriteW, ROBMWEW, ROBMWDW, RDM, RToM, RWriteRegM, RRegWriteM, MRSModifyM, out2enable, CacheReady);
  
  ROB rob1(CLK, reset, InstrType, WriteReg, RSstall, idx, ALUOutE1, TagoE1, PCSrc1, PCBranch1,
          ALUOutE2, TagoE2, PCSrc2, PCBranch2, ALUOutE3, WriteDataE3, TagoE3,
          ALUOutE4, TagoE4, out2enable, CacheReady, ROBstall, ROBRFTag, ROBRFDst, ROBRFE, ROBRSTag, ROBRSResult, ROBRSModify, ROBFlush, ROBhead, ROBPCSrc, ROBPCBranch,
          ROBTag, ROBResult, ROBWriteReg, ROBRegWrite, ROBTag2, ROBResult2, ROBWriteReg2, ROBRegWrite2, ROBMWE, ROBMWA, ROBMWD, ROBMRA, ROBMTag,
          ROBMWriteReg, ROBMRegWrite, branchFlush, branchStall);
  
  BTAP btap1(CLK, reset, BTAPTag, BTAPTag1, BTAPTag2, BTAPAddr1, BTAPAddr2, BTAPpred, BTAPAddr, BTAPflush);  
  
  //------------------
  
  always @(posedge CLK) begin
  
    if (reset | branchFlush | BTAPflush) begin
      InstrD1 <= 32'dx;
      InstrD2 <= 32'dx;
      InstrD3 <= 32'dx;
      InstrD4 <= 32'dx;
  
      PCPlus4D1 <= 32'dx;
      PCPlus4D2 <= 32'dx;
      PCPlus4D3 <= 32'dx;
      PCPlus4D4 <= 32'dx;
    end
    else if (branchStall) begin
      InstrD1 <= InstrD1;
      InstrD2 <= InstrD2;
      InstrD3 <= InstrD3;
      InstrD4 <= InstrD4;
  
      PCPlus4D1 <= PCPlus4D1;
      PCPlus4D2 <= PCPlus4D2;
      PCPlus4D3 <= PCPlus4D3;
      PCPlus4D4 <= PCPlus4D4;
    end
    else
    begin
      InstrD1 <= InstrF1;
      InstrD2 <= InstrF2;
      InstrD3 <= InstrF3;
      InstrD4 <= InstrF4;
  
      PCPlus4D1 <= PCPlus4F;
      PCPlus4D2 <= PCPlus8F;
      PCPlus4D3 <= PCPlus12F;
      PCPlus4D4 <= PCPlus16F;
    end
	
	  if (reset) begin
	    ALUSrcE1 <= 1'd0;
      ALUControlE1 <= 4'd0;
      BranchE1 <= 1'd0;
      BranchNE1 <= 1'd0;
      RD1E1 <= 31'd0;
      RD2E1 <= 31'd0;
      ExtImmE1 <= 31'd0;
      PCPlus4E1 <= 31'd0;
      TagE1 <= 4'dx;
      PredE1 <= 0;
    
      ALUSrcE2 <= 1'd0;
      ALUControlE2 <= 4'd0;
      BranchE2 <= 1'd0;
      BranchNE2 <= 1'd0;
      RD1E2 <= 31'd0;
      RD2E2 <= 31'd0;
      ExtImmE2 <= 31'd0;
      PCPlus4E2 <= 31'd0;
      TagE2 <= 4'dx;
      PredE2 <= 0;
      
      ALUSrcE3 <= 1'd0;
      ALUControlE3 <= 4'd0;
      BranchE3 <= 1'd0;
      BranchNE3 <= 1'd0;
      RD1E3 <= 31'd0;
      RD2E3 <= 31'd0;
      ExtImmE3 <= 31'd0;
      PCPlus4E3 <= 31'd0;
      TagE3 <= 4'dx;
      
      ALUSrcE4 <= 1'd0;
      ALUControlE4 <= 4'd0;
      BranchE4 <= 1'd0;
      BranchNE4 <= 1'd0;
      RD1E4 <= 31'd0;
      RD2E4 <= 31'd0;
      ExtImmE4 <= 31'd0;
      PCPlus4E4 <= 31'd0;
      TagE4 <= 4'dx;	 
    end
    else
    begin
      ALUSrcE1 <= ALUSrcD1;
      ALUControlE1 <= ALUControlD1;
      BranchE1 <= BranchD1;
      BranchNE1 <= BranchND1;
      RD1E1 <= RDD11;
      RD2E1 <= RDD21;
      ExtImmE1 <= ExtImmD1;
      PCPlus4E1 <= PCPlus41;
      TagE1 <= TagD1;
      PredE1 <= PredD1;
      
      ALUSrcE2 <= ALUSrcD2;
      ALUControlE2 <= ALUControlD2;
      BranchE2 <= BranchD2;
      BranchNE2 <= BranchND2;
      RD1E2 <= RDD12;
      RD2E2 <= RDD22;
      ExtImmE2 <= ExtImmD2;
      PCPlus4E2 <= PCPlus42;
      TagE2 <= TagD2;
      PredE2 <= PredD2;
      
      ALUSrcE3 <= ALUSrcD3;
      ALUControlE3 <= ALUControlD3;
      BranchE3 <= BranchD3;
      BranchNE3 <= BranchND3;
      RD1E3 <= RDD13;
      RD2E3 <= RDD23;
      ExtImmE3 <= ExtImmD3;
      PCPlus4E3 <= PCPlus43;
      TagE3 <= TagD3;
      
      ALUSrcE4 <= ALUSrcD4;
      ALUControlE4 <= ALUControlD4;
      BranchE4 <= BranchD4;
      BranchNE4 <= BranchND4;
      RD1E4 <= RDD14;
      RD2E4 <= RDD24;
      ExtImmE4 <= ExtImmD4;
      PCPlus4E4 <= PCPlus44;
      TagE4 <= TagD4;
    end
    
    if (reset) begin
      ROBTagW <= 4'dx;
	    ROBResultW <= 31'dx;
      ROBWriteRegW <= 5'dx;
      ROBRegWriteW <= 1'd0;
      
      ROBTag2W <= 4'dx;
	    ROBResult2W <= 31'dx;
      ROBWriteReg2W <= 5'dx;
      ROBRegWrite2W <= 1'd0;
  
      ROBMWEW <= 1'd0;
      ROBMWAW <= 31'dx;
      ROBMWDW <= 31'dx;
  
      ROBMRAW <= 31'dx;
      ROBMTagW <= 4'dx;
      ROBMWriteRegW <= 5'dx;
      ROBMRegWriteW <= 1'd0;
    end
    else
    begin
      ROBTagW <= ROBTag;
	    ROBResultW <= ROBResult;
      ROBWriteRegW <= ROBWriteReg;
      ROBRegWriteW <= ROBRegWrite;
      
      ROBTag2W <= ROBTag2;
	    ROBResult2W <= ROBResult2;
      ROBWriteReg2W <= ROBWriteReg2;
      ROBRegWrite2W <= ROBRegWrite2;
      
      if (CacheReady) begin
        ROBMWEW <= ROBMWE;
        ROBMWAW <= ROBMWA;
        ROBMWDW <= ROBMWD;
  
        ROBMRAW <= ROBMRA;
        ROBMTagW <= ROBMTag;
        ROBMWriteRegW <= ROBMWriteReg;
        ROBMRegWriteW <= ROBMRegWrite;
      end
      else begin
        ROBMWEW <= ROBMWEW;
        ROBMWAW <= ROBMWAW;
        ROBMWDW <= ROBMWDW;
  
        ROBMRAW <= ROBMRAW;
        ROBMTagW <= ROBMTagW;
        ROBMWriteRegW <= ROBMWriteRegW;
        ROBMRegWriteW <= ROBMRegWriteW;
      end
    end
	
	if (reset) begin
      MRegWriteW <= 1'd0;
      MWriteRegW <= 5'dx;
      MResultW <= 31'dx;
      MTagW <= 4'dx;
      out2enableW <= 1'd0;
    end
    else if (CacheReady) begin
      MRegWriteW <= RRegWriteM;
      MWriteRegW <= RWriteRegM;
      MResultW <= RDM;
      MTagW <= RToM;
      out2enableW <= out2enable;
    end
    else
    begin
      MRegWriteW <= RRegWriteM;
      MWriteRegW <= RWriteRegM;
      MResultW <= RDM;
      MTagW <= 4'dx;
      out2enableW <= out2enable;
    end
  end
           
               
endmodule
