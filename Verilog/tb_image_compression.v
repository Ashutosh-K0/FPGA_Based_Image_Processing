module tb_image_compression;
    // Declare inputs and outputs
    reg clk;
    reg rst;
    reg start;
    reg [7:0] pixel_in;
    reg valid_in;
    
    // Output signals from RLE compressor
    wire [7:0] data_out;
    wire [7:0] count_out;
    wire valid_out;
    wire done;
    wire [15:0] original_count;
    wire [15:0] compressed_count;
    
    // Test data storage
    reg [7:0] input_data [0:7];
    reg [7:0] expected_pixels [0:3];
    reg [7:0] expected_counts [0:3];
    reg [7:0] actual_pixels [0:3];
    reg [7:0] actual_counts [0:3];
    integer i, output_idx;
    
    // Instantiate the compression module with correct port connections
    rle_compressor #(.MEM_SIZE(1024)) rle_compressor_instance (
        .clk(clk),
        .rst(rst),
        .start(start),
        .pixel_in(pixel_in),
        .valid_in(valid_in),
        .data_out(data_out),
        .count_out(count_out),
        .valid_out(valid_out),
        .done(done),
        .original_count(original_count),
        .compressed_count(compressed_count)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Monitor outputs when valid_out is asserted
    always @(posedge clk) begin
        if (valid_out && output_idx < 4) begin
            actual_pixels[output_idx] = data_out;
            actual_counts[output_idx] = count_out;
            $display("Output %d: Pixel=%h, Count=%d", output_idx, data_out, count_out);
            output_idx = output_idx + 1;
        end
    end
    
    // Initialize signals and start the simulation
    initial begin
        // Initialize inputs and test variables
        clk = 0;
        rst = 0;
        start = 0;
        pixel_in = 8'b0;
        valid_in = 0;
        output_idx = 0;
        
        // Initialize the input data for compression
        input_data[0] = 8'h01;
        input_data[1] = 8'h01;
        input_data[2] = 8'h02;
        input_data[3] = 8'h02;
        input_data[4] = 8'h02;
        input_data[5] = 8'h03;
        input_data[6] = 8'h04;
        input_data[7] = 8'h04;
        
        // Expected RLE output (pixel values and counts)
        expected_pixels[0] = 8'h01;
        expected_counts[0] = 8'h02; // 2 of 01
        expected_pixels[1] = 8'h02;
        expected_counts[1] = 8'h03; // 3 of 02
        expected_pixels[2] = 8'h03;
        expected_counts[2] = 8'h01; // 1 of 03
        expected_pixels[3] = 8'h04;
        expected_counts[3] = 8'h02; // 2 of 04
        
        // Apply reset
        rst = 1;
        #10;
        rst = 0;
        #10;
        
        // Assert start signal to begin compression
        start = 1;
        #10;
        start = 0;
        
        // Send data into the design - using valid_in to indicate valid data
        for (i = 0; i < 8; i = i + 1) begin
            pixel_in = input_data[i];
            valid_in = 1;
            #10; // Wait for one clock cycle with valid data
        end
        
        // Indicate end of input by deasserting valid_in
        valid_in = 0;
        
        // Wait a bit to allow processing to complete
        #50;
        
        // Compare compression results
        $display("=== RLE Compression Results ===");
        $display("Original data size: %d bytes", original_count);
        $display("Compressed data size: %d bytes", compressed_count);
        if (compressed_count > 0)
            $display("Compression ratio: %.2f", original_count*1.0/compressed_count);
        
        // Verify compressed data
        $display("=== Compressed Data Verification ===");
        for (i = 0; i < 4; i = i + 1) begin
            if (actual_pixels[i] !== expected_pixels[i] || actual_counts[i] !== expected_counts[i]) begin
                $display("Mismatch at index %d:", i);
                $display("  Expected: Pixel=%h, Count=%d", expected_pixels[i], expected_counts[i]);
                $display("  Actual:   Pixel=%h, Count=%d", actual_pixels[i], actual_counts[i]);
            end else begin
                $display("Match at index %d: Pixel=%h, Count=%d", i, actual_pixels[i], actual_counts[i]);
            end
        end
        
        $finish;
    end
endmodule