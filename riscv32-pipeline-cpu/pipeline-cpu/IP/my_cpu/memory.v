`include "define.v"
module memory(
	input wire clk,
	input wire rst,
    input wire  	    regM_i_mem_ren,
    input wire  	    regM_i_mem_wen,
    input wire  [3:0]   regM_i_mem_wmask,
	input wire  [63:0]	regM_i_valE,
	input wire  [63:0]	regM_i_valB,

	output wire [63:0]	memory_o_valM       //the result of read memory 
);
import "DPI-C" function void dpi_mem_write(input int addr, input int data, int len);
import "DPI-C" function int  dpi_mem_read (input int addr  , input int len);

//read mem
assign memory_o_valM = (regM_i_mem_ren) ? {32'd0,dpi_mem_read(regM_i_valE[31:0], 4)} : 64'd0;

//write mem
wire [31:0] write_byte = {28'b0, regM_i_mem_wmask};
always @(posedge clk)begin
    if(regM_i_mem_wen && regM_i_mem_wmask != `zero_byte) begin
        dpi_mem_write(regM_i_valE[31:0], regM_i_valB[31:0], write_byte);
    end
end

//debug
always @(*) begin
    if(`debug && regM_i_mem_ren) $display("[memory] dpi_mem_read = 0x%x, lenth = %d,read_data = %x\n",regM_i_valE[31:0],4,memory_o_valM);
    else if (`debug && regM_i_mem_wen) $display("[memory] dpi_mem_write = 0x%x, lenth = %d\n",regM_i_valE[31:0],4);
end
endmodule