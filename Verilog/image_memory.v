module image_memory #(parameter MEM_SIZE = 1024)(
    input [9:0] address,
    output reg [7:0] pixel_data
);
    reg [7:0] memory [0:MEM_SIZE-1];

    initial begin
        $readmemh("image.mem", memory);
    end

    always @(*) begin
        pixel_data = memory[address];
    end
endmodule
