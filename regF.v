module regF (
    input  wire        clk,
    input  wire        rst,
    input  wire        regF_i_stall,
    input  wire [63:0] pc_select_o_pc,

    output wire [63:0] regF_o_pc
);
    always @(posedge clk) begin
        if(rst) begin
            regF_o_pc <= 64'h0;
        end
        else if (~regF_i_stall) begin 
            regF_o_pc <= pc_select_o_pc;
        end

    end
endmodule

