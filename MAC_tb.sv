module MAC_tb();

    logic clk, rst, en;
    logic [15:0] A, B;
    logic [15:0] out;

    MAC dut(.clk(clk), .rst(rst), .en(en), .A(A), .B(B), .out(out));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        #10
        rst = 0;

        A = 16'd1;
        B = 16'd2;

        en = 0;
        #10
        en = 1;
        #10
        en = 0;

        A = 16'd3;
        B = 16'd2;

        en = 0;
        #10
        en = 1;
        #10
        en = 0;

        A = 16'd5;
        B = 16'd5;

        en = 0;
        #10
        en = 1;
        #10
        en = 0;

        rst = 1;
        #10
        rst = 0;

        A = 16'd5;
        B = 16'd8;

        en = 0;
        #10
        en = 1;
        #10
        en = 0;

    end

endmodule: MAC_tb