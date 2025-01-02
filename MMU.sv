module MMU(
    input logic clk,
    input logic rst
);  
    localparam Q = 0;
    localparam N = 32; 
    localparam M = 4;

    logic done, enable_next;
    logic [1:0] addr;

    controller #(.M(M)) controller_inst (
        .clk(clk),
        .rst(rst),
        .done(done),
        .enable_next(enable_next),
        .addr(addr)
    );

    logic signed [N-1:0] x_out [0:M-1], y_out [0:M-1];
    logic signed [N-1:0] acc_sum [0:M-1][0:M-1];

    logic wren;
    logic [31:0] data;
    logic [31:0] r0, r1, r2, r3, c0, c1, c2, c3;

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

    logic signed [N-1:0] x_in [0:M-1];
    logic signed [N-1:0] y_in [0:M-1];

    always_comb begin
        if (done) begin
            for (int i = 0; i < M; i++) begin
                x_in[i] = 0;
                y_in[i] = 0;
            end
        end else begin
            x_in = {r0, r1, r2, r3};
            y_in = {c0, c1, c2, c3};
        end
    end

    systolic_array #(Q, N, M) systolic_array_inst (
        .clk(clk),
        .rst(rst),
        .en(enable_next),
        .x_in(x_in),
        .y_in(y_in),
        .x_out(x_out),
        .y_out(y_out),
        .acc_sum(acc_sum)
    );

endmodule: MMU