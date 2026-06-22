//============================================================
// TinyMAC Project
// Module: control_fsm_v2
// Description:
//   TinyMAC v2 control FSM for a two-stage pipelined datapath.
//   Generates product_en, result_en, and done.
//============================================================

`timescale 1ns/1ps

module control_fsm_v2 (
    input  logic clk,
    input  logic rst_n,
    input  logic start,

    output logic product_en,
    output logic result_en,
    output logic done
);

    typedef enum logic [1:0] {
        IDLE,
        ADD,
        DONE
    } state_t;

    state_t current_state;
    state_t next_state;

    // State register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next-state logic and output logic
    always_comb begin
        next_state = current_state;
        product_en = 1'b0;
        result_en  = 1'b0;
        done       = 1'b0;

        case (current_state)

            IDLE: begin
                if (start) begin
                    product_en = 1'b1;
                    next_state = ADD;
                end
            end

            ADD: begin
                result_en  = 1'b1;
                next_state = DONE;
            end

            DONE: begin
                done       = 1'b1;
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
                product_en = 1'b0;
                result_en  = 1'b0;
                done       = 1'b0;
            end

        endcase
    end

endmodule
