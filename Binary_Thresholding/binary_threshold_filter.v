 
`define ROW 256
`define COL 256
`define width 8
`define THRESHOLD 40 // Threshold value for binarization

module binary_threshold_filter(
    input     [`ROW*`width*3-1:0] row_in,  // input row each clock event. 6144 bit
    input                         CLK,     // Clock.
    input                         SET,     // Set 
    input                         RST,     // Reset
    output reg [`ROW*`width*3-1:0] row_out // output row fixed each clock event.        
);

// Register declarations
reg [`ROW*`width*3-1:0] line_1; // up.
reg [`ROW*`width*3-1:0] line_2; // middle.
reg [`ROW*`width*3-1:0] line_3; // down.
reg [2:0] state, next;          // state machine.
reg [`width-1:0] counter;       // counter

// State machine parameters
parameter [2:0]  ROW1 = 3'b000,
                 ROW2 = 3'b001,
                 ROW3 = 3'b010,
                 ROUTINE = 3'b011,
                 ROW256 = 3'b100,
                 SLEEP = 3'b101;

// State machine logic
always @(posedge CLK or negedge SET) begin
    if (SET == 1'b0) begin       // wait for set 
        counter <= 8'b00000000; 
        state <= ROW1; 
    end else begin
        state <= next;
    end
end

always @(state or negedge RST or row_in) begin
    case (state)
        ROW1: 
            begin
            line_1 = row_in;
            next = ROW2;
            end
        ROW2: 
            begin
            line_2 = row_in;
            next = ROW3;
            end
        ROW3: 
            begin
            row_out = apply_threshold(line_1, line_1, line_2);
            line_3 = row_in;
            counter = counter + 1'b1;
            next = ROUTINE;
            end
        ROUTINE: 
            begin
            row_out = apply_threshold(line_1, line_2, line_3);
            line_1 = line_2;
            line_2 = line_3;
            line_3 = row_in;
            counter = counter + 1'b1;
            if (counter == 8'b11111111)  //255
                next = ROW256;
            else
                next = ROUTINE;
            end
        ROW256: begin
            row_out = apply_threshold(line_2, line_3, line_3);
            next = SLEEP; // go sleep
        end
        SLEEP: begin
            if (RST == 1'b0) // wait for reset
                next = ROW1;
            else
                next = SLEEP; 
        end
    endcase
end

// Function to apply binary threshold
function [0:`ROW*`width*3-1] apply_threshold;
    input [0:`ROW*`width*3-1] line1;
    input [0:`ROW*`width*3-1] line2;
    input [0:`ROW*`width*3-1] line3;

    integer i;
    reg [7:0] r, g, b;
    reg [7:0] gray;

    begin
        for (i = 0; i < `COL; i = i + 1) begin
            r = line2[24*i +: 8];
            g = line2[24*i+8 +: 8];
            b = line2[24*i+16 +: 8];
            $display("R  = %d", r);
            $display("G  = %d", g);
            $display("B  = %d", b);
            // Convert to grayscale (simple average method)
            gray = (r + g + b) / 3;
            $display("Gray = %d", gray);
            // Apply threshold
            if (gray > `THRESHOLD) begin
                apply_threshold[24*i   +: 8] = 8'd255; // White
                apply_threshold[24*i+8 +: 8] = 8'd255; // White
                apply_threshold[24*i+16 +: 8] = 8'd255; // White
            end else begin
                apply_threshold[24*i   +: 8] = 8'hFF; // Black
                apply_threshold[24*i+8 +: 8] = 8'hFF; // Black
                apply_threshold[24*i+16 +: 8] = 8'hFF; // Black
            end
        end
    end
endfunction

endmodule
