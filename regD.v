module regD(
    input wire clk,
    input wire rst,
    
    input wire [63:0] regF_i_pc,
    input wire [31:0] fetch_i_instr,
    input wire        ctrl_i_regD_stall,
    input wire        ctrl_i_regD_flash,

    output wire [63:0] regD_o_pc,
    output wire [31:0] regD_o_instr
);

always @(posedge clk) begin
    if (rst || ctrl_i_regD_flash) begin
        regD_o_pc    <= 64'h0;
        regD_o_instr <= 32'h0;
    end
    else if (~ctrl_i_regD_stall) begin
        regD_o_pc    <= regF_i_pc;
        regD_o_instr <= fetch_i_instr;
    end    
end    

endmodule