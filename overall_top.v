`timescale 1ns / 1ps

module overall_top(
    input clk_100MHz, 
    input reset,
    input sec_button,
    input min_button,
    input hour_button,
    input start,
    input pause,
    input mode,
    output reg h_sync,
    output reg v_sync, 
    output reg [11:0] rgb
    );
    
    wire [11:0] rgb_a, rgb_t;
    wire h_sync_t, v_sync_t, h_sync_a, v_sync_a;
    
    timer_top inst1(
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .start(start),
        .pause(pause),
        .mode(mode),
        .h_sync(h_sync_t),
        .v_sync(v_sync_t),
        .rgb(rgb_t)
        );
            
    alarm_top inst2(
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .sec_button(sec_button),
        .min_button(min_button),
        .hour_button(hour_button),
        .mode(mode),
        .h_sync(h_sync_a),
        .v_sync(v_sync_a),
        .rgb(rgb_a)
        );
            
    always @* begin
        if(mode) begin
            h_sync <= h_sync_t;
            v_sync <= v_sync_t;
            rgb <= rgb_t;
        end
        else if(~mode) begin
            h_sync <= h_sync_a;
            v_sync <= v_sync_a;
            rgb <= rgb_a;
        end
    end    
endmodule
