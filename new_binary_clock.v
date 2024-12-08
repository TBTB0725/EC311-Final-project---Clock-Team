`timescale 1ns / 1ps

module binary_clock(
    input clk_100MHz,
    input reset,
    input mode,
    input sec_button,
    input min_button,
    input hour_button,
    output one_sec,
    output [3:0] sec_first, sec_second, min_first, min_second, hour_first, hour_second,
    output reg [3:0] mode_at
    );
    
    // 
    wire reset_1;
    assign reset_1 = ~mode & reset;
    
    // Get debounced input
	reg sec_1, sec_2, sec_3, min_1, min_2, min_3, hour_1, hour_2, hour_3;
	wire sec_button_debounce, min_button_debounce, hour_button_debounce;
	always @(posedge clk_100MHz) begin
		sec_1 <= sec_button;
		sec_2 <= sec_1;
		sec_3 <= sec_2;
	end
	assign sec_button_debounce = sec_3;
	
	always @(posedge clk_100MHz) begin
		min_1 <= min_button;
		min_2 <= min_1;
		min_3 <= min_2;
	end
	assign min_button_debounce = min_3;
	
	always @(posedge clk_100MHz) begin
		hour_1 <= hour_button;
		hour_2 <= hour_1;
		hour_3 <= hour_2;
	end
	assign hour_button_debounce = hour_3;

    // Get 1Hz using 100MHz
    reg [31:0] counter = 32'h0;
    reg result = 1'b0;
    
    always @(posedge clk_100MHz or posedge reset_1)
        if(reset_1)
            counter <= 32'h0;
        else
            if(counter == 49_999_999) begin
                counter <= 32'h0;
                result <= ~result;
            end
            else
                counter <= counter + 1;
     
    // Logic for the digital clock
    reg [5:0] sec_counter = 6'b0;
    reg [5:0] min_counter = 6'b0;
    reg [4:0] hour_counter = 6'h0;
    
    always @(posedge one_sec or posedge reset_1)
        if(reset_1)
            sec_counter <= 6'b0;
        else 
            if(sec_button_debounce)
                if(sec_counter == 59)
                    sec_counter <= 6'b1;
                else if (sec_counter == 58)
                    sec_counter <= 6'b0;
                else
                    sec_counter <= sec_counter + 2;
            else
                if(sec_counter == 59)
                    sec_counter <= 6'b0;
                else
                    sec_counter <= sec_counter + 1;
            
    always @(posedge one_sec or posedge reset_1)
        if(reset_1)
            min_counter <= 6'b0;
        else 
            if(min_button_debounce | (sec_counter == 59))
                if(min_counter == 59)
                    min_counter <= 6'b0;
                else
                    min_counter <= min_counter + 1;
                    
    always @(posedge one_sec or posedge reset_1)
        if(reset_1)
            hour_counter <= 5'h0;
        else 
            if(hour_button_debounce | (min_counter == 59 && sec_counter == 59))
                if(hour_counter == 23)
                    hour_counter <= 5'h0;
                else
                    hour_counter <= hour_counter + 1;
                                   
    // Convert binary numbers to ouput
    assign sec_first = sec_counter / 10;
    assign sec_second = sec_counter % 10;
    assign min_first = min_counter / 10;
    assign min_second = min_counter % 10;
    assign hour_first = hour_counter / 10;
    assign hour_second = hour_counter % 10;
    
    always @(*) begin
        mode_at = (mode == 1'b0) ? 4'hb : 4'hc;
    end
    
    // 1Hz output            
    assign one_sec = result; 
            
endmodule