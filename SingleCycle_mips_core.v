`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:50:09 03/04/2014 
// Design Name: 
// Module Name:    mips_core 
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
module mips_core(    
						input  clk,
						input  nrst,
						output reg [7:0] out,
						input  [2:0] in
					 );
	 
//--------------------------------------- Declaration

	wire [31:0] idata;
	wire [5:0 ] pc_in,pc_out;
	reg  [5:0 ] pc;
	reg  [0:0] wr0;
	reg  w1;
   reg  w2;
   reg  w3;
   reg  w4;
	reg  jmp,Regdes,Mem2reg,Alusrc,Branch;

//---------------------------------------	 
	
	wire [31:0]	din;
	wire [31:0]	dout1, dout2, ExData, Alu_in;
	reg  [31:0] RegBank [0:31];
	 
//---------------------------------------
	
	reg  [3:0 ] alu_func;
	reg  [31:0] alu_dout;	 
	wire [31:0] MemOut;	 
	reg Zeroflag,Overflow,jmpreg;

//---------------------------------------	 
	 
	wire [4:0] RS,RT,RD,RH;
	wire [5:0] jmpadd,Branch_mux_out;
	wire Cntl;
	 
//------------------------------------------------------- Assignment Statements
	assign RS 				 = idata[25:21];
	assign RT 				 = idata[20:16];
	assign RH 				 = idata[10:6];
	assign RD				 = (Regdes) ? idata[15:11] : idata[20:16];
	assign ExData [31:16] = (idata[15]) ? 16'b1000000000000000 : 16'b0000000000000000;
	assign ExData [15:0 ] = idata[15:0];
	assign din 				 = (Mem2reg) ? MemOut : alu_dout;
	assign Alu_in 			 = (Alusrc) ? ExData : dout2 ;
	assign pc_out 			 = nrst ? (pc + 1) : (6'b000000);
	assign pc_in  			 = jmp  ? jmpadd : Branch_mux_out;
	assign Branch_mux_out = (Cntl) ? ExData[5:0] : pc_out;
	assign Cntl				 = Branch && Zeroflag;
	assign jmpadd			 = jmpreg ? dout1[5:0] : ExData[5:0];
	 
//------------------------------------------------------- Program Counter	 
	 
	 always@(posedge clk)  
	 begin
			if(nrst == 0)
				begin
					pc     <= 6'b000000;
					//RegBank [0][2:0] <= in;
					//RegBank [0][31:3] <= 28'b0;	
				
				end
			else

				begin
					pc     <= pc_in;
					out    <= alu_dout [7:0];
				end
	 end
	 
 	 
//------------------------------------------------------- Merged DCD And Control unit	 

	 always@(idata)   											    
	 begin
	 
//------------------------------------------------------- R Type Instructions
		if (idata[31:26] == 6'b000000)							 
		begin		
			jmp       <= 1'b0;
			Overflow  <= 1'b0;
			jmpreg    <= 1'b0;
			Branch    <= 1'b0;
			wr0       <= 1'b1;
			Regdes    <= 1'b1;
			Mem2reg   <= 1'b0;
			Alusrc    <= 1'b0;
			alu_func  <= 4'd10;
			w1        <= 1'b0;
			w2			 <= 1'b0;
			w3			 <= 1'b0;
			w4			 <= 1'b0;
			
			if		 (idata[5:0] == 6'b100000)
				alu_func <= 4'd0;
			else if(idata[5:0] == 6'b100001)
				alu_func <= 4'd1;
			else if(idata[5:0] == 6'b100100)
				alu_func <= 4'd2;
			else if(idata[5:0] == 6'b100101)
				alu_func <= 4'd3;
			else if(idata[5:0] == 6'b100010)
				alu_func <= 4'd4;
			else if(idata[5:0] == 6'b100011)
				alu_func <= 4'd5;
			else if(idata[5:0] == 6'b100110)
				alu_func <= 4'd6;
			else if(idata[5:0] == 6'b001000)				
			begin
				jmp      <= 1'b1;
				jmpreg   <= 1'b1;
			end
			else if(idata[5:0] == 6'b101010)
				alu_func <= 4'd8;
			else if(idata[5:0] == 6'b101011)
				alu_func <= 4'd9;
			else if(idata[31:0] == 32'd0)
				alu_func <= 4'd10;
			else if(idata[5:0] == 6'b000000)     
				alu_func <= 4'd11;
			else if(idata[5:0] == 6'b000100)
				alu_func <= 4'd12;
			else if(idata[5:0] == 6'b000011)
				alu_func <= 4'd13;
			else if(idata[5:0] == 6'b000010)
				alu_func <= 4'd14;
			else if(idata[5:0] == 6'b000110)
				alu_func <= 4'd15;
		end

//------------------------------------------------------- I Type Instructions

	else if (idata[31:29] == 3'd1)             
	begin

		jmp       <= 1'b0;
		Overflow  <= 1'b0;
		jmpreg    <= 1'b0;
		wr0       <= 1'b1;
		Regdes    <= 1'b0;
		Mem2reg   <= 1'b0;
		Alusrc    <= 1'b1;
		Branch    <= 1'b0;
		w1        <= 1'b0;
		w2			 <= 1'b0;
		w3			 <= 1'b0;
		w4			 <= 1'b0;
		
		if(idata[28:26] == 3'b000)
	   	 alu_func <= 4'd0;
		else if(idata[28:26] == 3'b001)
		    alu_func <= 4'd1;
		else if(idata[28:26] == 3'b100)  							 // AND IMMEDIATE
		    alu_func <= 4'd2;
		else if(idata[28:26] == 3'b101)	   						 // OR IMMEDIATE
		    alu_func <= 4'd3;			 	 
		else if(idata[28:26] == 3'b110) 					    		 // XOR IMMEDIATE
		    alu_func <= 4'd6;	
		else if(idata[28:26] == 3'b111) 								 // LOAD UPPER IMMEDIATE
			 alu_func <= 4'd7;
      else if(idata[28:26] == 3'b010)  							 // SET ON LESS THAN IMMEDIATE
		    alu_func <= 4'd8;
   	else if(idata[28:26] == 3'b011) 								 // SET ON LESS THAN IMMEDIATE UNSIGNED
		    alu_func <= 4'd9;		
		else
			 alu_func <= 4'd10;		
	end
	
	else if(idata[31] == 1'd1)
		  begin
		    Alusrc   <= 1;
		    Regdes   <= 0;
			 Overflow  <= 1'b0;
		    jmp      <= 0;
			 jmpreg   <= 1'b0;
			 Branch   <= 0;
			 Mem2reg  <= 0;
			 alu_func <= 4'd10;
			 wr0       <= 0;
			 w1       <= 1'b0;
			 w2	    <= 1'b0;
			 w3       <= 1'b0;
			 w4	    <= 1'b0;
			 
		    if(idata[31:26] == 6'b100000) 							  // Load Byte
			 
		    begin
		      alu_func <= 4'd1;
		      Mem2reg  <= 1;
		      wr0      <= 1;
		    end
			 
		    else if(idata[31:26] == 6'b100011) 					  // Load Word
		    begin
		      alu_func <= 4'd1;
		      Mem2reg  <= 1;
		      wr0      <= 1;
		    end
			 
		    else if(idata[31:26] == 6'b101000)							// Store Byte
		    begin  
		      w1       <= 1'b1;
				w2       <= 1'b0;
		      alu_func <= 4'd1;
		      Mem2reg 	<= 0;
		      wr0      <= 0;
		    end
			 
		    else if(idata[31:26] == 6'b101011)							// Store Word
		    begin  
		      w1       <= 1'b1;
				w2       <= 1'b1;
		      alu_func <= 4'd1;
		      Mem2reg  <= 0;
		      wr0      <= 0;
		    end	    
		  end 																	// END OF I TYPE INSTR.
	

//------------------------------------------------------- J Type Instructions


		else //if(idata[31:29] == 3'd0)
		  begin
		    Alusrc     <= 0;
		    Regdes     <= 0;
			 Overflow  <= 1'b0;
			 jmpreg     <= 1'b0;
		    Mem2reg    <= 0;
		    wr0        <= 0;
			 jmp        <= 0;
			 Branch     <= 1;
			 alu_func   <= 4'd10;
			 w1         <= 1'b0;
    		 w2			<= 1'b0;
 			 w3		   <= 1'b0;
			 w4			<= 1'b0;
		    if(idata[28:26] == 3'b100)         			   // Branche on Equal
		    begin
		      alu_func <= 4'd4;
		      Branch   <= 1;
		      jmp      <= 0;
		    end
		    else if(idata[28:26] == 3'b101)                // Branche on Not Equal
		    begin
		      alu_func <= 4'd4;
		      Branch   <= 1;
		      jmp      <= 0;
		    end
		    else if(idata[28:26] == 3'b010)               // Jump
		    begin  
		      alu_func <= 4'd10;
		      jmp      <= 1;
		      Branch   <= 0;
		    end
		    else if(idata[28:26] == 3'b011)               // Jump And Link
		    begin  
		      alu_func <= 4'd10;
		      jmp      <= 1;
		      Branch   <= 0;
		    end
			 		 
		  end 
    end
	 
//------------------------------------------------------- Register Bank	 

	always @(posedge clk)
	
	begin
		if (wr0 == 1'b1)
			RegBank[RD] <= din;
	end
	
	assign dout1 = RegBank[RS];
	assign dout2 = RegBank[RT];
		
//------------------------------------------------------- ALU
	
	always@(alu_func or dout1 or Alu_in or RH )		                 	 
	begin
	
		alu_dout <= 32'd0;
		Zeroflag <= 1'b0;
		if (alu_func == 4'd0) 										//Add with overflow
			{Overflow,alu_dout} <= dout1 + Alu_in;
		else if (alu_func == 4'd1)								   //Add unsigned without overflow
			alu_dout <= dout1 + Alu_in;
		else if (alu_func == 4'd2) 								//AND
			alu_dout <= dout1 & Alu_in;
		else if (alu_func == 4'd3) 								//OR
			alu_dout <= dout1 | Alu_in;
		else if (alu_func == 4'd4)
		
		begin
		
			alu_dout <= dout1 - Alu_in;							   //SUB Signed
			if(alu_dout == 0)
				Zeroflag <= 1;
			else
				Zeroflag <= 0;
		end
		
		else if (alu_func == 4'd5)									//SUB Unsigned
			alu_dout <= dout1 - Alu_in;
			
		else if (alu_func == 4'd6) 								//XOR
			alu_dout <= dout1 ^ Alu_in;
			
		else if (alu_func == 4'd7)									//Load upper immediate		
		begin
			alu_dout[31:16] <= Alu_in[15:0];
			alu_dout[15:0] <= 16'd0;
		end	
			
		else if (alu_func == 4'd8) 								//Set on less than (Signed)
		begin
		
			if(dout1[31] < Alu_in[31])
				alu_dout <= 32'd0;
			else if(dout1[31] > Alu_in[31])
				alu_dout <= 32'd1;
			else if(dout1[31] == Alu_in[31])
			
			begin
			
				if (dout1[31] == 1'b0)
					if(dout1[30:0] < Alu_in[30:0])
						alu_dout <= 32'd1;
					else
						alu_dout <= 32'd0;
						
				if (dout1[31] == 1'b1)
					if(dout1[30:0] > Alu_in[30:0])
						alu_dout <= 32'd1;
					else
						alu_dout <= 32'd0;
			end
			
			else
				alu_dout <= 32'd0;
				
		end
				
		else if (alu_func == 4'd9) 								//Set on less than (Unsigned)
			if(dout1 < Alu_in)
				alu_dout <= 32'd1;
			else
				alu_dout <= 32'd0;
	
		else if (alu_func == 4'd10)								//No Op
			alu_dout <= 32'd0;
			
		else if (alu_func == 4'd11) 								//SLL
			alu_dout <= Alu_in << RH;
			
		else if (alu_func == 4'd12) 								//SLLV
			alu_dout <= Alu_in << dout1;
			
			
		else if (alu_func == 4'd13) 								//SRA
		begin
			alu_dout[31] <= Alu_in[31];
			alu_dout     <= Alu_in >> RH;
			
		end
			
		else if (alu_func == 4'd14) 								//SRL
			alu_dout <= Alu_in >> dout1;
			
		else if (alu_func == 4'd15) 								//SRLV
			alu_dout <= Alu_in >> dout1;
			
	end
	
//------------------------------------------------------- Instantiation	
	 
	 ins_mem  m1(clk,pc,idata);
	 data_mem m2(clk,w1,alu_dout[5:0],dout2[7 : 0],MemOut[7:0]);
	 data_mem m3(clk,w2,alu_dout[5:0],dout2[15: 8],MemOut[15:8 ]);
	 data_mem m4(clk,w3,alu_dout[5:0],dout2[23:16],MemOut[23:16]);
	 data_mem m5(clk,w4,alu_dout[5:0],dout2[31:24],MemOut[31:24]);

//------------------------------------------------------- Instantiation
	 
endmodule
