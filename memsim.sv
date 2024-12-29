`timescale 1ps/1ps

module memsim();

    logic clk;
    logic [1:0] r0_addr, r1_addr, r2_addr, r3_addr;
    logic [1:0] c0_addr, c1_addr, c2_addr, c3_addr;
    logic [31:0] data;
    logic [31:0] r0, r1, r2, r3, c0, c1, c2, c3;
    logic wren;

    ar0 ar0_mem (
        .clock(clk),
        .address(r0_addr),
        .data(data),
        .wren(wren),
        .q(r0)
    );

    ar1 ar1_mem (
        .clock(clk),
        .address(r1_addr),
        .data(data),
        .wren(wren),
        .q(r1)
    );

    ar2 ar2_mem (
        .clock(clk),
        .address(r2_addr),
        .data(data),
        .wren(wren),
        .q(r2)
    );

    ar3 ar3_mem (
        .clock(clk),
        .address(r3_addr),
        .data(data),
        .wren(wren),
        .q(r3)
    );

    bc0 bc0_mem (
        .clock(clk),
        .address(c0_addr),
        .data(data),
        .wren(wren),
        .q(c0)
    );

    bc1 bc1_mem (
        .clock(clk),
        .address(c1_addr),
        .data(data),
        .wren(wren),
        .q(c1)
    );

    bc2 bc2_mem (
        .clock(clk),
        .address(c2_addr),
        .data(data),
        .wren(wren),
        .q(c2)
    );

    bc3 bc3_mem (
        .clock(clk),
        .address(c3_addr),
        .data(data),
        .wren(wren),
        .q(c3)
    );

    initial begin
        clk = 0;
        forever #(1) clk = ~clk;
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

        #2
        r0_addr = 3;
        r1_addr = 3;
        r2_addr = 3;
        r3_addr = 3;
        c0_addr = 3;
        c1_addr = 3;
        c2_addr = 3;
        c3_addr = 3;
        
        #10
        r0_addr = 2;
        r1_addr = 2;
        r2_addr = 2;
        r3_addr = 2;
        c0_addr = 2;
        c1_addr = 2;
        c2_addr = 2;
        c3_addr = 2;

        #10
        r0_addr = 1;
        r1_addr = 1;
        r2_addr = 1;
        r3_addr = 1;
        c0_addr = 1;
        c1_addr = 1;
        c2_addr = 1;
        c3_addr = 1;

        #10
        r0_addr = 0;
        r1_addr = 0;
        r2_addr = 0;
        r3_addr = 0;
        c0_addr = 0;
        c1_addr = 0;
        c2_addr = 0;
        c3_addr = 0;

        
    end

    initial begin


    end


endmodule: memsim