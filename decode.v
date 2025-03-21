module decode(
    input wire [63:0] regD_i_pc,
    input wire [31:0] regD_i_instr,

    output wire [63:0] decode_o_rs1_data,
    output wire [63:0] decode_o_rs2_data
);

wire [31:0]rv64I_instr 			= regD_i_instr;
wire [6:0] rv64I_opcode			= rv64I_instr[6:0]; 
wire [4:0] rv64I_rd     		= rv64I_instr[11:7];
wire [2:0] rv64I_func3  		= rv64I_instr[14:12];
wire [4:0] rv64I_rs1    		= rv64I_instr[19:15];
wire [4:0] rv64I_rs2    		= rv64I_instr[24:20];
wire [6:0] rv64I_func7  		= rv64I_instr[31:25];
wire [5:0] rv64I_I_special      = rv64I_instr[31:26];

//------------------------opcode&TYPE----------------------------------------------------------
wire rv64I_B_TYPE   = (rv64I_opcode == 7'b1100011);
wire rv64I_J_TYPE   = (rv64I_opcode == 7'b1101111);
wire rv64I_S_TYPE   = (rv64I_opcode == 7'b0100011);
wire rv64I_R_TYPE   = (opcode_R_NORMAL | opcode_R_W_INST);   
wire rv64I_U_TYPE 	= (opcode_U_lui | opcode_U_auipc);
wire rv64I_I_TYPE   = (opcode_I_Logic_Operator | opcode_I_LOAD | opcode_I_CSR | opcode_I_JALR | opcode_I_W_INST);

wire rv64I_I_Logic_Operator     =   opcode_I_Logic_Operator;
wire rv64I_I_LOAD				= 	opcode_I_LOAD;
wire rv64I_I_JALR               =   opcode_I_JALR;
wire rv64I_I_CSR				= 	opcode_I_CSR;
wire rv64I_I_W_INST				= 	opcode_I_W_INST;
wire rv64I_R_W_INST				= 	opcode_R_W_INST;

//judge type
wire opcode_U_lui    = (rv64I_opcode == 7'b0110111);
wire opcode_U_auipc  = (rv64I_opcode == 7'b0010111);

wire opcode_I_Logic_Operator 	= (rv64I_opcode == 7'b0010011);
wire opcode_I_LOAD  			= (rv64I_opcode == 7'b0000011);
wire opcode_I_CSR   			= (rv64I_opcode == 7'b1110011);
wire opcode_I_JALR  			= (rv64I_opcode == 7'b1100111);
wire opcode_I_W_INST            = (rv64I_opcode == 7'b0011011);

wire opcode_R_NORMAL            = (rv64I_opcode == 7'b0110011);
wire opcode_R_W_INST            = (rv64I_opcode == 7'b0111011);

lwu(0000011 I) ld(0000011 I) sd(0100011 S) addiw(0011011 I) slliw(0011011 I) srliw(0011011 I) sraiw(0011011 I) addw(0111011 R) subw(0111011 R) sllw(0111011 R) srlw(0111011 R) sraw(0111011 R) 
//------------------------func3-----------------------------------------------------------------
wire func3_000                  = (rv64I_func3 == 3'b000);
wire func3_001                  = (rv64I_func3 == 3'b001);
wire func3_010                  = (rv64I_func3 == 3'b010);
wire func3_011                  = (rv64I_func3 == 3'b011);
wire func3_100                  = (rv64I_func3 == 3'b100);
wire func3_101                  = (rv64I_func3 == 3'b101);
wire func3_110                  = (rv64I_func3 == 3'b110);
wire func3_111                  = (rv64I_func3 == 3'b111);

//B_type
wire func3_B_beq                = func3_000;
wire func3_B_bne                = func3_001;
wire func3_B_blt                = func3_100;
wire func3_B_bge                = func3_101;
wire func3_B_bltu               = func3_110;
wire func3_B_bgeu               = func3_111;

//S_type
wire func3_S_sb             	= func3_000;
wire func3_S_sh             	= func3_001;
wire func3_S_sw             	= func3_010;
wire func3_S_sd                 = func3_011;

//I_type
wire func3_I_addi               = func3_000;
wire func3_I_slli               = func3_001;
wire func3_I_slti               = func3_010;
wire func3_I_sltiu              = func3_011;
wire func3_I_xori               = func3_100;
wire func3_I_srli_srai          = func3_101;
wire func3_I_ori                = func3_110;
wire func3_I_andi               = func3_111;

wire func3_I_lb                 = func3_000;
wire func3_I_lh                 = func3_001;
wire func3_I_lw                 = func3_010;
wire func3_I_ld                 = func3_011;
wire func3_I_lbu                = func3_100;
wire func3_I_lhu                = func3_101;
wire func3_I_lwu                = func3_110;

wire func3_I_addiw              = func3_000;
wire func3_I_slliw              = func3_001;
wire func3_I_srliw_or_sraiw     = func3_101; 

wire func3_I_csrrw              = func3_001;
wire func3_I_csrrs              = func3_010;

//R_TYPE
wire func3_R_add_sub            = func3_000;
wire func3_R_sll                = func3_001;
wire func3_R_slt                = func3_010;
wire func3_R_sltu               = func3_011;
wire func3_R_xor                = func3_100;
wire func3_R_srl_sra            = func3_101;
wire func3_R_or                 = func3_110;
wire func3_R_and                = func3_111;

wire func3_R_addw_or_subw       = func3_000;
wire func3_R_sllw               = func3_001;
wire func3_R_srlw_or_sraw       = func3_101;

//-----------------------------------func7-------------------------------
wire func7_0000000              = (rv64I_func7 == 7'b0000000);
wire func7_0100000              = (rv64I_func7 == 7'b0100000);

//R_TYPE
wire func7_sra                  = func7_0100000;
wire func7_srl                  = func7_0000000;
wire func7_add                  = func7_0000000;
wire func7_sub                  = func7_0100000;
wire func7_srlw                 = func7_0000000;
wire func7_sraw                 = func7_0100000;
wire func7_addw                 = func7_0100000;
wire func7_subw                 = func7_0100000;

//-------------------------------func_special-----------------------------
wire func_special_000000        = (rv64I_I_special == 6'b000000);
wire func_special_010000        = (rv64I_I_special == 6'b010000);

//I_TYPE
wire func_I_srai                 = func_special_010000;
wire func_I_srli                 = func_special_000000;
wire func_I_sraiw                = func_special_010000;
wire func_I_srliw                = func_special_000000;
wire func_I_slliw                = func_special_000000;

//-----------------------------------rv64I-instr-----------------------------------
//U_TYPE
wire rv64I_U_lui    			= (opcode_U_lui);
wire rv64I_U_auipc  			= (opcode_U_auipc);

//I_TYPE
wire rv64I_I_addi  				= (rv64I_I_TYPE & func3_I_addi                    );
wire rv64I_I_slli  				= (rv64I_I_TYPE & func3_I_slli                    );
wire rv64I_I_slti 				= (rv64I_I_TYPE & func3_I_slti                    );
wire rv64I_I_sltiu 				= (rv64I_I_TYPE & func3_I_sltiu                   ); 
wire rv64I_I_xori  				= (rv64I_I_TYPE & func3_I_xori                    );
wire rv64I_I_srli  				= (rv64I_I_TYPE & func3_I_srli_srai & func_I_srli );
wire rv64I_I_srai  				= (rv64I_I_TYPE & func3_I_srli_srai & func_I_srai ); 
wire rv64I_I_ori   				= (rv64I_I_TYPE & func3_I_ori                     );
wire rv64I_I_andi  				= (rv64I_I_TYPE & func3_I_andi                    );

wire rv64I_I_lb    				= (rv64I_I_TYPE & func3_I_lb);
wire rv64I_I_lh    				= (rv64I_I_TYPE & func3_I_lh);
wire rv64I_I_lw    				= (rv64I_I_TYPE & func3_I_lw);
wire rv64I_I_ld                 = (rv64I_I_TYPE & func3_I_ld);
wire rv64I_I_lwu   				= (rv64I_I_TYPE & func3_I_lwu);
wire rv64I_I_lbu   				= (rv64I_I_TYPE & func3_I_lbu);
wire rv64I_I_lhu   				= (rv64I_I_TYPE & func3_I_lhu);

wire rv64I_I_sraiw              = (rv64I_I_TYPE & func3_I_srliw_or_sraiw & func_I_sraiw   );
wire rv64I_I_srliw              = (rv64I_I_TYPE & func3_I_srliw_or_sraiw & func_I_srliw   );
wire rv64I_I_slliw              = (rv64I_I_TYPE & func3_I_slliw & func_I_slliw            );
wire rv64I_I_addiw              = (rv64I_I_TYPE & func3_I_addiw                           );

wire rv64I_I_jalr  				= (rv64I_I_JALR);

wire rv32I_ecall	    		= (rv32I_instr == 32'h00000073);
wire rv32I_mret  	    		= (rv32I_instr == 32'h30200073);
wire rv32I_I_csrrw 			    = (rv32I_I_TYPE & func3_I_csrrw); //I型指令
wire rv32I_I_csrrs 			    = (rv32I_I_TYPE & func3_I_csrrw); //I型指令

//B_TYPE
wire rv64I_B_beq   				= (rv64I_B_TYPE & func3_B_beq);
wire rv64I_B_bne   				= (rv64I_B_TYPE & func3_B_bne);
wire rv64I_B_blt   				= (rv64I_B_TYPE & func3_B_blt);
wire rv64I_B_bge  				= (rv64I_B_TYPE & func3_B_bge);
wire rv64I_B_bltu  				= (rv64I_B_TYPE & func3_B_bltu);
wire rv64I_B_bgeu  				= (rv64I_B_TYPE & func3_B_bgeu);

//R_TYPE
wire rv64I_R_add    			= (rv64I_R_TYPE & func3_R_add_sub & func7_add   );
wire rv64I_R_sub    			= (rv64I_R_TYPE & func3_R_add_sub & func7_sub   ); 
wire rv64I_R_sll    			= (rv64I_R_TYPE & func3_R_sll 	                );
wire rv64I_R_slt    			= (rv64I_R_TYPE & func3_R_slt 		            );
wire rv64I_R_sltu   			= (rv64I_R_TYPE & func3_R_sltu 	                );
wire rv64I_R_xor    			= (rv64I_R_TYPE & func3_R_xor 	 		        );
wire rv64I_R_srl    			= (rv64I_R_TYPE & func3_R_srl_sra & func7_srl   );
wire rv64I_R_sra    			= (rv64I_R_TYPE & func3_R_srl_sra & func7_sra   ); 
wire rv64I_R_or     			= (rv64I_R_TYPE & func3_R_or		            );
wire rv64I_R_and    			= (rv64I_R_TYPE & func3_R_and 	 	            );

wire rv64I_R_addw               = (rv64I_R_TYPE & func3_R_addw_or_subw & func7_addw   );
wire rv64I_R_subw               = (rv64I_R_TYPE & func3_R_addw_or_subw & func7_subw   );
wire rv64I_R_sllw               = (rv64I_R_TYPE & func3_R_sllw                        );
wire rv64I_R_srlw               = (rv64I_R_TYPE & func3_R_srlw_or_sraw & func7_srlw   ); 
wire rv64I_R_sraw               = (rv64I_R_TYPE & func3_R_srlw_or_sraw & func7_sraw   ); 

//S_TYPE
wire rv64I_S_sb    				= (rv64I_S_TYPE & func3_S_sb);
wire rv64I_S_sh    				= (rv64I_S_TYPE & func3_S_sh);
wire rv64I_S_sw    				= (rv64I_S_TYPE & func3_S_sw);
wire rv64I_S_sd                 = (rv64I_S_TYPE & func3_S_sd);
//J_TYPE
wire rv64I_J_jal   				= (rv64I_J_TYPE);

//--------------------------------------imm---------------------------------------------
wire [31:0] imm_U_TYPE 			=  { rv32I_instr[31:12] , 12'd0};
wire [31:0] imm_I_TYPE 			=  { {20{rv32I_instr[31]}}, rv32I_instr[31:20]} ;
wire [31:0] imm_I_SHAMT 		=  { 27'd0,rv32I_instr[24:20]};
wire [31:0] imm_S_TYPE 			=  { {20{rv32I_instr[31]}}, rv32I_instr[31:25], rv32I_instr[11:7]} ;
wire [31:0] imm_R_TYPE			=  	 32'd0;
wire [31:0] imm_B_TYPE 			=  {{{{20{rv32I_instr[31]}},  rv32I_instr[31], rv32I_instr[7], rv32I_instr[30:25],  rv32I_instr[11:8] }  << 1'b1}};
wire [31:0] imm_J_TYPE 			=  {{{ 12{rv32I_instr[31]}},  rv32I_instr[31], rv32I_instr[19:12], rv32I_instr[20], rv32I_instr[30:21]}  << 1'b1 };

//-------------------------------------read-regfile--------------------------------------------
wire [64:0] regfile_o_rs1_data;
wire [64:0] regfile_o_rs2_data;

regfile u_regfile (
	.clk					(clk),
	.rst					(rst),
	//write back
	.write_back_i_reg_wen	(),
	.write_back_i_reg_rd	(),
	.write_back_i_reg_data	(),
	//read reg
	.decode_i_read_rs1		(rv64I_rs1),
	.decode_i_read_rs2		(rv64I_rs2),
	.regfile_o_rs1_data		(regfile_o_rs1_data),
	.regfile_o_rs2_data		(regfile_o_rs2_data)
);

assign decode_o_rs1 = (opcode_U_TYPE | opcode_J_TYPE) ? 5'd0 :
   					  (opcode_I_TYPE | opcode_B_TYPE | opcode_S_TYPE | opcode_R_TYPE) ? rv64I_rs1  : 5'd0;

assign decode_o_rs2 = (opcode_I_TYPE | opcode_U_TYPE | opcode_J_TYPE) ? 5'd0:
					  (opcode_B_TYPE | opcode_S_TYPE | opcode_R_TYPE) ? rv32I_rs2 : 5'd0;

assign decode_o_rs1_data = (decode_o_rs1  == regE_i_wb_rd && regE_i_wb_rd != 5'd0 &&  regE_i_wb_reg_wen) ? execute_i_valE : //递进电路解决数据冲突
						   (decode_o_rs1  == regM_i_wb_rd && regM_i_wb_rd != 5'd0 &&  regM_i_wb_reg_wen && regM_i_wb_valD_sel == `wb_valD_sel_valM) ? memory_i_valM 	: //类似停顿方法解决数据冲突
						   (decode_o_rs1  == regM_i_wb_rd && regM_i_wb_rd != 5'd0 &&  regM_i_wb_reg_wen && regM_i_wb_valD_sel == `wb_valD_sel_valE) ? regM_i_valE 		: //
						   (decode_o_rs1  == regW_i_wb_rd && regW_i_wb_rd != 5'd0 &&  regW_i_wb_reg_wen && regW_i_wb_valD_sel == `wb_valD_sel_valE) ? regW_i_valE  		: 
						   (decode_o_rs1  == regW_i_wb_rd && regW_i_wb_rd != 5'd0 &&  regW_i_wb_reg_wen && regW_i_wb_valD_sel == `wb_valD_sel_valM) ? regW_i_valM  		: 
						   (decode_o_rs1  == regW_i_wb_rd && regW_i_wb_rd != 5'd0 &&  regW_i_wb_reg_wen && regW_i_wb_valD_sel == `wb_valD_sel_valP) ? regW_i_pc + 32'd4 : regfile_o_valA; 

assign decode_o_rs2_data = (decode_o_rs2  == regE_i_wb_rd && regE_i_wb_rd != 5'd0 && regE_i_wb_reg_wen) ? execute_i_valE : 
						   (decode_o_rs2  == regM_i_wb_rd && regM_i_wb_rd != 5'd0 && regM_i_wb_reg_wen && regM_i_wb_valD_sel == `wb_valD_sel_valM) ? memory_i_valM 	 	: 
						   (decode_o_rs2  == regM_i_wb_rd && regM_i_wb_rd != 5'd0 && regM_i_wb_reg_wen && regM_i_wb_valD_sel == `wb_valD_sel_valE) ? regM_i_valE  		:
						   (decode_o_rs2  == regW_i_wb_rd && regW_i_wb_rd != 5'd0 && regW_i_wb_reg_wen && regW_i_wb_valD_sel == `wb_valD_sel_valE) ? regW_i_valE  		: 
						   (decode_o_rs2  == regW_i_wb_rd && regW_i_wb_rd != 5'd0 && regW_i_wb_reg_wen && regW_i_wb_valD_sel == `wb_valD_sel_valM) ? regW_i_valM  		: 
						   (decode_o_rs2  == regW_i_wb_rd && regW_i_wb_rd != 5'd0 &&  regW_i_wb_reg_wen && regW_i_wb_valD_sel == `wb_valD_sel_valP) ? regW_i_pc + 32'd4 : regfile_o_valB; 


endmodule