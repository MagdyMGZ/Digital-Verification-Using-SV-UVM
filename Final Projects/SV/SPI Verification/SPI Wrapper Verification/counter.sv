module up_counter(input clk, rst_n, output[3:0] counter);
reg [3:0] counter_up;

always @(posedge clk or negedge rst_n)
begin
if(~rst_n||counter_up==4'd10)
 counter_up <= 4'd0;
else
 counter_up <= counter_up + 4'd1;
end 
assign counter = counter_up;
endmodule
