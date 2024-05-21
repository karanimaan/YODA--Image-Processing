`include "gaussian_filter.v"
`include "binary_threshold_filter.v"

`define ROW 256
`define COL 256
`define WIDTH 8
`define IN_FILE_NAME  "balloonsraw.raw"
`define OUT_FILE_NAME "balloonssmoothedraw.raw"

module test_combined_filter;

    // Testbench signals
    reg [`ROW*`WIDTH*3-1:0] row_in;
    reg CLK;
    reg SET;
    reg RST;
    wire [`ROW*`WIDTH*3-1:0] smoothed_row_out;
    wire [`ROW*`WIDTH*3-1:0] binary_row_out;

    // Instantiate the Gaussian Filter
    gaussian_filter gaussian_UUT (
        .clk(CLK),
        .rst(RST),
        .row_in(row_in),
        .row_out(smoothed_row_out)
    );

    // Instantiate the Binary Threshold Filter
    //binary_threshold_filter binary_UUT (
        //.clk(CLK),
        //.rst(RST),
        //.row_in(smoothed_row_out),
        //.row_out(binary_row_out)
    //);

    // Clock generation
    always begin
        CLK = 0;
        #5;
        CLK = 1;
        #5;
    end

    // Test case
    initial begin
        // File handling variables
        integer file_in, file_out, i, j;
        reg [0:24*`COL-1] r24;
        reg [0:3*`COL*`ROW-1] data_in;
        reg [0:3*`COL*`ROW-1] data_out;

        // Open the input and output files
        file_in  = $fopen(`IN_FILE_NAME, "rb");
        file_out = $fopen(`OUT_FILE_NAME, "wb");

        // Check if the input file was opened successfully
        if (file_in == 0) begin
            $display("Error: Could not open input file");
            $finish;
        end

        // Read data from the input file
        $fread(data_in, file_in);

        // Initialize signals
        SET = 1'b0;
        RST = 1'b1;
        #5;
        SET = 1'b1;

        // Process each row of the image
        for (i = 0; i < `ROW; i = i + 1) begin
            // Load the input row
            row_in = data_in[i*3*`COL*8 +: 3*`COL*8];
            
            // Wait for the clock edge
            #10;
            
            // Capture the output row
            data_out[i*3*`COL*8 +: 3*`COL*8] = smoothed_row_out;
        end

        // Write the output data to the file
        for (j = 0; j < `ROW; j = j + 1) begin
            for (i = 0; i < `COL; i = i + 1) begin
                r24 = data_out[j*3*`COL*8 + i*24 +: 24];
                $fwrite(file_out, "%c%c%c", r24[0:7], r24[8:15], r24[16:23]);
            end
        end

        // Close the files
        $fclose(file_in);
        $fclose(file_out);

        // End the simulation
        $stop;
    end

endmodule
