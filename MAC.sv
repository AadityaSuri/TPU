module MAC # (
    parameter Q = 10,
    parameter N = 32
)

(
    input logic clk,
    input logic rst,
    input logic en,
    input logic signed [N-1:0] A, // 16-bit signed fixed-point number
    input logic signed [N-1:0] B, // 16-bit signed fixed-point number
    output logic signed [N-1:0] out, // 32-bit signed fixed-point accumulator
    output logic ovr
);
    
    logic signed [N-1:0] acc_sum;
    logic signed [N-1:0] product;

    qmult #(Q, N) mult(
        .i_multiplicand(A),
        .i_multiplier(B),
        .o_result(product),
        .ovr(ovr)
    );

    qadd #(Q, N) add(
        .a(out),
        .b(product),
        .c(acc_sum)
    );

    always_ff @ (posedge clk or posedge rst) begin
        if (rst) begin
            out <= 32'sd0;
        end else begin
            out <= en ? acc_sum : out;
        end
    end

endmodule: MAC
