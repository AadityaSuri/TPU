`timescale 1 ps / 1 ps

module controller_tb();

    parameter CLK_PERIOD = 10;
    parameter RESET_DURATION = 10;
    // parameter RUN_DURATION = 10;

    logic clk, rst;
    logic done, enable_next;
    logic [1:0] addr;

    // logic [1:0] r0_addr, r1_addr, r2_addr, r3_addr;
    // logic [1:0] c0_addr, c1_addr, c2_addr, c3_addr;
    logic [31:0] data;
    logic [31:0] r0, r1, r2, r3, c0, c1, c2, c3;
    logic wren;


    controller #(.M(4)) dut (
        .clk(clk),
        .rst(rst),
        .done(done),
        .enable_next(enable_next),
        .addr(addr)
    );

    ar0 ar0_mem (
        .clock(clk),
        .address(addr),
        .data(data),
        .wren(wren),
        .q(r0)
    );

    ar1 ar1_mem (
        .clock(clk),
        .address(addr),
        .data(data),
        .wren(wren),
        .q(r1)
    );

    ar2 ar2_mem (
        .clock(clk),
        .address(addr),
        .data(data),
        .wren(wren),
        .q(r2)
    );

    ar3 ar3_mem (
        .clock(clk),
        .address(addr),
        .data(data),
        .wren(wren),
        .q(r3)
    );

    bc0 bc0_mem (
        .clock(clk),
        .address(addr),
        .data(data),
        .wren(wren),
        .q(c0)
    );

    bc1 bc1_mem (
        .clock(clk),
        .address(addr),
        .data(data),
        .wren(wren),
        .q(c1)
    );

    bc2 bc2_mem (
        .clock(clk),
        .address(addr),
        .data(data),
        .wren(wren),
        .q(c2)
    );

    bc3 bc3_mem (
        .clock(clk),
        .address(addr),
        .data(data),
        .wren(wren),
        .q(c3)
    );




    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        $readmemh("ar0.memh", ar0_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("ar1.memh", ar1_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("ar2.memh", ar2_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("ar3.memh", ar3_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("bc0.memh", bc0_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("bc1.memh", bc1_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("bc2.memh", bc2_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("bc3.memh", bc3_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);

        rst = 1;
        #RESET_DURATION
        rst = 0;
    end

endmodule: controller_tb