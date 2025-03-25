module fetch(
    input  wire [63:0] regF_i_pc,

    output wire [31:0] fetch_o_instr,
	output wire [63:0] fetch_o_pre_pc,
	output wire  	   fetch_o_commit
);
import "DPI-C" function int  dpi_mem_read 	(input int addr  , input int len);

assign fetch_o_pre_pc = regF_i_pc + 64'd4; 
assign fetch_o_instr  = dpi_mem_read(regF_i_pc[31:0], 4);
assign fetch_o_commit = 1;

endmodule