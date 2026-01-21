`timescale 1ns/1ps

module tb_subc_divide;

    // DUT signals
    logic         clk;
    logic         rst;

    logic         invalid;
    logic         inready;

    logic [31:0]  a;
    logic [31:0]  b;
    logic [5:0]   nbits;

    logic         outready;
    logic         outvalid;

    logic [31:0]  z;

    logic [31:0]  atest, btest;
    logic [5:0]   nbitstest;

    // Instantiate DUT
    subc_divide dut (
        .clk(clk),
        .rst(rst),
        .invalid(invalid),
        .inready(inready),
        .a(a),
        .b(b),
        .nbits(nbits),
        .outready(outready),
        .outvalid(outvalid),
        .z(z)
    );

    // Clock generator
    always #5 clk = ~clk;

    real qhat, q;

    // CSV file name
    string fn = "../test_outputs/tv_python.csv";
    string fn_out = "../test_outputs/tv_sv.csv";
    
    // CSV reading variables
    integer file_handle;
    integer out_file_handle;
    integer scan_result;
    string header_line;
    integer line_num;
    logic [31:0] z_expected;
    real qhat_expected, error_expected;
    integer passed_expected;
    integer num_passed, num_failed;
    logic zcorrect, cycles_correct;
    integer nvals_correct, ncycles_correct;

    initial begin
        integer cycle_count;

        // Initialize
        clk      = 0;
        rst      = 1;
        invalid  = 0;
        outready = 0;
        a        = 0;
        b        = 0;
        nbits    = 0;
        num_passed = 0;
        num_failed = 0;
        nvals_correct = 0;
        ncycles_correct = 0;

        // Reset
        repeat (3) @(posedge clk);
        rst = 0;

        // Wait for inready
        @(posedge clk);
        wait (inready);

        // Open CSV file
        file_handle = $fopen(fn, "r");
        if (file_handle == 0) begin
            $display("ERROR: Could not open file %s", fn);
            $finish;
        end

        // Open output CSV file
        out_file_handle = $fopen(fn_out, "w");
        if (out_file_handle == 0) begin
            $display("ERROR: Could not open output file %s", fn_out);
            $fclose(file_handle);
            $finish;
        end
        
        // Write output CSV header
        $fdisplay(out_file_handle, "a,b,nbits,z_exp,z,passed,cycles,cycles_correct");

        // Read and skip header line
        scan_result = $fgets(header_line, file_handle);
        $display("Reading test vectors from: %s", fn);
        $display("Writing results to: %s", fn_out);
        $display("Header: %s", header_line);

        line_num = 0;
        
        // Read test vectors from CSV file
        while (!$feof(file_handle)) begin
            // Read CSV line: a,b,nbits,z,qhat,error,passed
            scan_result = $fscanf(file_handle, "%d,%d,%d,%d,%f,%f,%d\n", 
                                  atest, btest, nbitstest, z_expected, 
                                  qhat_expected, error_expected, passed_expected);

           if (scan_result != 7) begin
                // End of file or incomplete line
                break;
            end
            
            line_num++;
            
            // Drive inputs
            a     = atest;
            b     = btest;
            nbits = nbitstest;

            invalid = 1;
            @(posedge clk);
            invalid = 0;

            // Wait for outvalid
            cycle_count = 0;
            while (!outvalid) begin
                @(posedge clk);
                cycle_count = cycle_count + 1;
            end 

            // Assert outready for one cycle
            outready = 1;
            @(posedge clk);
            outready = 0;

            // Count cycles until outvalid
            zcorrect = (z == z_expected);
            cycles_correct = (cycle_count <= nbitstest + 2); // Allow some margin
            
            if (zcorrect) nvals_correct++;
            if (cycles_correct) ncycles_correct++;
            
            // Write result to output CSV file
            // Format: a, b, nbits, z_exp, z, passed, cycles
            $fdisplay(out_file_handle, "%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d", 
                      atest, btest, nbitstest, z_expected, z, zcorrect,  cycle_count, cycles_correct);
            
            // Wait for inready before next test
            wait (inready);
        end

        $fclose(file_handle);
        $fclose(out_file_handle);

        $display("\n=== Test Summary ===");
        $display("Total tests: %0d", line_num);
        $display("Values correct: %0d", nvals_correct);
        $display("Total within timing range: %0d", ncycles_correct);

        #20;
        $finish;
    end


endmodule