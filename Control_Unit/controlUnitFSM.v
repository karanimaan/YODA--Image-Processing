module ControlUnitFSM (
    input wire reset,
    input wire enable,
    input wire clk,
    output reg [ADDR_WIDTH-1:0] bram_addr,
    output reg transfer_data,
    output reg start_convolution,
    output reg write_bram4,
    output reg start_nsm,
    output reg start_thresholding
);
    // Define the state encoding
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        READ_ROW = 3'b001,
        PROCESS_ROW = 3'b010,
        WRITE_ROW = 3'b011,
        NSM = 3'b100,
        THRESHOLDING = 3'b101
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else if (enable)
            current_state <= next_state;
    end

    // Next state logic and output logic
    always @(*) begin
        // Default values
        next_state = current_state;
        bram_addr = 0;
        transfer_data = 0;
        start_convolution = 0;
        write_bram4 = 0;
        start_nsm = 0;
        start_thresholding = 0;

        case (current_state)
            IDLE: begin
                if (enable)
                    next_state = READ_ROW;
            end

            READ_ROW: begin
                bram_addr = // Address logic for reading row
                transfer_data = 1;
                next_state = PROCESS_ROW;
            end

            PROCESS_ROW: begin
                start_convolution = 1;
                next_state = WRITE_ROW;
            end

            WRITE_ROW: begin
                bram_addr = // Address logic for writing row
                write_bram4 = 1;
                next_state = NSM;
            end

            NSM: begin
                start_nsm = 1;
                next_state = THRESHOLDING;
            end

            THRESHOLDING: begin
                start_thresholding = 1;
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule
