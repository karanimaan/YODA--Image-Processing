module GaussianFilter(
    input wire clk,
    input wire rst,
    input wire [7:0] mif_data_in,
    output reg [7:0] mif_data_out,
    output reg [7:0] mif_address_out,
    output reg mif_write_en_out,
    output reg mif_read_en_out
);

// Define Gaussian kernel coefficients
localparam [2:0][2:0] kernel = '{ '{1, 2, 1}, '{2, 4, 2}, '{1, 2, 1} };

// Internal registers to store pixel values
reg [7:0] pixel[0:2][0:2];
reg [15:0] sum;

// Shift registers to hold pixel values
always @(posedge clk, posedge rst) begin
    if (rst) begin
        for (int i = 0; i < 3; i++) begin
            for (int j = 0; j < 3; j++) begin
                pixel[i][j] <= 8'h00;
            end
        end
    end else begin
        // Shift pixel values
        for (int i = 0; i < 2; i++) begin
            for (int j = 0; j < 3; j++) begin
                pixel[i][j] <= pixel[i + 1][j];
            end
        end
        // Load new pixel value
        pixel[2][0] <= pixel[1][0];
        pixel[2][1] <= pixel[1][1];
        pixel[2][2] <= mif_data_in;
    end
end

// Compute filtered pixel value
always @* begin
    sum = 16'd0;
    for (int i = 0; i < 3; i++) begin
        for (int j = 0; j < 3; j++) begin
            sum = sum + (pixel[i][j] * kernel[i][j]);
        end
    end
    mif_data_out = sum[11:4]; // Scale down the result
end

// Memory interface control signals
always @* begin
    mif_address_out = 0; // Address not used
    mif_write_en_out = 0; // Write disabled
    mif_read_en_out = 1; // Enable read
end

endmodule
