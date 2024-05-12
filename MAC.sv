module MAC(input logic clk, input logic rst, input logic en,
           input logic signed [15:0] A, input logic signed [15:0] B, 
           output logic signed [31:0] out);

    always @ (posedge clk or posedge rst) begin
        if (rst)   
            out <= 32'b0;
        else
            out <= en ? out + A*B : out;
    end


endmodule: MAC
