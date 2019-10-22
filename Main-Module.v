`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:36:36 02/18/2015 
// Design Name: 
// Module Name:    Main-Module 
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
module MainModule(
    input clk,
    input nrst
    );
	 wire [31:0] inData;
	 wire [31:0] outData, instruction;
	 wire [31:0] addr1, addr2;
	 wire [3:0] write,read;
	 
	 DataMemory        DM(inData, addr1, write, read, outData);
	 InstructionMemory IM(addr2, instruction);
	 Core               C(instruction, clk, nrst, outData, inData, addr1, write, read, addr2);

endmodule
