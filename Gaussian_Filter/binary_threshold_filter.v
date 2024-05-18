 
`define ROW 256
`define COL 256
`define WIDTH 8
`define THRESHOLD 128

module binary_threshold_filter(
    input wire clk,
    input wire rst,
    input wire [`ROW*`WIDTH*3-1:0] row_in,
    output reg [`ROW*`WIDTH*3-1:0] row_out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            row_out <= 0;
        end else begin
            for (integer i = 0; i < `ROW; i = i + 1) begin
                for (integer j = 0; j < `COL; j = j + 1) begin
                    if (row_in[`WIDTH*(i*`COL+j) +: `WIDTH] > `THRESHOLD) begin
                        row_out[`WIDTH*(i*`COL+j) +: `WIDTH] = 8'hFF;
                    end else begin
                        row_out[`WIDTH*(i*`COL+j) +: `WIDTH] = 8'h00;
                    end
                end
            end
        end
    end

endmodule
