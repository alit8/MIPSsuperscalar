`timescale 1ns/100ps

module ROB(input CLK,
           input reset,
           input [1:0] InstrType,
           input [4:0] WriteReg,
           input       RSstall,
           input [1:0] idx,     
           
           input [31:0] InstrResult1,
           input [3:0]  InstrTag1,
           input        BranchTaken1,
           input [31:0] PCBranch1,
           
           input [31:0] InstrResult2,
           input [3:0]  InstrTag2,
           input        BranchTaken2,
           input [31:0] PCBranch2,
           
           input [31:0] InstrResult3,
           input [31:0] WriteData3,
           input [3:0]  InstrTag3,
           
           input [31:0] InstrResult4,
           input [3:0]  InstrTag4,
           
           input        out2enable,
           input        CacheReady,
           
           output reg      stall,
           output reg [3:0] ROBRFTag,
           output reg [4:0] ROBRFDst,
           output reg       ROBRFE,
           
           output reg [3:0] ROBRSTag,
           output reg [31:0] ROBRSResult,
           output reg     ROBRSModify,
           output reg      ROBFlush,
           output [3:0]     ROBhead,
           output reg         ROBPCSrc,
           output reg [31:0]  ROBPCBranch,
           
           output reg [3:0] ROBTag,
           output reg [31:0] ROBResult,
           output reg [4:0] ROBWriteReg,
           output reg      ROBRegWrite,
           
           output reg [3:0] ROBTag2,
           output reg [31:0] ROBResult2,
           output reg [4:0] ROBWriteReg2,
           output reg      ROBRegWrite2,
           
           output reg      ROBMWE,
           output reg [31:0] ROBMWA,
           output reg [31:0] ROBMWD,
           
           output reg [31:0] ROBMRA,
           output reg [3:0]  ROBMTag,
           output reg [4:0]  ROBMWriteReg,
           output reg        ROBMRegWrite,
           output reg        branchFlush,
           output reg        branchStall);

  parameter SIZE = 16;
  
  parameter [1:0] load = 2'd3;
  parameter [1:0] store = 2'd2;
  parameter [1:0] branch = 2'd1;
  parameter [1:0] arith = 2'd0;
  
  reg [SIZE-1:0] Done;
  reg [31:0]     Result [SIZE-1:0];
  reg [31:0]     D    [SIZE-1:0];
  reg [1:0]      Type   [SIZE-1:0];
  
  reg [3:0] head;
  reg [3:0] tail;
  
  wire [3:0] nextTail;
  
  assign ROBhead = head;
  assign nextTail = tail + 1;
  
  always @(*) begin
    if (reset) begin
      head = 4'd0;
      tail = 4'd0;
      ROBPCSrc = 0;
      ROBFlush = 0;
      branchFlush = 0;
    end
  end
  
  always @(RSstall) begin
    if (RSstall) tail = tail - 1;
  end
  
  always @(idx)
  begin
    
    stall = 0;
    
    if(head != nextTail & idx !== 2'dx)
    begin
      if(InstrType !== 2'dx) begin
        Done[tail] = 0;
        Result[tail] = 31'dx;
        D[tail] = {27'd0, WriteReg};
        Type[tail] = InstrType;
        
        stall = 0;
        
        ROBRFTag = tail;
        ROBRFDst = WriteReg;
        if(InstrType == load | InstrType == arith) 
          ROBRFE = 1;
      	 else
      	   ROBRFE = 0;
        
        tail = tail + 1;
      end
    end
    else
    begin
      stall = 1;
      
      ROBRFTag = 4'dx;
      ROBRFDst = 5'dx;
      ROBRFE = 0;
    end
  end
 
  always @(InstrTag1) begin
    #8.1;
    if (InstrTag1 !== 4'dx) begin
     case (Type[InstrTag1])
       arith:
       begin
         Done[InstrTag1] = 1;
         Result[InstrTag1] = InstrResult1;
         
         ROBRSTag = InstrTag1;
         ROBRSResult = InstrResult1;
         ROBRSModify = 1;
       end
       
       branch:
       begin
         Done[InstrTag1] = 1;
         Result[InstrTag1] = BranchTaken1;
         D[InstrTag1] = PCBranch1;
         
         ROBRSTag = InstrTag1;
         ROBRSResult = InstrResult1;
         ROBRSModify = 0;
       end
     endcase
   end
  end 
   
  always @(InstrTag2) begin
   #8.1; 
   if (InstrTag2 !== 4'dx) begin
     case (Type[InstrTag2])
       arith:
       begin
         Done[InstrTag2] = 1;
         Result[InstrTag2] = InstrResult2;
         #0.5;
         ROBRSTag = InstrTag2;
         ROBRSResult = InstrResult2;
         ROBRSModify = 1;
       end
       
       branch:
       begin
         Done[InstrTag2] = 1;
         Result[InstrTag2] = BranchTaken2;
         D[InstrTag2] = PCBranch2;
         #0.5;
         ROBRSTag = InstrTag2;
         ROBRSResult = InstrResult2;
         ROBRSModify = 0;
       end
     endcase
   end
 end
 
 always @(InstrTag3) begin
   #8.1;
   if (InstrTag3 !== 4'dx) begin
         Done[InstrTag3] = 1;
         Result[InstrTag3] = InstrResult3;
         D[InstrTag3] = WriteData3;
         #1;
         ROBRSTag = InstrTag3;
         ROBRSResult = InstrResult3;
         ROBRSModify = 0;
    end
  end
  
  always @(InstrTag4) begin
    #8.1;
    if (InstrTag4 !== 4'dx) begin
         Done[InstrTag4] = 1;
         Result[InstrTag4] = InstrResult4;
         #1.5;
         ROBRSTag = InstrTag4;
         ROBRSResult = InstrResult4;
         ROBRSModify = 0;
    end
  end
  
  always @(ROBFlush) begin
    if (ROBFlush) branchFlush = 1;
  end  
  
  always @(posedge CLK) begin
      branchStall = 0;
    if (branchFlush) begin
      branchFlush = 0;
    end
    
    if (ROBFlush) ROBFlush = 0;
  end  
 
 reg [1:0] arithOut; 
 reg storeOut, loadOut, branchOut;
 
 always @(posedge CLK) begin
   arithOut <= 2'd0;
   storeOut <= 0;
   loadOut <= 0;
   branchOut <= 0;
   ROBPCSrc <= 0;
   stall <= 0;
 end
 
 always @(Done[head] or posedge CLK or head or tail or CacheReady)
 begin
   #0.1;
   if ((Done[head] & (head !== tail)) & CacheReady) begin
     if ((Type[head] == arith) & (arithOut == 2'd0))
       begin
         Done[head] = 1'b0;
         ROBTag = head;
         ROBResult = Result[head];
         ROBWriteReg = D[head][4:0];
         ROBRegWrite = 1;
         
         ROBFlush = 0;
         ROBPCSrc = 0;
         
         arithOut = arithOut + 1;
         head = head + 1;
       end
    else if (((Type[head] == arith) & (arithOut == 2'd1)) & out2enable)
       begin
         Done[head] = 1'b0;
         ROBTag2 = head;
         ROBResult2 = Result[head];
         ROBWriteReg2 = D[head][4:0];
         ROBRegWrite2 = 1;
         
         ROBFlush = 0;
         ROBPCSrc = 0;
         
         arithOut = arithOut + 1;
         head = head + 1;
       end
    else if ((Type[head] == branch) & (!branchOut))
       begin
         Done[head] = 1'b0;
         ROBPCSrc = Result[head][0];
         ROBPCBranch = D[head];
     
         branchOut = 1;
         head = head + 1;
         if (ROBPCSrc) begin
          tail = head;
          ROBFlush = 1;
         end
         else
          ROBFlush = 0;
          
       end
       
    else if ((Type[head] == store) & (!storeOut) & CacheReady)
       begin
         Done[head] = 1'b0;
         ROBMWE = 1;
         ROBMWA = Result[head];
         ROBMWD = D[head];
         
         ROBFlush = 0;
         ROBPCSrc = 0;
         
         storeOut = 1;
         head = head + 1;
       end
       
    else if ((Type[head] == load) & (!loadOut) & (!storeOut) & CacheReady)
       begin
         Done[head] = 1'b0;
         ROBMRA = Result[head];
         ROBMTag = head;
         ROBMWriteReg = D[head][4:0];
         ROBMRegWrite = 1;
         
         ROBFlush = 0;
         ROBPCSrc = 0;
         
         loadOut = 1;
         head = head + 1;
       end
     
   end
 end 
 
 always @(loadOut) begin
    if (!loadOut) begin
      ROBMTag = 4'dx;
      ROBMRegWrite = 0;
    end
 end
 
 always @(storeOut) begin
    if (!storeOut) begin
      ROBMWE = 0;
    end
 end
 
 always @(arithOut) begin
    if (arithOut == 2'd0) begin
      ROBRegWrite = 0;
      ROBRegWrite2 = 0;
    end
    else if (arithOut == 2'd1) begin
      ROBRegWrite2 = 0;
    end
 end 
 
           
                   
endmodule
