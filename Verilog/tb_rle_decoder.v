module tb_rle_decoder;
    // Declare inputs and outputs
    reg clk;
    reg rst;
    reg start;
    reg [7:0] data_in;
    reg [7:0] count_in;
    reg valid_in;
    
    // Output signals from RLE decoder
    wire [7:0] pixel_out;
    wire valid_out;
    wire done;
    
    // Test data storage
    reg [7:0] input_pixels [0:3];  // Compressed pixel values
    reg [7:0] input_counts [0:3];  // Compressed run counts
    reg [7:0] expected_output [0:7]; // Expected decompressed pixels
    reg [7:0] actual_output [0:7];   // Actual decompressed pixels
    integer i, input_idx, output_idx;
    integer match_count;
    integer target_outputs;
    
    // Instantiate the decoder module
    rle_decoder #(.MEM_SIZE(1024)) rle_decoder_instance (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .count_in(count_in),
        .valid_in(valid_in),
        .pixel_out(pixel_out),
        .valid_out(valid_out),
        .done(done)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Monitor decoder outputs
    always @(posedge clk) begin
        if (valid_out && output_idx < 8) begin
            actual_output[output_idx] = pixel_out;
            $display("Decoded Output %d: Pixel=%h", output_idx, pixel_out);
            output_idx = output_idx + 1;
        end
    end
    
    // Initialize signals and start the simulation
    initial begin
        // Initialize inputs and test variables
        clk = 0;
        rst = 0;
        start = 0;
        data_in = 8'b0;
        count_in = 8'b0;
        valid_in = 0;
        input_idx = 0;
        output_idx = 0;
        match_count = 0;
        target_outputs = 0;
        
        // Initialize the compressed RLE data
        input_pixels[0] = 8'h01;
        input_counts[0] = 8'h02; // 2 of 01
        input_pixels[1] = 8'h02;
        input_counts[1] = 8'h03; // 3 of 02
        input_pixels[2] = 8'h03;
        input_counts[2] = 8'h01; // 1 of 03
        input_pixels[3] = 8'h04;
        input_counts[3] = 8'h02; // 2 of 04
        
        // Expected decompressed output
        expected_output[0] = 8'h01;
        expected_output[1] = 8'h01;
        expected_output[2] = 8'h02;
        expected_output[3] = 8'h02;
        expected_output[4] = 8'h02;
        expected_output[5] = 8'h03;
        expected_output[6] = 8'h04;
        expected_output[7] = 8'h04;
        
        // Apply reset
        rst = 1;
        #10;
        rst = 0;
        #10;
        
        // Start the decoder
        start = 1;
        
        // Feed the compressed data into the decoder one by one
        // First RLE pair
        data_in = input_pixels[0];
        count_in = input_counts[0];
        valid_in = 1;
        #10;
        valid_in = 0;
        target_outputs = input_counts[0];
        
        // Wait for processing to complete
        while (output_idx < target_outputs) #10;
        
        // Second RLE pair
        data_in = input_pixels[1];
        count_in = input_counts[1];
        valid_in = 1;
        #10;
        valid_in = 0;
        target_outputs = target_outputs + input_counts[1];
        
        // Wait for processing to complete
        while (output_idx < target_outputs) #10;
        
        // Third RLE pair
        data_in = input_pixels[2];
        count_in = input_counts[2];
        valid_in = 1;
        #10;
        valid_in = 0;
        target_outputs = target_outputs + input_counts[2];
        
        // Wait for processing to complete
        while (output_idx < target_outputs) #10;
        
        // Fourth RLE pair
        data_in = input_pixels[3];
        count_in = input_counts[3];
        valid_in = 1;
        #10;
        valid_in = 0;
        target_outputs = target_outputs + input_counts[3];
        
        // Wait for processing to complete
        while (output_idx < target_outputs) #10;
        
        // Wait a bit to allow processing to complete
        #50;
        
        // Verify decompression results
        $display("=== RLE Decompression Results ===");
        $display("Compressed size: 8 bytes (4 pixels × 2 bytes each)");
        $display("Decompressed size: 8 bytes");
        
        // Verify decompressed data
        $display("=== Decompressed Data Verification ===");
        match_count = 0;
        
        for (i = 0; i < 8; i = i + 1) begin
            if (actual_output[i] !== expected_output[i]) begin
                $display("Mismatch at index %d:", i);
                $display("  Expected: Pixel=%h", expected_output[i]);
                $display("  Actual:   Pixel=%h", actual_output[i]);
            end else begin
                $display("Match at index %d: Pixel=%h", i, actual_output[i]);
                match_count = match_count + 1;
            end
        end
        
        // Calculate accuracy
        $display("=== Accuracy ===");
        $display("Matches: %d out of 8", match_count);
        $display("Accuracy: %0.2f%%", (match_count * 100.0) / 8);
        
        $finish;
    end
endmodule