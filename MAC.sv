// module MAC(input logic clk, input logic rst, input logic en,
//            input logic signed [15:0] A, input logic signed [15:0] B, 
//            output logic signed [31:0] out);

//     always @ (posedge clk or posedge rst) begin
//         if (rst)   
//             out <= 32'b0;
//         else
//             out <= en ? out + A*B : out;
//     end


// endmodule: MAC

module MAC(
    input logic clk,
    input logic rst,
    input logic en,
    input logic signed [31:0] A, // 16-bit signed fixed-point number
    input logic signed [31:0] B, // 16-bit signed fixed-point number
    output logic signed [31:0] out // 32-bit signed fixed-point accumulator
);

    localparam Q = 10;
    localparam N = 32;
    
    logic signed [N-1:0] acc_sum;
    logic signed [N-1:0] product;
    logic ovr;

    qmult #(Q, N) mult(A, B, product, ovr);
    qadd #(Q, N) add(out, product, acc_sum);

    always_ff @ (posedge clk or posedge rst) begin
        if (rst) begin
            out <= 32'sd0;
            acc_sum <= 32'sd0;
        end else begin
            // product <= (A * B) >>> 15; 
            out <= en ? acc_sum : out;
        end
    end

endmodule: MAC
