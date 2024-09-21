`timescale 1 ps / 1 ps

module systolic_array_tb();

    parameter CLK_PERIOD = 10;
    parameter RESET_DURATION = 10;
    parameter RUN_DURATION = 10;

    localparam Q = 10;
    localparam N = 32;
    localparam M = 6;

    // define signals
    logic clk, rst, en;
    logic signed [N-1:0] x_in [0:M-1], y_in [0:M-1], x_out [0:M-1], y_out [0:M-1];
    logic signed [N-1:0] acc_sum [0:M-1][0:M-1];

    // instantiate the DUT
    systolic_array #(Q, N, M) dut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .x_in(x_in),
        .y_in(y_in),
        .x_out(x_out),
        .y_out(y_out),
        .acc_sum(acc_sum)
    );

    // generate clock
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    task apply_reset;
        $display("Applying reset");

        rst = 1;    
        #RESET_DURATION
        rst = 0;
    endtask

    task enable;
        // en = 0;
        // #RUN_DURATION
        en = 1;
        #RUN_DURATION;
        en = 0;
        // #RUN_DURATION;
    endtask 

    task drive_matmult_step(
        input signed [N-1:0] matrix_a [0:M-1][0:2*M-2],
        input signed [N-1:0] matrix_b [0:2*M-2][0:M-1],
        input int j
    );
        for (int i = 0; i < M; i = i + 1) begin
            x_in[i] = matrix_a[i][j];
            y_in[i] = matrix_b[j][i];
        end
        enable();
    endtask

    logic signed [N-1:0] matrix_a [0:M-1][0:2*M-2] = '{
    '{32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd7, 32'd8, 32'd11, 32'd0, 32'd1},
    '{32'd0, 32'd0, 32'd0, 32'd0, 32'd17, 32'd9, 32'd19, 32'd4, 32'd5, 32'd18, 32'd0},
    '{32'd0, 32'd0, 32'd0, 32'd1, 32'd2, 32'd15, 32'd11, 32'd5, 32'd2, 32'd0, 32'd0},
    '{32'd0, 32'd0, 32'd18, 32'd18, 32'd3, 32'd16, 32'd11, 32'd1, 32'd0, 32'd0, 32'd0},
    '{32'd0, 32'd9, 32'd1, 32'd5, 32'd0, 32'd10, 32'd17, 32'd0, 32'd0, 32'd0, 32'd0},
    '{32'd3, 32'd3, 32'd6, 32'd19, 32'd5, 32'd10, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0}
};

    logic signed [N-1:0] matrix_b [0:2*M-2][0:M-1] = '{
    '{32'd0, 32'd0, 32'd0, 32'd0, 32'd0, 32'd1},
    '{32'd0, 32'd0, 32'd0, 32'd0, 32'd7, 32'd8},
    '{32'd0, 32'd0, 32'd0, 32'd11, 32'd7, 32'd11},
    '{32'd0, 32'd0, 32'd9, 32'd6, 32'd5, 32'd4},
    '{32'd0, 32'd12, 32'd3, 32'd6, 32'd1, 32'd5},
    '{32'd9, 32'd19, 32'd7, 32'd1, 32'd18, 32'd19},
    '{32'd10, 32'd15, 32'd16, 32'd14, 32'd9, 32'd0},
    '{32'd2, 32'd13, 32'd13, 32'd18, 32'd0, 32'd0},
    '{32'd14, 32'd4, 32'd0, 32'd0, 32'd0, 32'd0},
    '{32'd16, 32'd4, 32'd0, 32'd0, 32'd0, 32'd0},
    '{32'd5, 32'd0, 32'd0, 32'd0, 32'd0, 32'd0}
};




    // // Test vectors
    // logic signed [N-1:0] matrix_a [0:2][0:4] = '{
    //     '{32'd0, 32'd0, 32'd1, 32'd2, 32'd3},
    //     '{32'd0, 32'd4, 32'd5, 32'd6, 32'd0},
    //     '{32'd7, 32'd8, 32'd9, 32'd0, 32'd0}
    // };


    // logic signed [N-1:0] matrix_b [0:4][0:2] = '{ 
    //     '{32'd0, 32'd0, 32'd7},
    //     '{32'd0, 32'd8, 32'd4},
    //     '{32'd9, 32'd5, 32'd1},
    //     '{32'd6, 32'd2, 32'd0},
    //     '{32'd3, 32'd0, 32'd0}
    // };

    initial begin

        apply_reset();


       for (int i = 0; i < 20; i = i + 1) begin
            $display("Iteration %d", i);
            if (2 * M - 2 - i >= 0) begin               
                drive_matmult_step(matrix_a, matrix_b, 2 * M - 2 - i);
                if (2 * M - 2 - i == 0) begin
                    for (int j = 0; j < M; j = j + 1) begin
                        x_in[j] = 0;
                        y_in[j] = 0;
                    end
                end
            end else begin
                enable();
            end
        end



        #RUN_DURATION
        apply_reset();
    


    end

endmodule: systolic_array_tb