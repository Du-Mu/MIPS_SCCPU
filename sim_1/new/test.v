`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/21 21:07:26
// Design Name: 
// Module Name: test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test();
reg          clk;
reg [15:0]     i_sw;
reg rst = 0;
wire [7:0] disp_seg_o, disp_an_o;
//============== (2) ==================
//clock generating
real         CYCLE_200MHz = 5 ; //
always begin
    clk = 0 ; #(CYCLE_200MHz/2) ;
    clk = 1 ; #(CYCLE_200MHz/2) ;
end
initial begin
i_sw = 16'd0;
end 

SCCPUSOC_Top cputest(.clk(clk),.rstn(rst),.sw_i(i_sw),.disp_seg_o(disp_seg_o), .disp_an_o(disp_an_o));

endmodule
