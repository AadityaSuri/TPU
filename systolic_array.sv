module systolic_array #(
    parameter Q = 10,
    parameter N = 32,
    parameter M = 8  // Number of rows and columns
)
(
    input logic clk,
    input logic rst,
    input logic en,
    input logic signed [N-1:0] x_in [M-1:0],  // Input array for the first row
    input logic signed [N-1:0] y_in [M-1:0],  // Input array for the first column
    output logic signed [N-1:0] acc_sum [M-1:0][M-1:0]  // Output accumulatizon sums
);

    logic signed [N-1:0] x_internal [0:M-1][0:M-1];
    logic signed [N-1:0] y_internal [0:M-1][0:M-1];

    genvar i, j;
    generate
        for (i = 0; i < M; i = i + 1) begin : row_gen
            for (j = 0; j < M; j = j + 1) begin : col_gen
                systolic_unit #(Q, N) PE (
                    .clk(clk),
                    .rst(rst),
                    .en(en),
                    .x_in((j == 0) ? x_in[i] : x_internal[i][j - 1]),
                    .y_in((i == 0) ? y_in[j] : y_internal[i - 1][j]),
                    .x_out(x_internal[i][j]),
                    .y_out(y_internal[i][j]),
                    .acc_sum(acc_sum[i][j])
                );
            end
        end
    endgenerate


endmodule: systolic_array
