module mode(sw[0], sw[1], st);
input [1:0] sw;
output reg [1:0] st;

//sw input이 바뀔 때 마다 st 바꿔준다
always@*
begin
    case(sw)
        2'b01 : st <= 2'b01;//sw0이 켜지면 스탑워치,st=1
        2'b10 : st <= 2'b10;//alarm 기능,st=2
        default : st<=3'b00;//아무것도 출력 안함, st=0
    endcase
end

endmodule
