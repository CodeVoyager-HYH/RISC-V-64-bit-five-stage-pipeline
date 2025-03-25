#include <common.h>
#include <cstdio>
#include <defs.h>
#include "verilated_dpi.h" // For VerilatedDpiOpenVar and other DPI related definitions

#include <verilated.h>
#include <verilated_vcd_c.h>
#include <npc.h>
extern TOP_NAME dut;  			    //CPU
extern VerilatedVcdC *m_trace;  //仿真波形
extern word_t sim_time ;			//时间
extern word_t clk_count ;
extern uint32_t  *reg_ptr;

void difftest_skip_ref();
void npc_close_simulation();
extern "C" void dpi_ebreak(int pc){
	// printf("下一个要执行的指令是ebreak\n");
	SIMTRAP(pc, 0);
}

extern "C" int dpi_mem_read(int addr, int len){
	
	if(addr == 0) return 0;
	if(addr >=  CONFIG_RTC_MMIO && addr < CONFIG_RTC_MMIO + 4){
		int time = get_time();
		IFDEF(CONFIG_DIFFTEST, difftest_skip_ref());
		return time;
	}else if(addr >= 0x80000000 && addr <= 0x8fffffff){
		unsigned int data = pmem_read(addr, len);
		//Log("[pmem_read] addr = 0x%x,data = %x, pc = 0x%lx",addr,data,dut.commit_pc);
		return data;
	}else{
		printf("你将要访问的内存地址是0x%x, 不属于内存地址[0x80000000, 0x8ffffffff], 程序即将出错退出\n", addr);
		printf("NUM\tHEX\tDEC\n");
		for(int i = 0;i < 32; i++){
			printf("x[%d]\t%x\t%d\n",i,reg_ptr[i],reg_ptr[i]);
		}
		//Log("error instr = 0x%x,pc = 0x%lx",dut.commit_instr,dut.commit_pc);
		npc_close_simulation();
		exit(1);
	}
}
extern "C" void dpi_mem_write(int addr, int data, int len){
	if(addr == CONFIG_SERIAL_MMIO){
		char ch = data;
		printf("%c", ch);
		fflush(stdout);
		IFDEF(CONFIG_DIFFTEST, difftest_skip_ref());
	}else if(addr >= 0x80000000 && addr <= 0x8fffffff){
		// printf("write addr: 0x%x, data: 0x%x\n", addr, data);
		pmem_write(addr, len, data);
	}
	else{
		printf("你将要访问的内存地址是0x%x, 不属于内存地址[0x80000000, 0x8ffffffff], 程序即将出错退出\n", addr);
		npc_close_simulation();
		exit(1);
		
	}
}


//extern uint32_t  *reg_ptr;
extern "C" void dpi_read_regfile(const svOpenArrayHandle r) {
  reg_ptr = (uint32_t *)(((VerilatedDpiOpenVar*)r)->datap());
}

uint32_t cpu_mstatus = 0;
uint32_t cpu_mtvec = 0;
uint32_t cpu_mcause = 0;
uint32_t cpu_mepc = 0;

extern "C" void get_csr_value(unsigned int mstatus, unsigned int  mtvec, unsigned int mcause, unsigned int mepc){
	cpu_mstatus = mstatus;
	cpu_mtvec   = mtvec;
	cpu_mcause  = mcause;
	cpu_mepc    = mepc;
}	