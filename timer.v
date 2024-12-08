`timescale 1ns / 1ps

module timer(
    input start,
    input pause,
    input mode,
    input clk_100MHz,
    input reset,
    output one_sec,
    output [3:0] sec_first, sec_second, min_first, min_second, hour_first, hour_second,
    output reg [3:0] mode_at
    );
   
    wire Q;
    wire clk_1;
    wire reset_2;
    
    assign reset_2 = mode & reset;

    jkff jkff_inst(.J(start), .K(pause), .clk(clk_100MHz), .Q(Q), .notQ());
    assign clk_1 = Q & clk_100MHz & mode;
    
    // Get 1Hz using 100MHz
    reg [31:0] counter = 32'h0;
    reg result = 1'b0;
    
    always @(posedge clk_1 or posedge reset_2)
        if(reset_2)
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
    reg [3:0] hour_counter = 5'h0;
    
    always @(posedge one_sec or posedge reset_2)
        if(reset_2)
            sec_counter <= 6'b0;
        else 
            if(sec_counter == 59)
                sec_counter <= 6'b0;
            else
                sec_counter <= sec_counter + 1;
            
    always @(posedge one_sec or posedge reset_2)
        if(reset_2)
            min_counter <= 6'b0;
        else 
            if(sec_counter == 59)
                if(min_counter == 59)
                    min_counter <= 6'b0;
                else
                    min_counter <= min_counter + 1;
                    
    always @(posedge one_sec or posedge reset_2)
        if(reset_2)
            hour_counter <= 5'h0;
        else 
            if(min_counter == 59 && sec_counter == 59)
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

