module rle_compressor #(parameter MEM_SIZE = 1024)(
    input clk,
    input rst,
    input start,
    input [7:0] pixel_in,
    input valid_in,
    output reg [7:0] data_out,
    output reg [7:0] count_out,
    output reg valid_out,
    output reg done,
    output reg [15:0] original_count,
    output reg [15:0] compressed_count
);
    // Define state machine states
    localparam IDLE = 2'd0, RUN = 2'd1, OUTPUT = 2'd2, FLUSH = 2'd3;
    
    // Internal registers
    reg [7:0] current_pixel;
    reg [7:0] count;
    reg [1:0] state;
    reg first_pixel;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers
            state <= IDLE;
            data_out <= 0;
            count_out <= 0;
            valid_out <= 0;
            done <= 0;
            count <= 0;
            current_pixel <= 0;
            original_count <= 0;
            compressed_count <= 0;
            first_pixel <= 1;
        end else begin
            case (state)
                IDLE: begin
                    // Wait for start signal
                    if (start) begin
                        state <= RUN;
                        valid_out <= 0;
                        original_count <= 0;
                        compressed_count <= 0;
                        first_pixel <= 1;
                    end
                end
                
                RUN: begin
                    valid_out <= 0; // Default state for valid_out
                    
                    if (valid_in) begin
                        // Count original pixels
                        original_count <= original_count + 1;
                        
                        // First pixel handling
                        if (first_pixel) begin
                            current_pixel <= pixel_in;
                            count <= 1;
                            first_pixel <= 0;
                        end
                        // If pixel is the same, increment count
                        else if (pixel_in == current_pixel && count < 255) begin
                            count <= count + 1;
                        end
                        // If pixel changes or count maxes out, output the previous run
                        else begin
                            data_out <= current_pixel;
                            count_out <= count;
                            valid_out <= 1;
                            compressed_count <= compressed_count + 2; // Each RLE entry is 2 bytes (pixel + count)
                            
                            // Start new run with current pixel
                            current_pixel <= pixel_in;
                            count <= 1;
                            state <= OUTPUT;
                        end
                    end else begin
                        // If no more valid input and we have pixels to flush
                        if (!first_pixel) begin
                            state <= FLUSH;
                        end
                    end
                end
                
                OUTPUT: begin
                    // One cycle to output the data
                    valid_out <= 0;
                    state <= RUN;
                end
                
                FLUSH: begin
                    // Output the final run
                    data_out <= current_pixel;
                    count_out <= count;
                    valid_out <= 1;
                    compressed_count <= compressed_count + 2;
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule