`include "define.v"
module memory(
	input wire clk,
	input wire rst,
    input wire  	    regM_i_mem_ren,
    input wire  	    regM_i_mem_wen,
    input wire  [7:0]   regM_i_mem_wmask,
	input wire  [63:0]	regM_i_valE,
	input wire  [63:0]	regM_i_valB,

	output wire [63:0]	memory_o_valM       //the result of read memory 
);
import "DPI-C" function int rtl_pmem_read(input int addr);
import "DPI-C" function void rtl_pmem_write(input int  waddr, input int  wdata, input byte wmask);
//read mem
assign memory_o_valM = (regM_i_mem_ren) ? rtl_pmem_read(regM_i_valE, 4);

//write mem
always @(posedge clk)begin
    if(regM_i_mem_wen && regM_i_mem_wmask != `zero_byte) begin
        rtl_pmem_write(regM_i_valE, regM_i_valB, regM_i_mem_wmask);
    end
end

endmodule