`define init 3'd0
`define next_addr 3'd1
`define wait 3'd2
`define enable_next 3'd3
`define done 3'd4

module controller #(
    parameter M = 4
    // parameter N = 32
)
(
    input logic clk,
    input logic rst,
    // input logic next_addr,
    output logic [$clog2(M) - 1:0] addr,
    output logic done,
    output logic enable_next
);

    logic [$clog2(M):0] i;
    logic [2:0] state;

    always @(posedge clk) begin
        if (rst) begin
            state <= `init;
        end else begin

            case (state)
                `init: begin
                    state <= `next_addr;
                    i <= 0;
                end
                `next_addr: begin
                    state <= `wait;
                end
                `wait: begin
                    state <= `enable_next;
                end
                `enable_next: begin
                    i = i + 1;
                    state <= i < M ? `next_addr : `done;
                end
                `done: begin
                    state <= `done;
                end
            endcase
        end
    end

    always_comb begin
        case (state)
            `init: begin
                done = 1;
                enable_next = 0;
                addr = '0;
            end
            `done: begin
                done = 1;
                enable_next = 0;
                addr = i;
            end
            `next_addr: begin
                done = 0;
                enable_next = 0;
                addr = i;
            end
            `wait: begin
                done = 0;
                enable_next = 0;
                addr = i;
            end
            `enable_next: begin
                done = 0;
                enable_next = 1;
                addr = i;
            end
            default: begin
                done = 0;
                enable_next = 0;
                addr = '0;
            end
        endcase
    end


endmodule: controller