module CPU (
    input  wire clk,
    input  wire rst,

    output wire [63:0]  cur_pc,
    output wire         commit,
);
    
pc_select u_pc_selec(
    .pc_select_i_seq_pc      (),
    .pc_select_i_alu_out     (),
    .decode_i_jump           (),
    .pc_select_o_pc          ()
);

regF u_regF(    // 寄存pc
    .clk                (clk),
    .rst                (rst),
    .ctrl_i_regF_stall  (),
    .pc_select_o_pc     (),
    .regF_o_pc          ()
);

fetch u_fetch(
    .regF_i_pc      (),
    .fetch_o_instr  ()
)





endmodule