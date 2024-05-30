`timescale 1 ps / 1 ps


module PE_tb();

    parameter CLK_PERIOD = 10;
    parameter RESET_DURATION = 10;
    parameter RUN_DURATION = 10;

    localparam Q = 10;
    localparam N = 32;

    // define signals
    logic clk, rst, en;
    logic signed [N-1:0] x_in, y_in;
    logic signed [N-1:0] x_out, y_out;
    logic signed [N-1:0] acc_sum;
    
    // instantiate the DUT
    processing_element #(Q, N) dut (
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
    endtask: apply_reset

    task check_output(input signed [N-1:0] expected_value);
        if (acc_sum !== expected_value) begin
            $display("Test failed: Expected %d, got %d at time %t", expected_value, acc_sum, $time);
        end else begin
            $display("Test passed: Expected %d, got %d at time %t", expected_value, acc_sum, $time);
        end
    endtask

    task PE_step(input logic [N-1:0] x_in_, input logic [N-1:0] y_in_, input logic signed [N-1:0] expected_value);
        x_in = x_in_;
        y_in = y_in_;

        en = 0;
        #RUN_DURATION
        en = 1;
        #RUN_DURATION
        en = 0;
        #RUN_DURATION
        check_output(expected_value);

        if (x_out !== x_in_) begin
            $display("Test failed: Expected %d, got %d at time %t", x_in_, x_out, $time);
        end 

        if (y_out !== y_in_) begin
            $display("Test failed: Expected %d, got %d at time %t", y_in_, y_out, $time);
        end
    endtask

    initial begin
        apply_reset();
        check_output(32'd0);
        PE_step({1'b0, 21'd1, 10'd0}, {1'b0, 21'd2, 10'd0}, {1'b0, 21'd2, 10'd0});
        PE_step({1'b0, 21'd3, 10'd0}, {1'b0, 21'd2, 10'd0}, {1'b0, 21'd8, 10'd0});
        PE_step({1'b0, 21'd5, 10'd0}, {1'b0, 21'd5, 10'd0}, {1'b0, 21'd33, 10'd0});
        PE_step({1'b0, 21'd7, 10'd0}, {1'b0, 21'd4, 10'd0}, {1'b0, 21'd61, 10'd0});

        apply_reset();
        check_output(32'd0);
        PE_step({1'b0, 21'd5, 10'd0}, {1'b0, 21'd8, 10'd0}, {1'b0, 21'd40, 10'd0});
        PE_step({1'b0, 21'd2, 10'd0}, {1'b0, 21'd3, 10'd0}, {1'b0, 21'd46, 10'd0});
        PE_step({1'b1, 21'd3, 10'd0}, {1'b0, 21'd4, 10'd0}, {1'b0, 21'd34, 10'd0});
        PE_step({1'b1, 21'd2, 10'd0}, {1'b1, 21'd2, 10'd0}, {1'b0, 21'd38, 10'd0});

        apply_reset();
        check_output(32'd0);
        PE_step({1'b1, 21'd1, 10'd0}, {1'b1, 21'd1, 10'd0}, {1'b0, 21'd1, 10'd0});
        PE_step({1'b0, 21'd5, 10'd0}, {1'b1, 21'd8, 10'd0}, {1'b1, 21'd39, 10'd0});
        PE_step({1'b0, 21'd2, 10'd0}, {1'b1, 21'd3, 10'd0}, {1'b1, 21'd45, 10'd0});
        PE_step({1'b0, 21'd5, 10'd0}, {1'b0, 21'd10, 10'd0}, {1'b0, 21'd5, 10'd0});

        apply_reset();
        check_output(32'd0);
        PE_step({1'b0, 21'd0, 10'b1000_0000_00}, {1'b0, 21'd0, 10'b1000_0000_00}, {1'b0, 21'd0, 10'b0100_0000_00});  // 0.5 * 0.5 = 0.25 + 0 = 0.25
        PE_step({1'b0, 21'd0, 10'b0100_0000_00}, {1'b0, 21'd1, 10'b1000_0000_00}, {1'b0, 21'd0, 10'b1010_0000_00});  // 0.25 * 1.5 = 0.375 + 0.25 = 0.625
        PE_step({1'b1, 21'd5, 10'b0001_1000_00}, {1'b0, 21'd3, 10'b0100_0000_00}, {1'b1, 21'd15, 10'b1110_1110_00}); 
        PE_step({1'b1, 21'd2, 10'b0100_0000_00}, 32'd0, {1'b1, 21'd15, 10'b1110_1110_00});

        $finish;
    end

endmodule: PE_tb