`timescale 1ns/1ps

module subc_divide(
    input  logic         clk,
    input  logic         rst,

    // Handshake for inputs
    input  logic         invalid,
    output logic         inready,

    // Inputs
    input  logic [31:0]  a,
    input  logic [31:0]  b,
    input  logic [5:0]   nbits,     // runtime number of iterations (0–32)

    // Handshake for outputs
    input  logic         outready,
    output logic         outvalid,

    // Output
    output logic [31:0]  z
);

    // Internal registers
    logic [31:0] a_reg, b_reg;
    logic [31:0] z_reg;
    logic [5:0]  count;
    logic [5:0]  nbits_reg;

    typedef enum logic [1:0] {
        IDLE,
        RUN,
        DONE
    } state_t;

    state_t state, next_state;

    // State register (sequential logic)
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (combinational)
    always_comb begin
        next_state = state;
        case (state)
            IDLE: begin
                if (invalid && inready) begin
                    next_state = RUN;
                end
            end
            RUN: begin
                if (count == nbits_reg) begin
                    next_state = DONE;
                end
            end
            DONE: begin
                if (outready && outvalid) begin
                    next_state = IDLE;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Datapath (sequential logic)
    always_ff @(posedge clk) begin
        if (rst) begin
            a_reg <= 32'b0;
            b_reg <= 32'b0;
            z_reg <= 32'b0;
            count <= 6'b0;
            nbits_reg <= 6'b0;
        end else begin
            case (state)
                IDLE: begin
                    // 使用 next_state 来判断，确保数据加载和状态跳转强绑定
                    // 只要状态机决定下一拍去 RUN，就必须在这个时钟沿把数据读进来
                    if (next_state == RUN) begin
                        // Load inputs and initialize
                        a_reg <= a;
                        b_reg <= b;
                        nbits_reg <= nbits;
                        z_reg <= 32'b0;
                        count <= 6'b0;
                    end
                end
                RUN: begin
                    if (count < nbits_reg) begin
                        // Shift a left by 1 and check if  >= b
                        if ({a_reg[30:0], 1'b0} >= b_reg) begin
                            a_reg <= {a_reg[30:0], 1'b0} - b_reg;
                            z_reg <= {z_reg[30:0], 1'b1};
                        end else begin
                            a_reg <= {a_reg[30:0], 1'b0};
                            z_reg <= {z_reg[30:0], 1'b0};
                        end
                        
                        count <= count + 1;
                    end
                end
                DONE: begin
                    // Hold values - don't change anything
                end
            endcase
        end
    end

    // Output logic
    assign inready = (state == IDLE);
    assign outvalid = (state == DONE);
    assign z = z_reg;

endmodule