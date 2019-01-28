
`timescale 1ns/1ns

module TB2;

   reg clk = 1;
   always @(clk)
      clk <= #5 ~clk;

   reg reset;
   initial begin
      reset = 1;
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1;
      reset = 0;
   end
   
   /* integer f;
   initial begin
      f = $fopen("output.txt","w");
    end */

   initial
      $readmemh("TB2.hex", ACA_MIPS.if1.im1.RAM);

   parameter end_pc = 32'h58;
   parameter end_pc_ = 32'h68;

   integer i;
   always @(ACA_MIPS.if1.PCF or ACA_MIPS.if1.PC_)
   begin
      if(ACA_MIPS.if1.PCF == end_pc & ACA_MIPS.if1.PC_ == end_pc_) begin
        
         for(i=0; i<1000; i=i+1) begin
            $write("%x ", ACA_MIPS.me1.c1.dm1.RAM[i]);
            if(((i+1) % 16) == 0)
               $write("\n");
         end
         
         $stop;
      end
   end
  
   Top_Ph4 ACA_MIPS(
      .CLK(clk),
      .reset(reset)
   );


endmodule



