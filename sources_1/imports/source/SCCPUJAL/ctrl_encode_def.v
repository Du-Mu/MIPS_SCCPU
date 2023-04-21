// NPC control signal
`define NPC_PLUS4   2'b00
`define NPC_BRANCH  2'b01
`define NPC_JUMP    2'b10


// ALU control signal
`define ALU_NOP   3'b0000 
`define ALU_ADD   3'b0001
`define ALU_SUB   3'b0010 
`define ALU_AND   3'b0011
`define ALU_OR    3'b0100
`define ALU_SLT   3'b0101
`define ALU_SLTU  3'b0110
`define ALU_NOR   3'b1000
`define ALU_XOR   3'b1001
`define ALU_SRLV  3'b1010
`define ALU_SLLV  3'b1011
`define ALU_SRAV  3'b1100
  // nor       4'b1000
  // xor       4'b1001
  // srlv      4'b1010
  // sllv      4'b1011
  // srav      4'b1100