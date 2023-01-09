`timescale 1ns / 1ps
module testbench;
reg clk;
reg [1:0] sw;
reg [3:0] btn;
wire txd;

parameter step=4;

top top(.clk(clk), .sw(sw), .btn(btn), .txd(txd));

always #(step/2) clk=~clk;
initial begin
    clk=0;  sw=2'b00;   btn=4'b0000; #(step/2);
    sw=2'b01;   btn=4'b1000; #(step);//stopwatch
    
    $stop;  
end

endmodule