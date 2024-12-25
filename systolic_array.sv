module systolic_array #(
    parameter Q = 10,
    parameter N = 32,
    parameter M = 6  // Number of rows and columns
)
(
    input logic clk,
    input logic rst,
    input logic en,
    input logic signed [N-1:0] x_in [0:M-1],  // Input array for the first row (M-1 because we need to have a row for the first column)
    input logic signed [N-1:0] y_in [0:M-1],  // Input array for the first column (M-1 because we need to have a row for the first column)
    output logic signed [N-1:0] x_out [0:M-1],  // Output array for the first row (M-1 because we need to have a row for the first column)
    output logic signed [N-1:0] y_out [0:M-1],  // Output array for the first column (M-1 because we need to have a row for the first column)
    output logic signed [N-1:0] acc_sum [0:M-1][0:M-1]  // Output accumulatizon sums (M-1 because we need to have a row for the first column)
);

    logic signed [N-1:0] x_internal [0:M-1][0:M-1];
    logic signed [N-1:0] y_internal [0:M-1][0:M-1];

    // Shift register arrays for input skewing
    logic signed [N-1:0] x_shift_regs [0:M-1][0:M-1];  // Each row i has i shift registers
    logic signed [N-1:0] y_shift_regs [0:M-1][0:M-1];  // Each column j has j shift registers

    // Generate shift registers for row inputs
    genvar i, j;
    generate
        for (i = 0; i < M; i++) begin : row_shifts
            // Generate i shift registers for row i
            always_ff @(posedge clk or posedge rst) begin
                if (rst) begin
                    // Reset all shift registers in this row
                    for (int s = 0; s < i; s++) begin
                        x_shift_regs[i][s] <= '0;
                    end
                end else if (en) begin
                    // First shift register gets input directly
                    if (i > 0) begin  // Only rows after first need shift registers
                        x_shift_regs[i][0] <= x_in[i];
                        // Subsequent shift registers
                        for (int s = 1; s < i; s++) begin
                            x_shift_regs[i][s] <= x_shift_regs[i][s-1];
                        end
                    end
                end
            end
        end
    endgenerate

    // Generate shift registers for column inputs
    generate
        for (j = 0; j < M; j++) begin : col_shifts
            // Generate j shift registers for column j
            always_ff @(posedge clk or posedge rst) begin
                if (rst) begin
                    // Reset all shift registers in this column
                    for (int s = 0; s < j; s++) begin
                        y_shift_regs[j][s] <= '0;
                    end
                end else if (en) begin
                    // First shift register gets input directly
                    if (j > 0) begin  // Only columns after first need shift registers
                        y_shift_regs[j][0] <= y_in[j];
                        // Subsequent shift registers
                        for (int s = 1; s < j; s++) begin
                            y_shift_regs[j][s] <= y_shift_regs[j][s-1];
                        end
                    end
                end
            end
        end
    endgenerate

    generate
        for (i = 0; i < M; i = i + 1) begin : row_gen
            for (j = 0; j < M; j = j + 1) begin : col_gen
                processing_element #(Q, N) PE (
                    .clk(clk),
                    .rst(rst),
                    .en(en),
                    .x_in((j == 0) ? (i == 0 ? x_in[i] : x_shift_regs[i][i-1]) : x_internal[i][j-1]),
                    .y_in((i == 0) ? (j == 0 ? y_in[j] : y_shift_regs[j][j-1]) : y_internal[i-1][j]),
                    .x_out(x_internal[i][j]),
                    .y_out(y_internal[i][j]),
                    .acc_sum(acc_sum[i][j])
                );
            end
        end
    endgenerate

    generate
        for (i = 0; i < M; i = i + 1) begin : end_row_gen
            assign x_out[i] = x_internal[i][M-1];
            assign y_out[i] = y_internal[M-1][i];
        end
    endgenerate


endmodule: systolic_array
