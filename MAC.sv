module MAC(input logic clk, input logic rst, input logic en,
           input logic [15:0] A, input logic [15:0] B, 
           output logic [15:0] out);

    always @ (posedge clk or posedge rst) begin
        if (rst)   
            out <= 16'b0;
        else
            out <= en ? out + A*B : out;
    end


endmodule: MAC