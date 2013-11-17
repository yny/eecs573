`define lower_bound	8000
`define upper_bound	8800

module mmu ( // Inputs
		proc2mem_addr,
		login,
		trigger,	

             // Outputs
		mem_addr,
		protected
           );

input	[63:0]		proc2mem_addr;
input			login;
input			trigger;

output	[63:0]		mem_addr;
output			protected;

assign	protected 	= (login || trigger) 	? 0
						: ( proc2mem_addr >= `lower_bound && proc2mem_addr <= `upper_bound ) ? 1 : 0;
assign	mem_addr	= protected ? 0 : proc2mem_addr;

endmodule
