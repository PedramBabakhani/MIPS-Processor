`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:39:44 04/20/2013
// Design Name:   Main
// Module Name:   C:/Documents and Settings/YouniX/test/CAL-Project/mmbhgkhg/CAL-Project-Phase2/TestB.v
// Project Name:  CAL-Project-Phase2
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Main
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TestB(
        );

	// Inputs
	reg clk_tb;
	reg nrst_tb;

	// Instantiate the Unit Under Test (CUT)
	CORE cut (
		.clk(clk_tb), 
		.nrst(nrst_tb)
	);

	  initial
        begin
          nrst_tb <= 1'b0;
          #15;
          nrst_tb <= 1'b1;
        end
        
        initial
         begin
           clk_tb <= 1'b0;
           #10 clk_tb <= ~clk_tb;
			  #20 clk_tb <= ~clk_tb;
			  #30 clk_tb <= ~clk_tb;
			  #40 clk_tb <= ~clk_tb;
			  #50 clk_tb <= ~clk_tb;
			  #60 clk_tb <= ~clk_tb;
			  #70 clk_tb <= ~clk_tb;
         end
      
endmodule

