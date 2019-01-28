module cache(input             clk,
             input             reset, 
             input             we,
             input      [31:0] a, 
             input      [31:0] wd,
             input             read,
             output reg [31:0] rd,
             output reg        ready);

  parameter C = 16;
  parameter b = 8;
  parameter nb = 3;
  parameter B = C/b;
  parameter N = 1;
  parameter S = B/N;
  parameter nS = 1;

  reg [29-nb-nS:0] CacheTag  [S-1:0];
	reg [N*b*32-1:0] CacheData [S-1:0];
	reg [S-1:0]      V; 
	reg [S-1:0]      D;
	
	wire [29-nb-nS:0] tag;
	wire [nS-1:0]     index;
	wire [nb-1:0]     blockOffset;
  
  assign tag = a[31:nb+nS+2];
  assign index = a[nb+nS+1:nb+2];
  assign blockOffset = a[nb+1:2];
 
  wire [b*32-1:0] dmemRD;
  reg             dmemWE;
  reg  [31:0]     dmemAddr;
  reg  [b*32-1:0] dmemWD;
  
  wire hit;
  assign hit = (CacheTag[index] == tag) & V[index];
  
  wire dirty;
  assign dirty = D[index];
  
  reg [1:0] counter;
  
  reg [1:0] state;
  reg [1:0] nextState;
	  
	parameter [1:0] normal = 2'd0;
	parameter [1:0] missWriteBack = 2'd1;
	parameter [1:0] missReadFromMem = 2'd2;
  
  always @(*)
  begin
   
  ready = 0;
  
    case (state)
      normal:
        begin
          if (reset)
            begin
              nextState = normal;
              
              dmemAddr = 32'dx;
              dmemWE = 0;
              
              V = 0;
              D = 0;
              
              rd = 32'dx;
              ready = 1;
            end
          else if (read)
            begin
              if (hit)
                begin
                  nextState = normal;

                  dmemAddr = 32'dx;
                  dmemWE = 0;
                  
                  rd = CacheData[index][blockOffset*32 +: 32];
                  ready = 1;
                end
              else
                begin
                  if (dirty)
                    begin
                      nextState = missWriteBack;
                      
                      dmemAddr = {CacheTag[index], a[nb+nS+1:0]};
                      dmemWE = 1;
                      dmemWD = CacheData[index];
                      
                      rd = 32'dx;
                      ready = 0;
                    end
                  else
                    begin
                      nextState = missReadFromMem;
                      
                      dmemAddr = a;
                      dmemWE = 0;
                      
                      rd = 32'dx;
                      ready = 0;
                    end
              end  
            end
          else if (we)
            begin
              if (hit)
                begin
                  nextState = normal;
                  
                  dmemAddr = 32'dx;
                  dmemWE = 0;
                  
                  CacheData[index][blockOffset*32 +: 32] = wd;
                  V[index] = 1;
                  D[index] = 1; 
                  
                  rd = 32'dx;
                  ready = 1;
                end
              else
                begin
                  if (dirty)
                    begin
                      nextState = missWriteBack;
                      
                      dmemAddr = {CacheTag[index], a[nb+nS+1:0]};
                      dmemWE = 1;
                      dmemWD = CacheData[index];
                      
                      rd = 32'dx;
                      ready = 0;
                    end
                  else
                    begin
                      nextState = missReadFromMem;
                      
                      dmemAddr = a;
                      dmemWE = 0;
                      
                      rd = 32'dx;
                      ready = 0;
                    end
                end 
            end
          else 
            begin
              nextState = normal;
              
              dmemAddr = 32'dx;
              dmemWE = 0;
              
              rd = 32'dx;
              ready = 1;
            end
        end
       
      missWriteBack:
        begin
          nextState = missReadFromMem;
          
          dmemAddr = a;
          dmemWE = 0;
          
          rd = 32'dx;
          ready = 0;
        end
        
      missReadFromMem:
        begin
          if (counter == 2)
            begin
              nextState = normal;
              
              dmemAddr = 32'dx;
              dmemWE = 0;
              
              CacheData[index] = dmemRD;
              CacheTag[index] = tag;
              V[index] = 1;
              D[index] = 0;
              
              rd = 32'dx;  
              ready = 0;
            end
          else
            begin
              nextState = missReadFromMem;
              
              dmemAddr = a;
              dmemWE = 0;
              
              rd = 32'dx;
              ready = 0;
            end
        end
        
      default: nextState = 2'dx;
    endcase
    
  end
  
  always @(posedge clk)
	  begin
		  if (reset) 
		    state <= 0;
		  else 
		    state <= nextState;
	  end
  
  always @(posedge clk)
	  begin
		  if (reset | (nextState != missReadFromMem)) 
		    counter <= 0;
		  else 
		  begin
			  if (counter == 2'd3)
				  counter <= 0;
			  else 
			    counter <= counter + 1;
		  end
	  end  
      
  
  dmem #(b) dm1(clk, dmemWE, dmemAddr, dmemWD, dmemRD);
  
endmodule
