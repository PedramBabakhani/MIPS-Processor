`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:33:20 02/18/2015 
// Design Name: 
// Module Name:    Core 
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
module Core(   
	 input clk, nrst);
	 
	wire wea;
	wire [31:0] dout;
	wire [31:0] din;
	wire [9:0] pc;
	instruction_memory imem(clk,wea,pc,din,dout);
   reg [31:0] registerfile[0:31];
	
 
endmodule
