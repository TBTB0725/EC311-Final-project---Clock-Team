`timescale 1ns / 1ps

module pixel_clk_gen(
    input clk,
    input display_true,
    input [9:0] x, y,
    input [3:0] sec_first, sec_second, min_first, min_second, hour_first, hour_second, mode_at,
    output reg [11:0] rgb
    );
    
    // number address 
    reg [6:0] number_addr;
    wire [6:0] number_addr_sec_first, number_addr_sec_second, number_addr_colon_first, number_addr_min_first, number_addr_min_second, number_addr_colon_second, number_addr_hour_first, number_addr_hour_second, number_addr_at;
    // find the number address
    assign number_addr_hour_first = {3'b011, hour_first};
    assign number_addr_hour_second = {3'b011, hour_second};
    assign number_addr_colon_first = 7'h3a;
    assign number_addr_min_first = {3'b011, min_first};
    assign number_addr_min_second = {3'b011, min_second};
    assign number_addr_colon_second = 7'h3a;
    assign number_addr_sec_first = {3'b011, sec_first};
    assign number_addr_sec_second = {3'b011, sec_second};
    assign number_addr_at = {3'b011, mode_at};
    
    // x-position address
    reg [3:0] x_addr;
    wire [3:0] x_addr_sec_first, x_addr_sec_second, x_addr_colon_first, x_addr_min_first, x_addr_min_second, x_addr_colon_second, x_addr_hour_first, x_addr_hour_second, x_addr_at;
    // y-position address
    reg [2:0] y_addr;
    wire [2:0] y_addr_sec_first, y_addr_sec_second, y_addr_colon_first, y_addr_min_first, y_addr_min_second, y_addr_colon_second, y_addr_hour_first, y_addr_hour_second, y_addr_at;
    // scalling positions to 32 * 64
    assign x_addr_hour_first = y[5:2];
    assign y_addr_hour_first = x[4:2];
    
    assign x_addr_hour_second = y[5:2];
    assign y_addr_hour_second = x[4:2];
    
    assign x_addr_colon_first = y[5:2];
    assign y_addr_colon_first = x[4:2];
    
    assign x_addr_min_first = y[5:2];
    assign y_addr_min_first = x[4:2];
    
    assign x_addr_min_second = y[5:2];
    assign y_addr_min_second = x[4:2];
    
    assign x_addr_colon_second = y[5:2];
    assign y_addr_colon_second = x[4:2];
    
    assign x_addr_sec_first = y[5:2];
    assign y_addr_sec_first = x[4:2];
    
    assign x_addr_sec_second = y[5:2];
    assign y_addr_sec_second = x[4:2];
    
    assign x_addr_at = y[5:2];
    assign y_addr_at = x[4:2];
    

    // If is in the area
    wire sec_first_on, sec_second_on, colon_first_on, min_first_on, min_second_on, colon_second_on, hour_first_on, hour_second_on, at_on;
        
    // Sides of each number and colon
    // Hour's first digit
    localparam hour_first_x_l = 192;
    localparam hour_first_x_r = 223;
    localparam hour_first_y_t = 192;
    localparam hour_first_y_b = 256;
    // Hour's second digit
    localparam hour_second_x_l = 224;
    localparam hour_second_x_r = 255;
    localparam hour_second_y_t = 192;
    localparam hour_second_y_b = 256;
    // First colon
    localparam colon_first_x_l = 256;
    localparam colon_first_x_r = 287;
    localparam colon_first_y_t = 192;
    localparam colon_first_y_b = 256;
    // Minute's first digit
    localparam min_first_x_l = 288;
    localparam min_first_x_r = 319;
    localparam min_first_y_t = 192;
    localparam min_first_y_b = 256;
    // Minute's second digit
    localparam min_second_x_l = 320;
    localparam min_second_x_r = 351;
    localparam min_second_y_t = 192;
    localparam min_second_y_b = 256;
    // Second Colon
    localparam colon_second_x_l = 352;
    localparam colon_second_x_r = 383;
    localparam colon_second_y_t = 192;
    localparam colon_second_y_b = 256;
    // Second's first digit
    localparam sec_first_x_l = 384;
    localparam sec_first_x_r = 415;
    localparam sec_first_y_t = 192;
    localparam sec_first_y_b = 256;  
    // Second's second digit
    localparam sec_second_x_l = 416;
    localparam sec_second_x_r = 447;
    localparam sec_second_y_t = 192;
    localparam sec_second_y_b = 256;
    // A/T
    localparam at_x_l = 448;
    localparam at_x_r = 479;
    localparam at_y_t = 192;
    localparam at_y_b = 256;
    
    // Find position in which place
    assign hour_first_on = (hour_first_x_l <= x) && (x <= hour_first_x_r) &&
                    (hour_first_y_t <= y) && (y <= hour_first_y_b) && (hour_first != 0); // turn off digit if hours 10s = 1-9
    assign hour_second_on =  (hour_second_x_l <= x) && (x <= hour_second_x_r) &&
                    (hour_second_y_t <= y) && (y <= hour_second_y_b);
    assign colon_first_on = (colon_first_x_l <= x) && (x <= colon_first_x_r) &&
                   (colon_first_y_t <= y) && (y <= colon_first_y_b);
    assign min_first_on = (min_first_x_l <= x) && (x <= min_first_x_r) &&
                    (min_first_y_t <= y) && (y <= min_first_y_b);
    assign min_second_on =  (min_second_x_l <= x) && (x <= min_second_x_r) &&
                    (min_second_y_t <= y) && (y <= min_second_y_b);                             
    assign colon_second_on = (colon_second_x_l <= x) && (x <= colon_second_x_r) &&
                   (colon_second_y_t <= y) && (y <= colon_second_y_b);
    assign sec_first_on = (sec_first_x_l <= x) && (x <= sec_first_x_r) &&
                    (sec_first_y_t <= y) && (y <= sec_first_y_b);
    assign sec_second_on =  (sec_second_x_l <= x) && (x <= sec_second_x_r) &&
                    (sec_second_y_t <= y) && (y <= sec_second_y_b);
    assign at_on = (at_x_l <= x) && (x <= at_x_r) &&
                   (at_y_t <= y) && (y <= at_y_b);
                          
    // ROM address for finding values in ROM
    wire [10:0] rom_addr;
    // Values that find in ROM
    wire [7:0] digit_word; 
    // The exactly bit we want
    wire digit_bit;
    
    // Instantiate digit rom
    clock_digit_rom cdr(.clk(clk), .addr(rom_addr), .data(digit_word));
    
    // Mux for ROM Addresses and RGB    
    always @* begin
        rgb = 12'h000;
        if(hour_first_on) begin
            number_addr = number_addr_hour_first;
            x_addr = x_addr_hour_first;
            y_addr = y_addr_hour_first;
            if(digit_bit)
                rgb = 12'hFFF;
        end
        else if(hour_second_on) begin
            number_addr = number_addr_hour_second;
            x_addr = x_addr_hour_second;
            y_addr = y_addr_hour_second;
            if(digit_bit)
                rgb = 12'hFFF;
        end
        else if(colon_first_on) begin
            number_addr = number_addr_colon_first;
            x_addr = x_addr_colon_first;
            y_addr = y_addr_colon_first;
            if(digit_bit)
                rgb = 12'hFFF;
        end
        else if(min_first_on) begin
            number_addr = number_addr_min_first;
            x_addr = x_addr_min_first;
            y_addr = y_addr_min_first;
            if(digit_bit)
                rgb = 12'hFFF;
        end
        else if(min_second_on) begin
            number_addr = number_addr_min_second;
            x_addr = x_addr_min_second;
            y_addr = y_addr_min_second;
            if(digit_bit)
                rgb = 12'hFFF;
        end
        else if(colon_second_on) begin
            number_addr = number_addr_colon_second;
            x_addr = x_addr_colon_second;
            y_addr = y_addr_colon_second;
            if(digit_bit)
                rgb = 12'hFFF;
        end
        else if(sec_first_on) begin
            number_addr = number_addr_sec_first;
            x_addr = x_addr_sec_first;
            y_addr = y_addr_sec_first;
            if(digit_bit)
                rgb = 12'hFFF;
        end
        else if(sec_second_on) begin
            number_addr = number_addr_sec_second;
            x_addr = x_addr_sec_second;
            y_addr = y_addr_sec_second;
            if(digit_bit)
                rgb = 12'hFFF;
        end  
        else if(at_on) begin
            number_addr = number_addr_at;
            x_addr = x_addr_at;
            y_addr = y_addr_at;
            if(digit_bit)
                rgb = 12'hFFF;
        end 
    end    
    
    // ROM Interface    
    assign rom_addr = {number_addr, x_addr};
    assign digit_bit = digit_word[~y_addr];    
                          
endmodule