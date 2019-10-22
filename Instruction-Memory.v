`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:34:34 04/20/2013 
// Design Name: 
// Module Name:    Instruction-Memory 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module InstructionMemory(
    addr,
    instruction
    );
  input [31:0] addr;
	output reg [31:0] instruction;
	//reg    [31:0] instruction;
	reg [31:0] mem [0:1023];
	
	always @(addr)
		instruction = mem[addr];
		
	
	initial
		$readmemb("prog.asm",mem);

endmodule
