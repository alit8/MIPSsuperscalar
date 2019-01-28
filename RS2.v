module RS2(CLK, reset, d1, dv1, d2, dv2, tag, writereg, alucontrol, regwrite, memtoreg, memwrite, alusrc, 
                branch, branchn, extimm, pcplus4, pred, ROBRSTag, ROBRSResult, ROBRSModify, ROBFlush, ROBhead, RDM, RToM, 
                MRSModify, WT1, WD1, WE1, WT2, WD2, WE2, stall, do11, do21, writerego1, extimmo1, pcplus4o1, 
                alucontrolo1, regwriteo1, memtorego1, memwriteo1, alusrco1, brancho1, branchno1, tago1, predo1,                do12, do22, writerego2, extimmo2, pcplus4o2,
                alucontrolo2, regwriteo2, memtorego2, memwriteo2, alusrco2, brancho2, branchno2, tago2, predo2);
                
  parameter SIZE = 16;
  
  input        CLK;
  input        reset;
  input [31:0] d1;
  input        dv1;
  input [31:0] d2;
  input        dv2;
  input [3:0]  tag;
  input [4:0]  writereg;
  input [3:0]  alucontrol;
  input        memtoreg, regwrite, memwrite, alusrc, branch, branchn;
  input [31:0] extimm;
  input [31:0] pcplus4;
  input        pred;
  
  input  [3:0]  ROBRSTag;
  input  [31:0] ROBRSResult;
  input         ROBRSModify;
  input         ROBFlush;
  input  [3:0]  ROBhead;
          
  input  [31:0] RDM;
  input  [3:0]  RToM;
  input         MRSModify;
  
  input  [3:0]  WT1;
  input  [31:0] WD1;
  input         WE1;
  
  input  [3:0]  WT2;
  input  [31:0] WD2;
  input         WE2;
  
  output reg   stall;
  
  output reg [31:0] do11;
  output reg [31:0] do21;
  output reg [4:0]  writerego1;
  output reg [31:0] extimmo1;
  output reg [31:0] pcplus4o1;
  output reg [3:0]  alucontrolo1;
  output reg        regwriteo1, memtorego1, memwriteo1, alusrco1, brancho1, branchno1;
  output reg [3:0]  tago1;
  output reg        predo1; 
  output reg [31:0] do12;
  output reg [31:0] do22;
  output reg [4:0]  writerego2;
  output reg [31:0] extimmo2;
  output reg [31:0] pcplus4o2;
  output reg [3:0]  alucontrolo2;
  output reg        regwriteo2, memtorego2, memwriteo2, alusrco2, brancho2, branchno2;
  output reg [3:0]  tago2;
  output reg        predo2;  
  
  reg [SIZE-1:0]  R;
  reg [31:0]      D1         [SIZE-1:0];
  reg             Dv1        [SIZE-1:0];
  reg [31:0]      D2         [SIZE-1:0];
  reg             Dv2        [SIZE-1:0];
  reg [3:0]       Tag        [SIZE-1:0];
  reg [4:0]       WriteReg   [SIZE-1:0];
  reg [3:0]       ALUControl [SIZE-1:0];
  reg             MemtoReg   [SIZE-1:0];
  reg             RegWrite   [SIZE-1:0];
  reg             MemWrite   [SIZE-1:0];
  reg             ALUSrc     [SIZE-1:0];
  reg             Branch     [SIZE-1:0];
  reg             BranchN    [SIZE-1:0];
  reg [31:0]      ExtImm     [SIZE-1:0];
  reg [31:0]      PCPlus4    [SIZE-1:0];
  reg [SIZE-1:0]  Pred;
  
  
  reg [SIZE-1:0]  NoR;
  reg [1:0]       NoI;
  reg             done;
  
  always @(*)
  begin
    if (reset) begin
      NoR = 'd0;
      R = 'd0;
      NoI = 2'd0;
      stall = 0;
      done = 0;
    end
  end
  
  always @(posedge CLK) begin
    NoI <= 2'd0;
  end
  
  integer i;
  integer j;
  integer k;
  
  always @(tag) begin
    done = 0;
  end
  
  always @(*)
  begin
    
    stall = 0;
    
    if (NoR == SIZE) begin
      stall <= 1;
      done <= 1;
    end
    
    for (i = 0; (i<SIZE) & (!done); i=i+1) begin
      if (R[i] == 0 & tag !== 4'dx) begin
        done = 1;
        R[i] = 1'b1;
        D1[i] = d1;
        Dv1[i] = dv1;
        D2[i] = d2;
        Dv2[i] = dv2;
        Tag[i] = tag;
        WriteReg[i] = writereg;
        ALUControl[i] = alucontrol;
        MemtoReg[i] = memtoreg;
        RegWrite[i] = regwrite;
        MemWrite[i] = memwrite;
        ALUSrc[i] = alusrc;
        Branch[i] = branch;
        BranchN[i] = branchn;
        ExtImm[i] = extimm;
        PCPlus4[i] = pcplus4;
        Pred[i] = pred;
        
        stall = 0;
        NoR = NoR + 1;
      end
    end
    
      for (j=0; (j<SIZE) & (NoI != 2'd2) & (!ROBFlush); j=j+1) begin
        if (R[j] & (Dv1[j] & Dv2[j])) begin
           if (NoI == 2'd0) begin
              do11 = D1[j];
              do21 = D2[j];
              writerego1 = WriteReg[j];
              extimmo1 = ExtImm[j];
              pcplus4o1 = PCPlus4[j];
              alucontrolo1 = ALUControl[j];
              regwriteo1 = RegWrite[j];
              memtorego1 = MemtoReg[j];
              memwriteo1 = MemWrite[j];
              alusrco1 = ALUSrc[j];
              brancho1 = Branch[j];
              branchno1 = BranchN[j];
              tago1 = Tag[j];
              predo1 = Pred[j];
           
              R[j] = 0;
           
              NoR = NoR - 1;
              NoI = NoI + 1;
           end else if (NoI == 2'd1) begin
              do12 = D1[j];
              do22 = D2[j];
              writerego2 = WriteReg[j];
              extimmo2 = ExtImm[j];
              pcplus4o2 = PCPlus4[j];
              alucontrolo2 = ALUControl[j];
              regwriteo2 = RegWrite[j];
              memtorego2 = MemtoReg[j];
              memwriteo2 = MemWrite[j];
              alusrco2 = ALUSrc[j];
              brancho2 = Branch[j];
              branchno2 = BranchN[j];
              tago2 = Tag[j];
              predo2 = Pred[j];
           
              R[j] = 0;
           
              NoR = NoR - 1;
              NoI = NoI + 1;
           end
        end
      end
    
    if (NoI == 0) begin
       do11 = 31'd0;
       do21 = 31'd0;
       writerego1 = 5'd0;
       extimmo1 = 31'd0;
       pcplus4o1 = 31'd0;
       alucontrolo1 = 4'd0;
       regwriteo1 = 0;
       memtorego1 = 0;
       memwriteo1 = 0;
       alusrco1 = 0;
       brancho1 = 0;
       branchno1 = 0;
       tago1 = 4'dx;
       predo1 = 0;
       
       do12 = 31'd0;
       do22 = 31'd0;
       writerego2 = 5'd0;
       extimmo2 = 31'd0;
       pcplus4o2 = 31'd0;
       alucontrolo2 = 4'd0;
       regwriteo2 = 0;
       memtorego2 = 0;
       memwriteo2 = 0;
       alusrco2 = 0;
       brancho2 = 0;
       branchno2 = 0;
       tago2 = 4'dx;
       predo2 = 0;
    end 
    else if (NoI == 1) begin
       do12 = 31'd0;
       do22 = 31'd0;
       writerego2 = 5'd0;
       extimmo2 = 31'd0;
       pcplus4o2 = 31'd0;
       alucontrolo2 = 4'd0;
       regwriteo2 = 0;
       memtorego2 = 0;
       memwriteo2 = 0;
       alusrco2 = 0;
       brancho2 = 0;
       branchno2 = 0;
       tago2 = 4'dx;
       predo2 = 0;
    end
    
  end
  
  /*always @(ROBRSTag or ROBRSResult or ROBRSModify) begin
      for (k = 0; k<SIZE; k=k+1) begin
        if (ROBRSModify & ROBRSTag !== 4'dx) begin
         if (!Dv1[k]) begin
          if (D1[k][3:0] == ROBRSTag) begin
            D1[k] = ROBRSResult;
            Dv1[k] = 1;
          end              
         end
        
         if (!Dv2[k]) begin
          if (D2[k][3:0] == ROBRSTag) begin
            D2[k] = ROBRSResult;
            Dv2[k] = 1;
          end              
         end
        end
      end   
  end*/
  
  always @(ROBFlush) begin
     if (ROBFlush) begin
        R = 'd0;
        NoR = 'd0;
        NoI = 'd0;
        
        do11 = 31'd0;
        do21 = 31'd0;
        writerego1 = 5'd0;
        extimmo1 = 31'd0;
        pcplus4o1 = 31'd0;
        alucontrolo1 = 4'd0;
        regwriteo1 = 0;
        memtorego1 = 0;
        memwriteo1 = 0;
	      alusrco1 = 0;
        brancho1 = 0;
        branchno1 = 0;
        tago1 = 4'dx;
        predo1 = 0;
        
        do12 = 31'd0;
        do22 = 31'd0;
        writerego2 = 5'd0;
        extimmo2 = 31'd0;
        pcplus4o2 = 31'd0;
        alucontrolo2 = 4'd0;
        regwriteo2 = 0;
        memtorego2 = 0;
        memwriteo2 = 0;
      	 alusrco2 = 0;
        brancho2 = 0;
        branchno2 = 0;
        tago2 = 4'dx;
        predo2 = 0;
     end
  end
  
  always @(WT1 or NoR) begin
      for (k = 0; k<SIZE; k=k+1) begin
        if (WE1 & WT1 !== 4'dx) begin
         if (!Dv1[k]) begin
          if (D1[k][3:0] == WT1) begin
            D1[k] = WD1;
            Dv1[k] = 1;
          end              
         end
        
         if (!Dv2[k]) begin
          if (D2[k][3:0] == WT1) begin
            D2[k] = WD1;
            Dv2[k] = 1;
          end              
         end
        end 
      end
  end
  
  always @(WT2 or NoR) begin
      for (k = 0; k<SIZE; k=k+1) begin
        if (WE2 & WT2 !== 4'dx) begin
         if (!Dv1[k]) begin
          if (D1[k][3:0] == WT2) begin
            D1[k] = WD2;
            Dv1[k] = 1;
          end              
         end
        
         if (!Dv2[k]) begin
          if (D2[k][3:0] == WT2) begin
            D2[k] = WD2;
            Dv2[k] = 1;
          end              
         end
        end 
      end
  end
  
  /*always @(RDM or RToM or MRSModify or NoR) begin
      for (k = 0; k<SIZE; k=k+1) begin
        if (MRSModify & RToM !== 4'dx) begin
         if (!Dv1[k]) begin
          if (D1[k][3:0] == RToM) begin
            D1[k] = RDM;
            Dv1[k] = 1;
          end              
         end
        
         if (!Dv2[k]) begin
          if (D2[k][3:0] == RToM) begin
            D2[k] = RDM;
            Dv2[k] = 1;
          end              
         end
        end 
      end
  end*/
  
endmodule
        




