module CU(input [5:0] Op,
          input [5:0] Funct,
          output RegWrite,
          output MemtoReg,
          output MemWrite,
          output reg [3:0] ALUControl,
          output ALUSrc,
          output RegDst,
          output Branch,
          output BranchN,
          output SignExt);
          
  wire [2:0] ALUOp;
  reg [10:0] MainDecOut;
  
  assign {RegWrite, MemtoReg, MemWrite, ALUSrc, RegDst, Branch, BranchN, SignExt, ALUOp} = MainDecOut;
  
  always @(*)
    case(Op)
      6'b000000: MainDecOut <= 11'b10001000_010; // R-type
      6'b100011: MainDecOut <= 11'b11010001_000; // lw
      6'b101011: MainDecOut <= 11'b00110001_000; // sw
      6'b000100: MainDecOut <= 11'b00000101_011; // beq
      6'b000101: MainDecOut <= 11'b00000011_011; // bne
      6'b001000: MainDecOut <= 11'b10010001_000; // addi
      6'b001001: MainDecOut <= 11'b10010000_001; // addiu
      6'b001100: MainDecOut <= 11'b10010000_100; // andi
      6'b001101: MainDecOut <= 11'b10010000_101; // ori
      6'b001110: MainDecOut <= 11'b10010000_110; // xori
      default:   MainDecOut <= 11'bxxxxxxxx_xxx; // illegal op
   endcase
   
  always @(*)
    case(ALUOp)
      3'b000: ALUControl <= 4'b0000; // add (lw, sw, addi)
      3'b001: ALUControl <= 4'b0001; // addu (addiu) 
      3'b011: ALUControl <= 4'b0011; // subu (beq, bne)
      3'b100: ALUControl <= 4'b0100; // and (andi)
      3'b101: ALUControl <= 4'b0101; // or (ori)
      3'b110: ALUControl <= 4'b0110; // xor (xori)
      3'b010: case(Funct)
                6'b100000: ALUControl <= 4'b0000; // add
                6'b100001: ALUControl <= 4'b0001; // addu
                6'b100010: ALUControl <= 4'b0010; // sub
                6'b100011: ALUControl <= 4'b0011; // subu
                6'b100100: ALUControl <= 4'b0100; // and
                6'b100101: ALUControl <= 4'b0101; // or
                6'b100110: ALUControl <= 4'b0110; // xor
                6'b100111: ALUControl <= 4'b0111; // nor
                6'b101010: ALUControl <= 4'b1100; // slt
                6'b101011: ALUControl <= 4'b1101; // sltu
                default: ALUControl <= 4'bxxxx;
              endcase
      default: ALUControl <= 4'bxxxx;
    endcase
    
endmodule
