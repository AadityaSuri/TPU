module MMU();

    localparam Q = 0;
    localparam N = 32;
    localparam M = 6;

    logic clk, rst, en;
    logic signed [N-1:0] x_in [0:M-1], y_in [0:M-1], x_out [0:M-1], y_out [0:M-1];
    logic signed [N-1:0] acc_sum [0:M-1][0:M-1];

    systolic_array #(Q, N, M) systolic_array_inst (
        .clk(clk),
        .rst(rst),
        .en(en),
        .x_in(x_in),
        .y_in(y_in),
        .x_out(x_out),
        .y_out(y_out),
        .acc_sum(acc_sum)
    );

endmodule: MMU