    module MAC_tb();

        parameter CLK_PERIOD = 10;
        parameter RESET_DURATION = 10;
        parameter RUN_DURATION = 10;

        // define signals
        logic clk, rst, en;
        logic signed [15:0] A, B;
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

        task check_output(input [31:0] expected_value);
            if (out !== expected_value) begin
                $display("Test failed: Expected %d, got %d at time %t", expected_value, out, $time);
            end else begin
                $display("Test passed: Expected %d, got %d at time %t", expected_value, out, $time);
            end
        endtask

        task run_mac(input logic [15:0] in_A, input logic [15:0] in_B, input logic [15:0] expected_value);
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
            check_output(16'd0);
            run_mac(16'd1, 16'd2, 32'd2);
            run_mac(16'd3, 16'd2, 32'd8);
            run_mac(16'd5, 16'd5, 32'd33);

            apply_reset();
            check_output(16'd0);
            run_mac(16'd5, 16'd8, 32'd40);
            run_mac(16'd2, 16'd3, 32'd46);
            run_mac(16'd4, -16'd3, 32'd34);
            run_mac(-16'd2, -16'd2, 32'd38);

            apply_reset();
            check_output(16'd0);
            run_mac(16'd1, -16'd1, -32'd1);
            run_mac(16'd0, 16'd5, -32'd1);
            run_mac(16'd4, -16'd5, -32'd21);
            run_mac(16'd10, 16'd5, 32'd29);

            $finish;
        end

    endmodule: MAC_tb