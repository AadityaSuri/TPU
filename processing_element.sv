module processing_element #(
    parameter Q = 10,
    parameter N = 32
)
(
    input logic clk,
    input logic rst,
    input logic en,
    input logic signed [N-1:0] x_in,
    input logic signed [N-1:0] y_in,
    output logic signed [N-1:0] x_out,
    output logic signed [N-1:0] y_out,
    output logic signed [N-1:0] acc_sum
);

    logic ovr;
    MAC #(Q, N) mac (
        .clk(clk),
        .rst(rst),
        .en(en),
        .A(x_in),
        .B(y_in),
        .out(acc_sum),
        .ovr(ovr)
    );

    always_ff @ (posedge clk or posedge rst) begin
        if (rst) begin
            x_out <= 32'sd0;
            y_out <= 32'sd0;
            // $display("Resetting");
        end else begin
            x_out <= en ? x_in : x_out;
            y_out <= en ? y_in : y_out;
        end
    end

endmodule: processing_element