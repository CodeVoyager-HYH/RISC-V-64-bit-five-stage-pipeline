#include <common.h>
#include <cstdint>
#include <cstdio>
#include <defs.h>
#include "verilated_dpi.h" // For VerilatedDpiOpenVar and other DPI related definitions


extern "C" void dpi_ebreak(){
	printf("下一个要执行的指令是ebreak\n");
	SIMTRAP(0x80000000, 0);
}

extern "C" uint32_t dpi_instr_mem_read(uint64_t addr){
  if(addr >= CONFIG_MBASE && addr < CONFIG_MBASE + CONFIG_MSIZE){
        //printf("访问的内存地址是0x%lx\n", addr);
		return pmem_read(addr, 4);
	}else{
//      printf("你将要访问的内存地址是0x%lx, 超出了内存区域\n", addr);
      return 0;
   }
}

extern "C" uint64_t dpi_mem_read(uint64_t addr, uint64_t len){
	if(addr == 0) return 0;
	else{
		uint64_t data = pmem_read(addr, len);
//	printf("要读取的地址是addr=0x%lx, len=%ld, 读取出来的数据是data=%ld\n", addr, len,data);
		return data;
	}
}

extern "C" void dpi_mem_write(uint64_t addr, uint64_t data, int len){
//	printf("store指令, 写入地址addr=[%lx], 写入数据wdata=[%lx], 写入长度len=[%d]\n", addr, data, len);
	if(addr == CONFIG_SERIAL_MMIO){
		char ch = data;
		printf("%c", ch);
		fflush(stdout);
	}else{
		pmem_write(addr, len, data);
	}
}


extern uint32_t  *reg_ptr;
extern "C" void dpi_read_regfile(const svOpenArrayHandle r) {
  reg_ptr = (uint32_t *)(((VerilatedDpiOpenVar*)r)->datap());
}