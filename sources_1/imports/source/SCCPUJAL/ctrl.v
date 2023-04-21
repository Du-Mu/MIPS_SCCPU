// `include "ctrl_encode_def.v"


module ctrl(Op, Funct, Zero, 
            RegWrite, MemWrite,
            EXTOp, ALUOp, NPCOp, 
            ALUSrc, GPRSel, WDSel,
            LAddr
            );
            
   input  [5:0] Op;       // opcode
   input  [5:0] Funct;    // funct
   input        Zero;
   
   output       RegWrite; // control signal for register write
   output [1:0] MemWrite; // control signal for memory write
   output       EXTOp;    // control signal to signed extension
   output [3:0] ALUOp;    // ALU opertion
   output [1:0] NPCOp;    // next pc operation
   output       ALUSrc;   // ALU source for A

   output [1:0] GPRSel;   // general purpose register selection
   output [1:0] WDSel;    // (register) write data selection

   output [2:0] LAddr; 
   
  // r format
   wire rtype  = ~|Op;
   wire i_add  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]&~Funct[0]; // add
   wire i_sub  = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // sub
   wire i_and  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0]; // and
   wire i_or   = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]& Funct[0]; // or
   wire i_slt  = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]&~Funct[0]; // slt
   wire i_sltu = rtype& Funct[5]&~Funct[4]& Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // sltu
   wire i_addu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]&~Funct[1]& Funct[0]; // addu
   wire i_subu = rtype& Funct[5]&~Funct[4]&~Funct[3]&~Funct[2]& Funct[1]& Funct[0]; // subu

   wire i_sllv = rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]&~Funct[1]&~Funct[0]; // sllv
   wire i_srlv = rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]&~Funct[0]; // srlv
   wire i_nor  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]& Funct[0]; // nor
   wire i_xor  = rtype& Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]&~Funct[0];
   wire i_srav = rtype&~Funct[5]&~Funct[4]&~Funct[3]& Funct[2]& Funct[1]& Funct[0]; //000111

  // i format
   wire i_addi = ~Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]&~Op[0]; // addi
   wire i_ori  = ~Op[5]&~Op[4]& Op[3]& Op[2]&~Op[1]& Op[0]; // ori
   wire i_lw   =  Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0]; // lw
   wire i_sw   =  Op[5]&~Op[4]& Op[3]&~Op[2]& Op[1]& Op[0]; // sw
   wire i_beq  = ~Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]&~Op[0]; // beq
   /*added by nemo*/
   wire i_lb     =  Op[5]&~Op[4]&~Op[3]&~Op[2]&~Op[1]&~Op[0]; // 100000
   wire i_lh     =  Op[5]&~Op[4]&~Op[3]&~Op[2]&~Op[1]& Op[0]; // 100001
   wire i_lbu    =  Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]&~Op[0]; // 100100
   wire i_lhu    =  Op[5]&~Op[4]&~Op[3]& Op[2]&~Op[1]& Op[0]; // 100101
   wire i_sb     =  Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]&~Op[0]; // 101000 
   wire i_sh     =  Op[5]&~Op[4]& Op[3]&~Op[2]&~Op[1]& Op[0]; // 101001


  // j format
   wire i_j    = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]&~Op[0];  // j
   wire i_jal  = ~Op[5]&~Op[4]&~Op[3]&~Op[2]& Op[1]& Op[0];  // jal

  // generate control signals
  assign RegWrite   = rtype | i_lw | i_addi | i_ori | i_jal | i_lb | i_lh | i_lbu | i_lhu; // register write
  

  // sw 1'b01
  // sb 1'b10
  // sh 1'b11
  assign MemWrite[0] = i_sw | i_sh;
  assign MemWrite[1] = i_sb | i_sh;                           
  // memory write
  
  assign ALUSrc     = i_lw | i_sw | i_addi | i_ori | i_lb | i_lh | i_lbu | i_lhu | i_sb | i_sh;   // ALU B is from instruction immediate
  assign EXTOp      = i_addi | i_lw | i_sw | i_lb | i_lh | i_lbu | i_lhu | i_sb | i_sh;           // signed extension

  // GPRSel_RD   2'b00
  // GPRSel_RT   2'b01
  // GPRSel_31   2'b10
  // select target rigister
  assign GPRSel[0] = i_lw | i_addi | i_ori | i_lb | i_lh | i_lbu | i_lhu;
  assign GPRSel[1] = i_jal;
  
  // WDSel_FromALU 2'b00
  // WDSel_FromMEM 2'b01
  // WDSel_FromPC  2'b10 
  assign WDSel[0] = i_lw | i_lb | i_lh | i_lbu | i_lhu;
  assign WDSel[1] = i_jal;

  // NPC_PLUS4   2'b00
  // NPC_BRANCH  2'b01
  // NPC_JUMP    2'b10
  assign NPCOp[0] = (i_beq & Zero) | (i_bne & ~Zero);
  assign NPCOp[1] = i_j | i_jal;
  
  // ALU_NOP   3'b000
  // ALU_ADD   3'b001
  // ALU_SUB   3'b010
  // ALU_AND   3'b011
  // ALU_OR    3'b100
  // ALU_SLT   3'b101
  // ALU_SLTU  3'b110
  // nor       4'b1000
  // xor       4'b1001
  // srlv      4'b1010
  // sllv      4'b1011
  // srav      4'b1100
  assign ALUOp[0] = i_add | i_lw | i_sw | i_addi | i_and | i_slt | i_addu | i_lb | i_lh | i_lbu | i_lhu | i_sb | i_sh | i_xor | i_sllv;
  assign ALUOp[1] = i_sub | i_beq | i_and | i_sltu | i_subu | i_bne | i_srlv | sllv;
  assign ALUOp[2] = i_or | i_ori | i_slt | i_sltu | srav;
  assign ALUOp[3] = i_nor | i_xor | i_srlv | i_sllv | i_srav;

  // lw    3'b000
  // lb    3'b001
  // lbu   3'b010
  // lh    3'b011
  // lhu   3'b100
  assign LAddr[0] = i_lb | i_lbu;
  assign LAddr[1] = i_lbu | i_lh;
  assign LAddr[2] = i_lhu

endmodule
