module MAC_tb();

    logic clk, rst, en;
    logic [15:0] A, B;
    logic [15:0] out;

    MAC dut(.clk(clk), .rst(rst), .en(en), .A(A), .B(B), .out(out));

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // initial begin
    //     // $dumpfile("MAC_tb.vcd");
    //     // $dumpvars(0, MAC_tb);

    //     #10 rst = 1;
    //     #10 rst = 0;

    //     #10 en = 1;
    //     #10 en = 0;

endmodule: MAC_tb