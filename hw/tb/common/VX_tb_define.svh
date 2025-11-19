`ifndef VX_TB_DEFINE_VH
`define VX_TB_DEFINE_VH

`define VX_info(ID, message)    `uvm_info(ID, message, UVM_NONE)
`define VX_warning(ID, message) `uvm_warning(ID, message)
`define VX_error(ID, message)   `uvm_error(ID, message)
`define VX_fatal(ID, message)   `uvm_fatal(ID, message)

`define REG_HEX(x) `REG_NUM_WIDTH'h``x
`define REG_DEC(x) `REG_NUM_WIDTH'd``x
`define IMM_HEX(x)     `IMM_WIDTH'h``x

`define RS1(x) `REG_HEX(x)
`define RS2(x) `REG_HEX(x)
`define RS3(x) `REG_HEX(x)
`define RD(x)  `REG_HEX(x)
`define FUNCT3_BIN(x) `FUNCT3_WIDTH'b``x
`define FUNCT7_BIN(x) `FUNCT3_WIDTH'b``x

//U_type Instructions
`define LUI(imm,rd)      VX_risc_v_Utype_seq_item::create_instruction_with_fields(imm, rd, INST_LUI)
`define AUIPC(imm,rd)    VX_risc_v_Utype_seq_item::create_instruction_with_fields(imm, rd, INST_AUIPC)
`define JAL(imm,rd)      VX_risc_v_Jtype_seq_item::create_instruction_with_fields(imm, rd, INST_JAL)
`define JALR(rs1,imm,rd) VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, INST_JALR)

//B_TYPE (Branch) Instructions
`define BEQ(rs1,rs2,imm)  VX_risc_v_Btype_seq_item::create_instruction_with_fields(imm, rs2, rs1, `FUNCT3_WIDTH'b000)
`define BNE(rs1,rs2,imm)  VX_risc_v_Btype_seq_item::create_instruction_with_fields(imm, rs2, rs1, `FUNCT3_WIDTH'b001)
`define BLT(rs1,rs2,imm)  VX_risc_v_Btype_seq_item::create_instruction_with_fields(imm, rs2, rs1, `FUNCT3_WIDTH'b100)
`define BGE(rs1,rs2,imm)  VX_risc_v_Btype_seq_item::create_instruction_with_fields(imm, rs2, rs1, `FUNCT3_WIDTH'b101)
`define BLTU(rs1,rs2,imm) VX_risc_v_Btype_seq_item::create_instruction_with_fields(imm, rs2, rs1, `FUNCT3_WIDTH'b110)
`define BGEU(rs1,rs2,imm) VX_risc_v_Btype_seq_item::create_instruction_with_fields(imm, rs2, rs1, `FUNCT3_WIDTH'b110)

