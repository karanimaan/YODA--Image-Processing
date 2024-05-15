module gaussianFilter(
    input wire clk,
    input wire rst,
    input wire [7:0] raw_data_in,
    output reg [7:0] smoothed_data_out
);

// Define Gaussian kernel coefficients
// reg gaussKernel[7:0] = '{'{8'd1, 8'd2, 8'd1}, '{8'd2, 8'd4, 8'd2}, '{8'd1, 8'd2, 8'd1}};
reg [7:0] gaussKernel[2:0][2:0];

// Internal registers to store pixel values
reg [7:0] pixel[0:2][0:2];
reg [15:0] sum;

// Initialize Gaussian kernel coefficients
initial begin
    gaussKernel[0][0] = 8'd1;
    gaussKernel[0][1] = 8'd2;
    gaussKernel[0][2] = 8'd1;
    gaussKernel[1][0] = 8'd1;
    gaussKernel[1][1] = 8'd2;
    gaussKernel[1][2] = 8'd1;
    gaussKernel[2][0] = 8'd1;
    gaussKernel[2][1] = 8'd2;
    gaussKernel[2][2] = 8'd1;
end

// Shift registers to hold pixel values
always @(posedge clk, posedge rst) begin
    if (rst) begin
        // gaussKernel  = {{8'd1, 8'd2, 8'd1}, {8'd2, 8'd4, 8'd2}, {8'd1, 8'd2, 8'd1}};
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
        pixel[2][2] <= raw_data_in;
    end
end

// Compute filtered pixel value
always @* begin
    sum = 16'd0;
    for (int i = 0; i < 3; i++) begin
        for (int j = 0; j < 3; j++) begin
            sum = sum + (pixel[i][j] * gaussKernel[i][j]);
        end
    end
    smoothed_data_out = sum[11:4]; // Scale down the result
end

endmodule
