module fetch(
    input  wire [63:0] regF_i_pc,
    output wire [63:0] fetch_o_instr
);
import "DPI-C" function int rtl_pmem_read(input int addr);

assign fetch_o_instr  = rtl_pmem_read(regF_i_pc);

endmodule