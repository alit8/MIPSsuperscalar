module RS1(CLK, reset, d1, dv1, d2, dv2, tag, writereg, alucontrol, regwrite, memtoreg, memwrite, alusrc, 
                branch, branchn, extimm, pcplus4, ROBRSTag, ROBRSResult, ROBRSModify, ROBFlush, ROBhead, RDM, RToM, 
                MRSModify, WT1, WD1, WE1, WT2, WD2, WE2, stall, do1, do2, writerego, extimmo, pcplus4o,
                alucontrolo, regwriteo, memtorego, memwriteo, alusrco, brancho, branchno, tago);
                
  parameter SIZE = 4;
  
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
  
  output reg [31:0] do1;
  output reg [31:0] do2;
  output reg [4:0]  writerego;
  output reg [31:0] extimmo;
  output reg [31:0] pcplus4o;
  output reg [3:0]  alucontrolo;
  output reg        regwriteo, memtorego, memwriteo, alusrco, brancho, branchno;
  output reg [3:0]  tago;
   
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
  
  
  reg [SIZE-1:0]  NoR;
  reg             NoI;
  reg             done;
  
  always @(*)
  begin
    if (reset) begin
      NoR = 'd0;
      R = 'd0;
      NoI = 0;
      stall = 0;
      done = 0;
    end
  end
  
  always @(posedge CLK) begin
    NoI <= 0;
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
        
        stall = 0;
        NoR = NoR + 1;
      end
    end
    
   
      for (j=0; (j<SIZE) & (!NoI) & (!ROBFlush); j=j+1) begin
        if (R[j] & (Dv1[j] & Dv2[j])) begin
           do1 = D1[j];
           do2 = D2[j];
           writerego = WriteReg[j];
           extimmo = ExtImm[j];
           pcplus4o = PCPlus4[j];
           alucontrolo = ALUControl[j];
           regwriteo = RegWrite[j];
           memtorego = MemtoReg[j];
           memwriteo = MemWrite[j];
           alusrco = ALUSrc[j];
           brancho = Branch[j];
           branchno = BranchN[j];
           tago = Tag[j];
           
           R[j] = 0;
           
           NoR = NoR - 1;
           NoI = NoI + 1;
        end
      end
    
    if (NoI == 0) begin
       do1 = 31'd0;
       do2 = 31'd0;
       writerego = 5'd0;
       extimmo = 31'd0;
       pcplus4o = 31'd0;
       alucontrolo = 4'd0;
       regwriteo = 0;
       memtorego = 0;
       memwriteo = 0;
       alusrco = 0;
       brancho = 0;
       branchno = 0;
       tago = 4'dx;
    end
    
  end
  
  always @(ROBRSTag or ROBRSResult or ROBRSModify) begin
    if (ROBRSModify & ROBRSTag !== 4'dx) begin  
      for (k = 0; k<SIZE; k=k+1) begin
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
  end
  
  always @(ROBFlush) begin
     if (ROBFlush) begin
        R = 'd0;
        NoR = 'd0;
        NoI = 0;
        
        do1 = 31'd0;
        do2 = 31'd0;
        writerego = 5'd0;
        extimmo = 31'd0;
        pcplus4o = 31'd0;
        alucontrolo = 4'd0;
        regwriteo = 0;
        memtorego = 0;
        memwriteo = 0;
	      alusrco = 0;
        brancho = 0;
        branchno = 0;
        tago = 4'dx;
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
  
  /* always @(RDM or RToM or MRSModify or NoR) begin
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
  end */
  
endmodule