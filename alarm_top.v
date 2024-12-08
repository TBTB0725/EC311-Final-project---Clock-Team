`timescale 1ns / 1ps

module alarm_top(
    input clk_100MHz, 
    input reset,
    input sec_button,
    input mode,
    input min_button,
    input hour_button,
    output h_sync,
    output v_sync, 
    output [11:0] rgb
    );
    
    wire [9:0] x, y;
    wire display_true, pixel_clk;
    wire [3:0] hour_first, hour_second, min_first, min_second, sec_first, sec_second, mode_at;
    reg [11:0] rgb_reg;
    wire [11:0] rgb_next;
    
    vga_controller vga(
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .display_true(display_true),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .pixel_clk(pixel_clk),
        .x(x),
        .y(y)
        );
 
    binary_clock digital_clock(
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .mode(mode),
        .sec_button(sec_button),
        .min_button(min_button),
        .hour_button(hour_button),
        .one_sec(),
        .sec_first(sec_first),
        .sec_second(sec_second),
        .min_first(min_first),
        .min_second(min_second),
        .hour_first(hour_first),
        .hour_second(hour_second),
        .mode_at(mode_at)
        );

    pixel_clk_gen pclk(
        .clk(clk_100MHz),
        .display_true(display_true),
        .x(x),
        .y(y),
        .sec_first(sec_first),
        .sec_second(sec_second),
        .min_first(min_first),
        .min_second(min_second),
        .hour_first(hour_first),
        .hour_second(hour_second),
        .mode_at(mode_at),
        .rgb(rgb_next)
        );
 
    always @(posedge clk_100MHz)
        if(pixel_clk)
            rgb_reg <= rgb_next;
            
    // output
    assign rgb = rgb_reg; 
    
endmodule