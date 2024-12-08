`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2024 02:02:58 PM
// Design Name: 
// Module Name: jkff
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module jkff(
    input J,
    input K,
    input clk,
    output Q,
    output notQ
    );
    
    wire D;
    
    assign D = (J & ~Q)|(~K & Q);
    dff dff_inst(.clk(clk), .D(D), .Q(Q), .notQ(notQ));
    
    
endmodule
