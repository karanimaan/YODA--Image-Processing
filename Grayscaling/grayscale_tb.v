`include "grayscale.v"

`define ROW 256
`define COL 256
`define WIDTH 8
`define IN_FILE_NAME  "balloons.raw"
`define OUT_FILE_NAME "balloonsgrayraw.raw"

module test_rgb_to_grayscale;

    // Testbench signals
    reg [`ROW*`WIDTH*3-1:0] row_in;
    reg CLK;
    reg SET;
    reg RST;
    wire [`ROW*`WIDTH-1:0] row_out;
    
    //---------------------------------------------------------------------
    integer file_in, file_out, i, j;
    reg [0:23*`COL-1] r24;
    //reg [0:3*`COL*`ROW-1] data_in;
    reg [0:1572863] data_in
    reg [`ROW*`width*3-1:0] data_out;
    
    // Instantiate the RGB to Grayscale Converter
    grayscale grayscale_UUT (
        .clk(CLK),
        .rst(RST),
        .row_in(row_in),
        .row_out(row_out)
    );

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
        row_in = data_in[0:6143];
        RST = 1'b1;
        #5;
        SET = 1'b1;

        row_in = data_in[6144:12287];	//second row
        RST = 1'b1;
        SET = 1'b1;
        
        // Process each row of the image
        for (i = 0; i < `ROW; i = i + 1) begin
            SET =  1'b1;
            // Load the input row
            //row_in = data_in[i*3*`COL*8 +: 3*`COL*8];
            row_in = data_in[12288+6144*i +:6144];            
            // Wait for the clock edge
            #10;
            RST =  1'b1; 
            // Capture the output row
            //data_out[i*`COL*8 +: `COL*8] = row_out;
            data_out = row_out;
            for (j = 0; j < `COL; j = j + 1) begin
                r24 = data_out[6120-24*j +:24];
                $fwrite(file_out, "%c", data_out[j*`COL*8 + i*8 +: 8]);
            end
        end

        // Write the output data to the file
        //for (j = 0; j < `ROW; j = j + 1) begin
            //for (i = 0; i < `COL; i = i + 1) begin
                //$fwrite(file_out, "%c", data_out[j*`COL*8 + i*8 +: 8]);
            //end
        //end

        // Close the files
        $fclose(file_in);
        $fclose(file_out);

        // End the simulation
        $stop;
    end

endmodule
 
