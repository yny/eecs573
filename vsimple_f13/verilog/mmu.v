//`define lower_bound	4400
//`define upper_bound	5000

module mmu ( // Inputs
		proc2mem_addr,
		proc2Dmem_command,
		login,
		trigger,

             // Outputs
		mem_addr,
		protected
           );

input	[63:0]		proc2mem_addr;
input 	[1:0]  		proc2Dmem_command;
input			login;
input			trigger;

output	[63:0]		mem_addr;
output			protected;


assign	protected 	= (login || trigger || (proc2Dmem_command == `BUS_NONE ) ) 	? 0
						: ( proc2mem_addr >= `lower_bound && proc2mem_addr <= `upper_bound ) ? 1 : 0;
assign	mem_addr	= protected ? 0 : proc2mem_addr;

endmodule
