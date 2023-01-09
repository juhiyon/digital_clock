module top(
input clk, 
input [1:0] sw, 
input [3:0]btn,
output wire txd
);

wire [1:0] st;
wire wt_clk;
wire [5:0]mm;
wire [5:0]ss;
wire [5:0]mm2;
wire [5:0]ss2;


    mode mode(sw[0], sw[1], st);
    watch_clk watch_clk(clk, wt_clk);
    stopwatch stopwatch(st, wt_clk, btn[3], btn[2], btn[1], btn[0], mm, ss);
    alarm alarm(st, wt_clk, btn[3], btn[2], btn[1], btn[0], mm2, ss2);
    uart_tx uart_tx(clk,st, mm, ss, mm2, ss2, txd);
    
endmodule
