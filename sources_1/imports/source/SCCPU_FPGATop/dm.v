
// data memory
module dm(clk, DMWr, addr, din, dout);
   input          clk;
   input  [1:0]   DMWr;
   input  [8:2]   addr;
   input  [31:0]  din;
   output [31:0]  dout;
     
   reg [31:0] dmem[127:0];
   wire [31:0] addrByte;

   assign addrByte = addr<<2;
      
   assign dout = dmem[addrByte[8:2]];
   
   always @(posedge clk)
      if (DMWr==1'b01) begin
        dmem[addrByte[8:2]] <= din;
        $display("dmem[0x%8X] = 0x%8X,", addrByte, din); 
      end else if (DMWr==1'b10) begin
        dmem[addrByte[8:2]][7:0] <= din[7:0];
        $display("dmem[0x%8X] = 0x%8X,", addrByte, din);
      end else if (DMWr==1'b11) begin
        dmem[addrByte[8:2]][15:0] <= din[15:0];
        $display("dmem[0x%8X] = 0x%8X,", addrByte, din);
      end
   
endmodule    
