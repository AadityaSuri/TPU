`timescale 1 ps / 1 ps

module systolic_array_tb();

    parameter CLK_PERIOD = 10;
    parameter RESET_DURATION = 10;
    parameter RUN_DURATION = 10;

    localparam Q = 10;
    localparam N = 32;
    localparam M = 3;

    // define signals
    logic clk, rst, en;
    logic signed [N-1:0] x_in [M-1:0], y_in [M-1:0];
    logic signed [N-1:0] acc_sum [M-1:0][M-1:0];

    // instantiate the DUT
    systolic_array #(Q, N, M) dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .x_in(x_in),
        .y_in(y_in),
        .acc_sum(acc_sum)
    );

    // generate clock
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test vectors
    logic signed [N-1:0] matrix_a [0:2][0:4] = '{
        '{32'd0, 32'd0, 32'd1, 32'd2, 32'd3},
        '{32'd0, 32'd4, 32'd5, 32'd6, 32'd0},
        '{32'd7, 32'd8, 32'd9, 32'd0, 32'd0}
    };


    logic signed [N-1:0] matrix_b [0:4][0:2] = '{
        '{32'd0, 32'd0, 32'd7},
        '{32'd0, 32'd8, 32'd4},
        '{32'd9, 32'd5, 32'd1},
        '{32'd6, 32'd2, 32'd0},
        '{32'd3, 32'd0, 32'd0}
    };

    initial begin

        rst = 1;
        #RESET_DURATION
        rst = 0;

        en = 0;
        #RUN_DURATION
        en = 1;

        for (int i = 0; i < 5; i = i + 1) begin
            x_in[i] = matrix_a[i][4];
            y_in[i] = matrix_b[4][i];
        end

        en = 0;
        #RUN_DURATION
        en = 1;
    end

endmodule: systolic_array_tb