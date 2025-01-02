`timescale 1 ps / 1 ps

module MMU_tb();

    parameter CLK_PERIOD = 10;

    logic clk, rst;

    MMU dut (
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    initial begin
        $readmemh("ar0.memh", dut.ar0_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("ar1.memh", dut.ar1_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("ar2.memh", dut.ar2_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("ar3.memh", dut.ar3_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("bc0.memh", dut.bc0_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("bc1.memh", dut.bc1_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("bc2.memh", dut.bc2_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);
        $readmemh("bc3.memh", dut.bc3_mem.altsyncram_component.m_default.altsyncram_inst.mem_data);

        rst = 1;
        #10
        rst = 0;
    end

endmodule: MMU_tb