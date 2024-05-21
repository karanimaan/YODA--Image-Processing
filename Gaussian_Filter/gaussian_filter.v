`define ROW 256
`define COL 256
`define WIDTH 8

module gaussian_filter(
    input wire clk,
    input wire rst,
    input wire [`ROW*`WIDTH*3-1:0] row_in,
    output reg [`ROW*`WIDTH*3-1:0] row_out
);

    reg [`WIDTH-1:0] gaussKernel[2:0][2:0];

    initial begin
        gaussKernel[0][0] = 8'd3; gaussKernel[0][1] = 8'd21; gaussKernel[0][2] = 8'd3;
        gaussKernel[1][0] = 8'd21; gaussKernel[1][1] = 8'd158; gaussKernel[1][2] = 8'd21;
        gaussKernel[2][0] = 8'd3; gaussKernel[2][1] = 8'd21; gaussKernel[2][2] = 8'd3;
    end

    reg [`WIDTH-1:0] line_buf[2:0][`COL-1:0][2:0];
    integer i, j, k, l;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 3; i = i + 1) begin
                for (j = 0; j < `COL; j = j + 1) begin
                    for (k = 0; k < 3; k = k + 1) begin
                        line_buf[i][j][k] <= 0;
                    end
                end
            end
        end else begin
            for (i = 0; i < `ROW; i = i + 1) begin
                for (j = 0; j < `COL; j = j + 1) begin
                    if (j == 0) begin
                        line_buf[2][j][0] <= row_in[8*j +: 8];
                    end else begin
                        line_buf[2][j][0] <= line_buf[2][j-1][0];
                        line_buf[2][j][1] <= line_buf[2][j-1][1];
                        line_buf[2][j][2] <= row_in[8*j +: 8];
                    end
                    if (i > 0) begin
                        line_buf[1][j][0] <= line_buf[2][j][0];
                        line_buf[1][j][1] <= line_buf[2][j][1];
                        line_buf[1][j][2] <= line_buf[2][j][2];
                    end
                    if (i > 1) begin
                        line_buf[0][j][0] <= line_buf[1][j][0];
                        line_buf[0][j][1] <= line_buf[1][j][1];
                        line_buf[0][j][2] <= line_buf[1][j][2];
                    end
                end
            end
        end
    end

    always @* begin
        for (i = 0; i < `ROW; i = i + 1) begin
            for (j = 0; j < `COL; j = j + 1) begin
                reg [15:0] sum;
                sum = 0;
                for (k = 0; k < 3; k = k + 1) begin
                    for (l = 0; l < 3; l = l + 1) begin
                        sum = sum + line_buf[k][j][l] * gaussKernel[k][l];
                    end
                end
                row_out[8*j +: 8] = sum >> 4;  // Scale down the result
            end
        end
    end

endmodule
 
