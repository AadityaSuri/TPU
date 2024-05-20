module systolic_unit #(
    parameter Q = 10,
    parameter N = 32
)
(
    input logic clk,
    input logic rst,
    input logic en,
    input logic signed [N-1:0] x_in,
    input logic signed [N-1:0] y_in,
    output logic signed [N-1:0] x_out,
    output logic signed [N-1:0] y_out,
    output logic signed [N-1:0] acc_sum
);

    MAC #(Q, N) mac(clk, rst, en, x_in, y_in, acc_sum);

    assign x_out = x_in;
    assign y_out = y_in;

endmodule: systolic_unit