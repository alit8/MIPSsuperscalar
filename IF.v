module IF(input         CLK,
          input         reset,
          input         stall,
          input         PCSrc,
          input  [31:0] PCBranch,
          input  [2:0]  PCPlusSrc,
          output [31:0] InstrF1,
          output [31:0] InstrF2,
          output [31:0] InstrF3,
          output [31:0] InstrF4,
          output [31:0] PCPlus4F1,
          output [31:0] PCPlus4F2,
          output [31:0] PCPlus4F3,
          output [31:0] PCPlus4F4);
          
  wire [31:0] PC_;
  reg  [31:0] PCF;
  reg [31:0] IMA;
  reg [31:0] PCPlus;
  
  wire [31:0] PCPlus4F;
  wire [31:0] PCPlus8F;
  wire [31:0] PCPlus12F;
  wire [31:0] PCPlus16F;
  
  wire [31:0] PCMinus4F;
  wire [31:0] PCMinus8F;
  wire [31:0] PCMinus12F;
  wire [31:0] PCMinus16F;
  
  always @(*) begin
    case (PCPlusSrc)
      3'd0: 
      begin
        PCPlus = PCPlus16F;
        IMA = PCF;
      end
      
      3'd1: 
      begin
        PCPlus = PCF;
        IMA = PCMinus16F;
      end
      
      3'd2: 
      begin
        PCPlus = PCPlus4F;
        IMA = PCMinus12F;
      end
      
      3'd3: 
      begin
        PCPlus = PCPlus8F;
        IMA = PCMinus8F;
      end
      
      3'd4: 
      begin
        PCPlus = PCPlus12F;
        IMA = PCMinus4F;
      end
    endcase
  end
  
  assign PC_ = PCSrc ? PCBranch : PCPlus;
  
  assign PCPlus4F = PCF + 32'd4;
  assign PCPlus8F = PCF + 32'd8;
  assign PCPlus12F = PCF + 32'd12;
  assign PCPlus16F = PCF + 32'd16;
  
  assign PCMinus4F = PCF - 32'd4;
  assign PCMinus8F = PCF - 32'd8;
  assign PCMinus12F = PCF - 32'd12;
  assign PCMinus16F = PCF - 32'd16;
  
  assign PCPlus4F1 = IMA + 32'd4;
  assign PCPlus4F2 = IMA + 32'd8;
  assign PCPlus4F3 = IMA + 32'd12;
  assign PCPlus4F4 = IMA + 32'd16;

  always @(posedge CLK)
  begin
    if (reset)
      PCF <= 0;
    else if (stall)
      PCF <= PCF;
    else
      PCF <= PC_;
  end
  
  imem im1(.a(IMA), .rd1(InstrF1), .rd2(InstrF2), .rd3(InstrF3), .rd4(InstrF4));
  
endmodule          