//L_TYPE (Load) Instructions
`define LB(rs1,imm,rd)  VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b000,INST_L)
`define LH(rs1,imm,rd)  VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b001,INST_L)
`define LW(rs1,imm,rd)  VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b010,INST_L)
`define LBU(rs1,imm,rd) VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b100,INST_L)
`define LHU(rs1,imm,rd) VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b101,INST_L)

//S_TYPE (Store) Instructions
`define SB(rs1,rs2,imm) VX_risc_v_Stype_seq_item::create_instruction_with_fields(imm, rs2, rs1, `FUNCT3_WIDTH'b000,INST_S)
`define SH(rs1,rs2,imm) VX_risc_v_Stype_seq_item::create_instruction_with_fields(imm, rs2, rs1, `FUNCT3_WIDTH'b001,INST_S)
`define SW(rs1,rs2,imm) VX_risc_v_Stype_seq_item::create_instruction_with_fields(imm, rs2, rs1, `FUNCT3_WIDTH'b010,INST_S)

//I_TYPE (Immediate) Instructions
`define ADDI(rs1,imm,rd)   VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b000,INST_I)
`define SLTI(rs1,imm,rd)   VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b010,INST_I)
`define SLTIU(rs1,imm,rd)  VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b011,INST_I)
`define XORI(rs1,imm,rd)   VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b100,INST_I)
`define ORI(rs1,imm,rd)    VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b110,INST_I)
`define ANDI(rs1,imm,rd)   VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b111,INST_I)
`define SLLI(rs1,shamt,rd) VX_risc_v_Itype_seq_item::create_instruction_with_fields({7'b0000000,shamt}, rd, rs1, `FUNCT3_WIDTH'b001, INST_I)
`define SRLI(rs1,shamt,rd) VX_risc_v_Itype_seq_item::create_instruction_with_fields({7'b0000000,shamt}, rd, rs1, `FUNCT3_WIDTH'b101, INST_I)
`define SRAI(rs1,shamt,rd) VX_risc_v_Itype_seq_item::create_instruction_with_fields({7'b0100000,shamt}, rd, rs1, `FUNCT3_WIDTH'b101, INST_I)

//R_TYPE (Register) Instructios 
`define ADD(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1, `FUNCT3_WIDTH'b000, INST_R)
`define SUB(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0100000, rd, rs2, rs1, `FUNCT3_WIDTH'b000, INST_R)
`define SLL(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1, `FUNCT3_WIDTH'b001, INST_R)
`define SLT(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1, `FUNCT3_WIDTH'b010, INST_R)
`define SLTU(rs1,rs2,rd)    VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1, `FUNCT3_WIDTH'b011, INST_R)
`define XOR(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1, `FUNCT3_WIDTH'b100, INST_R)
`define SRL(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1, `FUNCT3_WIDTH'b101, INST_R)
`define SRA(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0100000, rd, rs2, rs1, `FUNCT3_WIDTH'b101, INST_R)
`define OR (rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1, `FUNCT3_WIDTH'b110, INST_R)
`define AND(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1, `FUNCT3_WIDTH'b111, INST_R)
`define MUL(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000001, rd, rs2, rs1, `FUNCT3_WIDTH'b000, INST_R)
`define MULH(rs1,rs2,rd)    VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000001, rd, rs2, rs1, `FUNCT3_WIDTH'b001, INST_R)
`define MULHSU(rs1,rs2,rd)  VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000001, rd, rs2, rs1, `FUNCT3_WIDTH'b010, INST_R)
`define MULHU(rs1,rs2,rd)   VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000001, rd, rs2, rs1, `FUNCT3_WIDTH'b011, INST_R)
`define DIV(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000001, rd, rs2, rs1, `FUNCT3_WIDTH'b100, INST_R)
`define DIVU(rs1,rs2,rd)    VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000001, rd, rs2, rs1, `FUNCT3_WIDTH'b101, INST_R)
`define REM(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000001, rd, rs2, rs1, `FUNCT3_WIDTH'b110, INST_R)
`define REMU(rs1,rs2,rd)    VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000001, rd, rs2, rs1, `FUNCT3_WIDTH'b111, INST_R)

//Mem-Ordering Instructions 
`define FENCE(rs1, rd, fm, pred, succ) VX_risc_v_Ftype_seq_item::create_instruction_with_fields(fm, succ, pred, rd, rs1, `FUNCT3_WIDTH'b000)
`define FENCE_TSO                      VX_risc_v_Ftype_seq_item::create_instruction_with_fields(4'b1000 4'b0011,4'b0011, `REG_NUM_WIDTH'b00000,`REG_NUM_WIDTH'b00000, `FUNCT3_WIDTH'b000)
`define FENCE_I(rs1, imm, rd)          VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, 3'b001, INST_SYS) 
`define PAUSE(rs1, rd, fm, pred, succ) VX_risc_v_Ftype_seq_item::create_instruction_with_fields(4'b0000, 4'b0000, 4'b0001,`REG_NUM_WIDTH'b00000, `REG_NUM_WIDTH'b00000, `FUNCT3_WIDTH'b000)

//System Instructions
`define ECALL  VX_risc_v_Stype_seq_item::create_instruction_with_fields(32'b0, `REG_NUM_WIDTH'b00000, `REG_NUM_WIDTH'b00000, `FUNCT3_WIDTH'b000, INST_SYS) 
`define EBREAK VX_risc_v_Stype_seq_item::create_instruction_with_fields(32'b1, `REG_NUM_WIDTH'b00000, `REG_NUM_WIDTH'b00000, `FUNCT3_WIDTH'b000, INST_SYS) 

//CSR instructions, also system instruction 
`define CSRRW(rs1,rd,csr)   VX_risc_v_Rtype_seq_item::create_instruction_with_fields(csr, rd, rs1, `FUNCT3_WIDTH'b001, INST_SYS)
`define CSRRS(rs1,rd,csr)   VX_risc_v_Rtype_seq_item::create_instruction_with_fields(csr, rd, rs1, `FUNCT3_WIDTH'b010, INST_SYS)
`define CSRRC(rs1,rd,csr)   VX_risc_v_Rtype_seq_item::create_instruction_with_fields(csr, rd, rs1, `FUNCT3_WIDTH'b011, INST_SYS)
`define CSRRWI(uimm,rd,csr) VX_risc_v_Rtype_seq_item::create_instruction_with_fields(csr, rd, uimm, `FUNCT3_WIDTH'b101, INST_SYS)
`define CSRRSI(uimm,rd,csr) VX_risc_v_Rtype_seq_item::create_instruction_with_fields(csr, rd, uimm, `FUNCT3_WIDTH'b110), INST_SYS
`define CSRRCI(uimm,rd,csr) VX_risc_v_Rtype_seq_item::create_instruction_with_fields(csr, rd, uimm, `FUNCT3_WIDTH'b111, INST_SYS)

`define FLW(rs1,imm,rd)  VX_risc_v_Itype_seq_item::create_instruction_with_fields(imm, rd, rs1, `FUNCT3_WIDTH'b010, INST_FL)
`define FSW(rs1,rs2,imm) VX_risc_v_Stype_seq_item::create_instruction_with_fields(imm, rs2, rs1, `FUNCT3_WIDTH'b010,INST_FS)

`define FMADD(rs1,rs2,rs3,rd,rm)  VX_risc_v_R4type_seq_item::create_instruction_with_fields(rm,rd,rs3,rs2,rs1,INST_FMADD)
`define FNMADD(rs1,rs2,rs3,rd,rm) VX_risc_v_R4type_seq_item::create_instruction_with_fields(rm,rd,rs3,rs2,rs1,INST_FNMADD)
`define FMSUB(rs1,rs2,rs3,rd,rm)  VX_risc_v_R4type_seq_item::create_instruction_with_fields(rm,rd,rs3,rs2,rs1,INST_FMSUB)
`define FNMSUB(rs1,rs2,rs3,rd,rm) VX_risc_v_R4type_seq_item::create_instruction_with_fields(rm,rd,rs3,rs2,rs1,INST_FNMSUB)

//Floating Point Common (Single Precision) 
`define FADD(rs1,rs2,rd, rm) VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1, rm, INST_FCI)
`define FSUB(rs1,rs2,rd, rm) VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000100, rd, rs2, rs1, rm, INST_FCI)
`define FMUL(rs1,rs2,rd, rm) VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0001000, rd, rs2, rs1, rm, INST_FCI)
`define FDIV(rs1,rs2,rd, rm) VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0001100, rd, rs2, rs1, rm, INST_FCI)
`define FSQRT(rs1,rd, rm)    VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0101100, rd, `REG_NUM_WIDTH'b00000, rs1,rm, INST_FCI)
`define FSGNJ(rs1,rs2,rd)    VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0010000, rd, rs2, rs1, `FUNCT3_WIDTH'b000, INST_FCI)
`define FSGNJN(rs1,rs2,rd)   VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0010000, rd, rs2, rs1, `FUNCT3_WIDTH'b001, INST_FCI)
`define FSGNJX(rs1,rs2,rd)   VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0010000, rd, rs2, rs1, `FUNCT3_WIDTH'b010, INST_FCI)
`define FMIN(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0010100, rd, rs2, rs1, `FUNCT3_WIDTH'b000, INST_FCI)
`define FMAX(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0010100, rd, rs2, rs1, `FUNCT3_WIDTH'b001, INST_FCI)
`define FCVT_W(rs1,rd,rm)    VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b1100000, rd, `REG_NUM_WIDTH'b00000, rs1, rm, INST_FCI)
`define FCVT_WU(rs1,rd,rm)   VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b1100000, rd, `REG_NUM_WIDTH'b00001, rs1, rm, INST_FCI)
`define FMV_X_W(rs1,rd,rm)   VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b1110000, rd, `REG_NUM_WIDTH'b00000, rs1, `FUNCT3_WIDTH'b000, INST_FCI)
`define FEQ(rs1,rs2,rd)      VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b1010000, rd, rs2, rs1, `FUNCT3_WIDTH'b010, INST_FCI)
`define FLT(rs1,rs2,rd)      VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b1010000, rd, rs2, rs1, `FUNCT3_WIDTH'b001, INST_FCI)
`define FLE(rs1,rs2,rd)      VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b1010000, rd, rs2, rs1, `FUNCT3_WIDTH'b000, INST_FCI)
`define FCLASS(rs1,rd)       VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b1110000, rd, `REG_NUM_WIDTH'b00000, rs1, `FUNCT3_WIDTH'b001, INST_FCI)
`define FCVT_S_W(rs1,rd,rm)  VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b1101000, rd, `REG_NUM_WIDTH'b00000, rs1, rm, INST_FCI)
`define FCVT_S_WU(rs1,rd,rm) VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b1101000, rd, `REG_NUM_WIDTH'b00001, rs1, rm, INST_FCI)
`define FMV_W_X(rs1,rd,rm)   VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b1111000, rd, `REG_NUM_WIDTH'b00000, rs1,`FUNCT3_WIDTH'b000, INST_FCI)

//Vortex Custom Insts OPCODE= INST_EXT1 (TMC, WSPAWN, SPLIT,JOIN, BAR,PRED ) 
`define TMC(rs1)             VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, `REG_NUM_WIDTH'b000000, `REG_NUM_WIDTH'b000000, rs1,`FUNCT3_WIDTH'b000, INST_EXT1)
`define WSPAWN(rs1,rs2)      VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, `REG_NUM_WIDTH'b000000, rs2, rs1, `FUNCT3_WIDTH'b001, INST_EXT1)


`define SPLIT(rs1,rs2,rd)    VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1, `FUNCT3_WIDTH'b010, INST_EXT1)


`define JOIN(rs1)            VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, `REG_NUM_WIDTH'b00000, `REG_NUM_WIDTH'b000000,rs1, `FUNCT3_WIDTH'b011, INST_EXT1)
`define BAR(rs1,rs2)         VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1, `FUNCT3_WIDTH'b100, INST_EXT1)
`define PRED(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000000, rd, rs2, rs1,`FUNCT3_WIDTH'b101, INST_EXT1)
`define VOTE(rs1,rs2,rd)     VX_risc_v_Rtype_seq_item::create_instruction_with_fields(`FUNCT7_WIDTH'b0000001, rd, rs2, rs1, `FUNCT3_WIDTH'b100, INST_EXT1)

`define VEC(vs2,vm,vd)       VX_risc_v_Vtype_seq_item::create_instruction_with_fields(vd, vm, vs2)

`endif // VX_TB_DEFINE_VH



