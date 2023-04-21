
  module RF(   input         clk, 
               input         rst,
               input         RFWr, 
               input  [4:0]  A1, A2, A3, 
               input  [31:0] WD, 
               output [31:0] RD1, RD2,
               input  [4:0]  reg_sel,
               output [31:0] reg_data
               input  [2:0] LAddr);

  reg [31:0] rf[31:0];

  integer i;

  always @(posedge clk, posedge rst)
    if (rst) begin    //  reset
      for (i=1; i<32; i=i+1)
        rf[i] <= 0; //  i;
    end
      
    else 
      if (RFWr) begin
        if (LAddr==3'b000) begin
            rf[A3] <= WD;
            $display("r[%2d] = 0x%8X,", A3, WD);
        end
        else if (LAddr==3'b001) begin
            rf[A3] <= WD[7]==0?{24'hffffff , WD[7:0]}:{24'h000000 , WD[7:0]};
            $display("r[%2d] = 0x%8X,", A3, WD[7]==0?{24'hffffff , WD[7:0]}:{24'h000000 , WD[7:0]});
        end
        else if (LAddr==3'b010) begin
                    rf[A3] <= {24'h000000 , WD[7:0]};
                    $display("r[%2d] = 0x%8X,", A3, {24'h000000 , WD[7:0]});
        end
        else if (LAddr==3'b011) begin
                    rf[A3] <= WD[15]==0?{16'hffff , WD[15:0]}:{16'h0000 , WD[15:0]};
                    $display("r[%2d] = 0x%8X,", A3,  WD[15]==0?{16'hffff , WD[15:0]}:{16'h0000 , WD[15:0]});
        end
        else if (LAddr==3'b100) begin
                    rf[A3] <= {16'h0000 , WD[15:0]};
                    $display("r[%2d] = 0x%8X,", A3, {16'h0000 , WD[15:0]});
        end
        else begin
                    rf[A3] <= WD;
                    $display("r[%2d] = 0x%8X,", A3, WD);
        end
      end
    

  assign RD1 = (A1 != 0) ? rf[A1] : 0;
  assign RD2 = (A2 != 0) ? rf[A2] : 0;
  assign reg_data = (reg_sel != 0) ? rf[reg_sel] : 0; 

endmodule 
