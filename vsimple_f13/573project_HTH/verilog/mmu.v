`timescale 1ns/100ps

module mmu ( // Inputs
		proc2mem_addr,
		proc2Dmem_command,
		login,
		trigger,

             // Outputs
		mem_addr,
		data_protected
           );

input	[63:0]		proc2mem_addr;
input 	[1:0]  		proc2Dmem_command;
input			login;
input			trigger;

output	[63:0]		mem_addr;
output			data_protected;


assign	data_protected 	= (login || trigger || (proc2Dmem_command == `BUS_NONE ) ) 	? 1'b0
						: ( proc2mem_addr >= `lower_bound && proc2mem_addr <= `upper_bound ) ? 1'b1 : 1'b0;
assign	mem_addr	= data_protected ? 0 : proc2mem_addr;

endmodule
