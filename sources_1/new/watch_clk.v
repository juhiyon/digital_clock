module watch_clk(clk, wt_clk);
input clk;
output reg wt_clk=0;
reg [31:0] clk_cnt=32'b0;

//input clk에 대해서 1분마다의 clk 클럭을 만들어준다
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

