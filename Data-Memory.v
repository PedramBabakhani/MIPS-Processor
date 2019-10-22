`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:35:46 04/20/2013 
// Design Name: 
// Module Name:    Data-Memory 
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
module DataMemory(
    inData,
    addr,
    write, read,
    outData
    );
    
    input [31:0] inData, addr;
    input [3:0] write, read;
    output reg [31:0] outData;
    reg [7:0] DM0 [31:0];
    reg [7:0] DM1 [31:0];
    reg [7:0] DM2 [31:0];
    reg [7:0] DM3 [31:0];
    
  //  initial
   // begin
   //   DM0 = 8'd0;
   //   DM1 = 8'd1;
   //   DM2 = 8'd2;
  //    DM3 = 8'd3;
  //  end
    
    always @ (read or write or inData or addr)
    begin
      if(read != 4'd0)
      begin
        if (read == 4'd1)
        begin
          outData[31:8] <= 24'd0;
          outData[7:0] <= DM3[addr];
        end
        else
        begin
          outData[31:24] <= DM0[addr];
          outData[23:16] <= DM1[addr];
          outData[15:8] <= DM2[addr];
          outData[7:0] <= DM3[addr];
        end
      end
      else if (write != 4'd0)
      begin
        if (write == 4'd1)
        begin
          DM3[addr] <= inData[7:0];
        end
        else
        begin
          DM0[addr] <= inData[31:24];
          DM1[addr] <= inData[23:16];
          DM2[addr] <= inData[15:8];
          DM3[addr] <= inData[7:0];
        end
      end
    end

endmodule
