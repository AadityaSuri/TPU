`timescale 1 ps / 1 ps
  
    
module MAC_tb();

    parameter CLK_PERIOD = 10;
    parameter RESET_DURATION = 10;
    parameter RUN_DURATION = 10;

    // define signals
    logic clk, rst, en;
    logic signed [31:0] A, B;
    logic signed [31:0] out;

    // instantiate the DUT
    MAC dut (.clk(clk), .rst(rst), .en(en), .A(A), .B(B), .out(out));

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

    task check_output(input signed [31:0] expected_value);
        if (out !== expected_value) begin
            $display("Test failed: Expected %d, got %d at time %t", expected_value, out, $time);
        end else begin
            $display("Test passed: Expected %d, got %d at time %t", expected_value, out, $time);
        end
    endtask

    task run_mac(input logic [31:0] in_A, input logic [31:0] in_B, input logic signed [31:0] expected_value);
        A = in_A;
        B = in_B;

        en = 0;
        #RUN_DURATION
        en = 1;
        #RUN_DURATION
        en = 0;
        #RUN_DURATION

        check_output(expected_value);
    endtask: run_mac


    initial begin
        apply_reset();
        check_output(32'd0);
        run_mac({1'b0, 21'd1, 10'd0}, {1'b0, 21'd2, 10'd0}, {1'b0, 21'd2, 10'd0});
        run_mac({1'b0, 21'd3, 10'd0}, {1'b0, 21'd2, 10'd0}, {1'b0, 21'd8, 10'd0});
        run_mac({1'b0, 21'd5, 10'd0}, {1'b0, 21'd5, 10'd0}, {1'b0, 21'd33, 10'd0});

        apply_reset();
        check_output(32'd0);
        run_mac({1'b0, 21'd5, 10'd0}, {1'b0, 21'd8, 10'd0}, {1'b0, 21'd40, 10'd0});
        run_mac({1'b0, 21'd2, 10'd0}, {1'b0, 21'd3, 10'd0}, {1'b0, 21'd46, 10'd0});
        run_mac({1'b1, 21'd3, 10'd0}, {1'b0, 21'd4, 10'd0}, {1'b0, 21'd34, 10'd0});
        run_mac({1'b1, 21'd2, 10'd0}, {1'b1, 21'd2, 10'd0}, {1'b0, 21'd38, 10'd0});

        apply_reset();
        check_output(32'd0);
        run_mac({1'b1, 21'd1, 10'd0}, {1'b1, 21'd1, 10'd0}, {1'b0, 21'd1, 10'd0});
        run_mac({1'b0, 21'd5, 10'd0}, {1'b1, 21'd8, 10'd0}, {1'b1, 21'd39, 10'd0});
        run_mac({1'b0, 21'd2, 10'd0}, {1'b1, 21'd3, 10'd0}, {1'b1, 21'd45, 10'd0});
        run_mac({1'b0, 21'd5, 10'd0}, {1'b0, 21'd10, 10'd0}, {1'b0, 21'd5, 10'd0});

        apply_reset();
        check_output(32'd0);
        run_mac({1'b0, 21'd0, 10'b1000_0000_00}, {1'b0, 21'd0, 10'b1000_0000_00}, {1'b0, 21'd0, 10'b0100_0000_00});  // 0.5 * 0.5 = 0.25 + 0 = 0.25
        run_mac({1'b0, 21'd0, 10'b0100_0000_00}, {1'b0, 21'd1, 10'b1000_0000_00}, {1'b0, 21'd0, 10'b1010_0000_00});  // 0.25 * 1.5 = 0.375 + 0.25 = 0.625
        run_mac({1'b1, 21'd5, 10'b0001_1000_00}, {1'b0, 21'd3, 10'b0100_0000_00}, {1'b1, 21'd15, 10'b1110_1110_00}); 
        run_mac({1'b1, 21'd2, 10'b0100_0000_00}, 32'd0, {1'b1, 21'd15, 10'b1110_1110_00});

        $finish;
    end

endmodule: MAC_tb