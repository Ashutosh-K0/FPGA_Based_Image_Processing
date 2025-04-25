module rle_decoder #(parameter MEM_SIZE = 1024)(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    input [7:0] count_in,
    input valid_in,
    output reg [7:0] pixel_out,
    output reg valid_out,
    output reg done
);
    // Define state machine states
    localparam IDLE = 2'd0, OUTPUT = 2'd1, WAIT = 2'd2, DONE = 2'd3;
    
    // Internal registers
    reg [7:0] current_data;
    reg [7:0] remaining_count;
    reg [1:0] state;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers
            state <= IDLE;
            pixel_out <= 0;
            valid_out <= 0;
            done <= 0;
            remaining_count <= 0;
            current_data <= 0;
        end else begin
            case (state)
                IDLE: begin
                    // Reset signals
                    valid_out <= 0;
                    done <= 0;
                    
                    // Wait for start signal and valid input
                    if (start && valid_in) begin
                        current_data <= data_in;
                        remaining_count <= count_in;
                        state <= OUTPUT;
                    end
                end
                
                OUTPUT: begin
                    if (remaining_count > 0) begin
                        // Output the current pixel
                        pixel_out <= current_data;
                        valid_out <= 1;
                        remaining_count <= remaining_count - 1;
                    end else if (valid_in) begin
                        // Load next RLE pair
                        current_data <= data_in;
                        remaining_count <= count_in;
                        // Continue outputting pixels
                        pixel_out <= data_in;
                        valid_out <= 1;
                        remaining_count <= count_in - 1;
                    end else begin
                        // No more input data
                        valid_out <= 0;
                        state <= DONE;
                    end
                end
                
                WAIT: begin
                    // Wait state to handle transition between outputs
                    valid_out <= 0;
                    state <= OUTPUT;
                end
                
                DONE: begin
                    // Signal completion
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule