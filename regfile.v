module regfile(input         CLK,
               input        reset,
               input  [4:0] A11,
               input  [4:0] A21,
               input  [4:0] A12, 
               input  [4:0] A22,
               input  [4:0] A13,
               input  [4:0] A23,
               input  [4:0] A14,
               input  [4:0] A24, 
               input         WE1, 
               input         WE2, 
               input  [4:0]  WA1, 
               input  [4:0]  WA2,
               input  [31:0] WD1, 
               input  [31:0] WD2,
               input  [3:0]  WT1,
               input  [3:0]  WT2,
               input  [3:0]  ROBTag,
               input  [4:0]  ROBDst,
               input         ROBE,
               input         flush, 
               output reg [31:0] RD11, 
               output reg [31:0] RD21, 
               output reg [31:0] RD12, 
               output reg [31:0] RD22, 
               output reg [31:0] RD13, 
               output reg [31:0] RD23, 
               output reg [31:0] RD14, 
               output reg [31:0] RD24,
               output reg        V11,
               output reg        V21,
               output reg        V12,
               output reg        V22,
               output reg        V13,
               output reg        V23,
               output reg        V14,
               output reg        V24);

  reg [31:0] RF    [31:0];
  reg [31:0] RFv; //valid
  reg [3:0]  RFTag [31:0];
  
  always @(*) begin
    if (reset) begin
      RFv = 32'hffffffff;
    end
  end

  always @(posedge CLK) begin
      if ((WA1 == WA2) & WE1 & WE2) begin
        RF[WA1] = WD1;  
        if (RFTag[WA1] == WT1) RFv[WA1] = 1;
        RF[WA2] = WD2;  
        if (RFTag[WA2] == WT2) RFv[WA2] = 1; 
      end
      else
      begin     
       if (WE1) begin
         RF[WA1] <= WD1;  
         if (RFTag[WA1] == WT1) RFv[WA1] = 1;
       end
      
       if (WE2) begin
         RF[WA2] <= WD2;  
         if (RFTag[WA2] == WT2) RFv[WA2] = 1;
       end
      end
      
      RF[0] <= 32'd0;
      RFv[0] <= 1;
  end
  
  always @(flush) begin
    if (flush) RFv = 32'hffffffff;
  end
    
  always @(*) begin
    if (ROBE) begin
      RFTag[ROBDst] <= ROBTag;
      RFv[ROBDst] <= 0;
    end
  end
  
  always @(*) begin
    if (RFv[A11]) begin
      RD11 <= RF[A11];
      V11 <= 1;
    end else begin
      RD11 <= {{28'd0}, RFTag[A11]};
      V11 <= 0;
    end
  
    if (RFv[A21]) begin
      RD21 <= RF[A21];
      V21 <= 1;
    end else begin
      RD21 <= {{28'd0}, RFTag[A21]};
      V21 <= 0;
    end
  end
  
  always @(*) begin
    if (RFv[A12]) begin
      RD12 <= RF[A12];
      V12 <= 1;
    end else begin
      RD12 <= {{28'd0}, RFTag[A12]};
      V12 <= 0;
    end
  
    if (RFv[A22]) begin
      RD22 <= RF[A22];
      V22 <= 1;
    end else begin
      RD22 <= {{28'd0}, RFTag[A22]};
      V22 <= 0;
    end
  end
  
  always @(*) begin
    if (RFv[A13]) begin
      RD13 <= RF[A13];
      V13 <= 1;
    end else begin
      RD13 <= {{28'd0}, RFTag[A13]};
      V13 <= 0;
    end
  
    if (RFv[A23]) begin
      RD23 <= RF[A23];
      V23 <= 1;
    end else begin
      RD23 <= {{28'd0}, RFTag[A23]};
      V23 <= 0;
    end
  end
  
  always @(*) begin
    if (RFv[A14]) begin
      RD14 <= RF[A14];
      V14 <= 1;
    end else begin
      RD14 <= {{28'd0}, RFTag[A14]};
      V14 <= 0;
    end
  
    if (RFv[A24]) begin
      RD24 <= RF[A24];
      V24 <= 1;
    end else begin
      RD24 <= {{28'd0}, RFTag[A24]};
      V24 <= 0;
    end
  end
  
endmodule
