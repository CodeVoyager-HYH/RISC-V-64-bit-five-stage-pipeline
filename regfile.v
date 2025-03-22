module regfile(
    input wire clk,
    input wire rst,

    //write back
    input wire        write_back_i_reg_wen,
    input wire [4:0]  write_back_i_reg_rd,
    input wire [63:0] write_back_i_reg_data,

    //read reg
    input  wire [4:0]  decode_i_read_rs1,
    input  wire [4:0]  decode_i_read_rs2,
    output wire [63:0] regfile_o_valA,
    output wire [63:0] regfile_o_valB
);
import "DPI-C" function void set_gpr_ptr(input logic [31:0] a []);
reg [31:0] regfile [63:0];    

initial begin
    set_gpr_ptr(regfile);

    integer i;
    for (i = 0; i < 32; i = i + 1) begin
        regfile[i] = 64'h0;
    end
end

//read
assign regfile_o_valA = regfile[decode_i_read_rs1];
assign regfile_o_valB = regfile[decode_i_read_rs2];

//write
always @(posedge clk) begin
    if (write_back_i_reg_wen) begin
        regfile[write_back_i_reg_rd] <= write_back_i_reg_data;
    end

//x0 is always 0 
    regfile[0] <= 64'b0;
end

endmodule