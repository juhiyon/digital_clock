module watch_clk(clk, wt_clk);
input clk;
output reg wt_clk=0;
reg [31:0] clk_cnt=32'b0;

//input clk�� ���ؼ� 1�и����� clk Ŭ���� ������ش�
//d62500000
always@(posedge clk)
begin
    if(clk_cnt>32'd62500000)
    begin
        wt_clk<=~wt_clk;
        clk_cnt<=0;
    end
    else
        clk_cnt<=clk_cnt+1;
end

endmodule

