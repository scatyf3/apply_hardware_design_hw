`timescale 1ns/1ps


/*********************************************
cubic_fixed:  Cubic polynomial module
 
Implements a monic cubic polynomial of the form:

    y = x^3 + a2*x^2 + a1*x + a0

All inputs and outputs are Q(WID, FBITS) fixed-point numbers.
Intermediates use wider accumulators of width WID_ACC 
to reduce overflow.  The width WID_ACC is automatically selected
to avoid overflow based on WID and FBITS.
**********************************************/
module cubic_fixed #(
    parameter int WID     = 16,   // total bit width
    parameter int FBITS   = 8     // fractional bits
)(
    input  logic                        clk,
    input  logic                        rst,

    // Inputs in Q(WID, FBITS)
    input  logic signed [WID-1:0]       x,
    input  logic signed [WID-1:0]       a0,
    input  logic signed [WID-1:0]       a1,
    input  logic signed [WID-1:0]       a2,

    // Output in Q(WID, FBITS)
    output logic signed [WID-1:0]       y
);

    // Sufficiently wide accuumlator width to avoid overflow before saturation
    localparam int WID_ACC1 = 2*WID - FBITS + 2;
    localparam int WID_ACC = (WID_ACC1 > 32) ? WID_ACC1 : 32; 
    

    // Stage 0 terms:  Q(WID, FBITS)
    logic signed [WID-1:0] x_s0, a0_s0, a1_s0, a2_s0;

    // Stage 1 registers  Q(WID_ACC, FBITS)
    logic signed [WID_ACC-1:0] a2_s1, x_s1, x2_s1, ax1_s1;

    // Stage 1 next values
    logic signed [WID_ACC-1:0] x2_s1_next, ax1_s1_next;

    // Stage 2 Combinational signals
    logic signed [WID_ACC-1:0] ax2, x3, yfull;

    // Saturation function
    function automatic logic signed [WID_ACC-1:0] sat (
        input logic signed [WID_ACC-1:0] in_val
    );
        localparam logic signed [WID_ACC-1:0] max_val = (1 << (WID - 1)) - 1;
        localparam logic signed [WID_ACC-1:0] min_val = -(1 << (WID - 1));
        begin
            if (in_val > max_val) begin
                sat = max_val;
            end else if (in_val < min_val) begin
                sat = min_val;
            end else begin
                sat = in_val;
            end
        end
    endfunction

    // Compute next values for stage 1 and stage 2 outputs
    always_comb begin

        // Stage 1 combinational logic: compute next values with saturation
        // x² = saturate((x * x) >> fbits, WID)
        x2_s1_next = sat((x_s0 * x_s0) >>> FBITS);
        
        // a1*x + a0 = saturate((a1 * x) >> fbits, WID) + a0
        ax1_s1_next = sat(sat((a1_s0 * x_s0) >>> FBITS) + a0_s0);
        

        // Stage 2: Compute cubic term and final outputs with saturation
        // x³ = saturate((x * x²) >> fbits, WID)
        x3 = sat((x_s1 * x2_s1) >>> FBITS);
        
        // a2*x² = saturate((a2 * x²) >> fbits, WID)
        ax2 = sat((a2_s1 * x2_s1) >>> FBITS);
        
        // y = saturate(x³ + a2*x² + (a1*x + a0), WID)
        yfull = sat(x3 + ax2 + ax1_s1);
        
        // Truncate to output width at end
        y = yfull[WID-1:0];

    end

    always_ff @(posedge clk) begin
        if (rst) begin
            // Reset pipeline registers
            x_s0   <= '0;
            a0_s0  <= '0;
            a1_s0  <= '0;
            a2_s0  <= '0;

            a2_s1  <= '0;
            x_s1   <= '0;
            x2_s1  <= '0;
            ax1_s1 <= '0;
        end else begin
            // Pipeline stages

            // Stage 0: Register inputs
            x_s0  <= x;
            a0_s0 <= a0;
            a1_s0 <= a1;
            a2_s0 <= a2;
            
            // Stage 1: Register computed values from combinational logic
            x_s1   <= x_s0;
            a2_s1  <= a2_s0;
            x2_s1  <= x2_s1_next;
            ax1_s1 <= ax1_s1_next;
        end
    end

    
    
endmodule