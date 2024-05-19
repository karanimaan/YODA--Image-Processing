`define ROW 256
`define COL 256
`define WIDTH 8

module grayscale(
    input wire clk,
    input wire rst,
    input [`ROW*`WIDTH*3-1:0] row_in,
    output reg [`ROW*`WIDTH*3-1:0] row_out
);

    integer i;
    reg [7:0] red, green, blue;
    reg [15:0] gray;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            row_out <= 0;
        end else begin
            for (i = 0; i < `COL; i = i + 1) begin
                red   = row_in[24*i +: 8];
                green = row_in[24*i+8 +: 8];
                blue  = row_in[24*i+16 +: 8];
                gray  = (red * 299 + green * 587 + blue * 114) / 1000;
                row_out[8*i +: 8] = gray[7:0];
            end
        end
    end

endmodule
 
