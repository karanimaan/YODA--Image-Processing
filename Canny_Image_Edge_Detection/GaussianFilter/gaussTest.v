`include "smoothingFilter.v"
`timescale 1ns / 1ps

module gaussianFilter_tb;

    // Parameters
    parameter FILENAME_IN = "raw_out.raw";
    parameter FILENAME_OUT = "output_raw_file.txt";
    parameter NUM_SAMPLES = 100;

    // Inputs
    reg clk;
    reg rst;
    reg [7:0] raw_data_in;

    // Outputs
    wire [7:0] smoothed_data_out;

    // Instantiate the Unit Under Test (UUT)
    gaussianFilter gaussianFilter_inst (
        .clk(clk),
        .rst(rst),
        .raw_data_in(raw_data_in),
        .smoothed_data_out(smoothed_data_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Reset generation
    initial begin
        rst = 1;
        #10;
        rst = 0;
    end

    // Test case
    initial begin
        integer infile, outfile;
        integer i;
        reg [7:0] input_data;
        reg [7:0] output_data;

        // Open input raw file
        infile = $fopen(FILENAME_IN, "r");
        if (infile == 0) begin
            $display("Error: Could not open input file");
            $finish;
        end

        // Open output raw file
        outfile = $fopen(FILENAME_OUT, "w");
        if (outfile == 0) begin
            $display("Error: Could not open output file");
            $fclose(infile);
            $finish;
        end

        // Read input raw data, apply filter, and write output raw data
        for (i = 0; i < NUM_SAMPLES; i = i + 1) begin
            // Read input raw data
            if (!$feof(infile)) begin
//                 $fread(infile, input_data);
              $fread(input_data, infile);
                raw_data_in = input_data;
            end

            // Apply some delay to simulate clock cycles
            #10;

            // Write smoothed output data to output raw file
            output_data = smoothed_data_out;
            $fwrite(outfile, "%h\n", output_data);
        end

        // Close files
        $fclose(infile);
        $fclose(outfile);

        // Stop the simulation
        $finish;
    end

    initial begin
        $dumpfile("dump.vcd");
  	    $dumpvars;
    end
endmodule