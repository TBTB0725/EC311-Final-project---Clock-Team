`timescale 1ns / 1ps

module vga_controller(
    input clk_100MHz,
    input reset,
    output display_true,
    output h_sync,
    output v_sync,
    output pixel_clk, 
    output [9:0] x, y
    );
    
    // Parameters for the screen
    parameter h_display = 640;
    parameter h_front = 16;
    parameter h_pulse = 96;
    parameter h_back = 48;
    parameter h_max = 799;
    parameter v_display = 480;
    parameter v_front = 10;
    parameter v_pulse = 2;
    parameter v_back = 33;
    parameter v_max = 524;
    
    // Generate a 25MHz clock
	reg  [1:0] counter;
	wire result;
	always @(posedge clk_100MHz or posedge reset)begin
		if(reset)
		  counter <= 0;
		else
		  counter <= counter + 1;
	end
	assign result = (counter == 0) ? 1 : 0;
    
    reg [9:0] h_position, h_position_next, v_position, v_position_next;
    reg v_sync_reg, h_sync_reg;
    wire v_sync_next, h_sync_next;
    
    // Logic for register update
    always @(posedge clk_100MHz or posedge reset)
        if(reset) begin
            h_position <= 0;
            v_position <= 0;
            v_sync_reg  <= 1'b0;
            h_sync_reg  <= 1'b0;
        end
        else begin
            h_position <= h_position_next;
            v_position <= v_position_next;
            h_sync_reg  <= h_sync_next;
            v_sync_reg  <= v_sync_next;
        end
         
    //Logic for horizontal position
    always @(posedge pixel_clk or posedge reset)
        if(reset)
            h_position_next = 0;
        else
            if(h_position == h_max)
                h_position_next = 0;
            else
                h_position_next = h_position + 1;         
  
    // Logic for vertical position
    always @(posedge pixel_clk or posedge reset)
        if(reset)
            v_position_next = 0;
        else
            if(h_position == h_max)
                if((v_position == v_max))
                    v_position_next = 0;
                else
                    v_position_next = v_position + 1;


    // h_sync_next and v_sync_next is true when position is in the pulse area
    assign h_sync_next = (h_position >= (h_display + h_front) && h_position <= (h_display + h_front + h_pulse - 1));
    assign v_sync_next = (v_position >= (v_display + v_front) && v_position <= (v_display + v_front + v_pulse - 1));
    
    // display_true only when position is in display area
    assign display_true = (h_position < h_display) && (v_position < v_display); 
            
    // Outputs
    assign h_sync = h_sync_reg;
    assign v_sync = v_sync_reg;
    assign x = h_position;
    assign y = v_position;
    assign pixel_clk = result;
            
endmodule