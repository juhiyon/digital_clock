`timescale 1ns / 1ps
module uart_tx(clk, st, mm, ss, mm2, ss2, txd);
input clk;
input [1:0] st;
input [5:0]mm; 
input [5:0]ss;
input [5:0]mm2; 
input [5:0]ss2;
output reg txd;

reg [11:0] clk_cnt=0;//125MHZ를 115200보드레이트 맞추기 위해
reg [3:0] tx_st=4'b0000;//idle,start,data,stop 상태 나타내기 위함
reg [7:0] tx_result;//현재 보낼 문자가 무엇인지 나타내기 위함
reg stst=0;//cnt 상태에 따라서.
reg [2:0] txd_cnt=0;//00:00엔터 총 여섯문자 보내야 함, 따라서 현재 보낼 문자 위치 나타냄
reg [5:0]tx_mm=6'b000000;//현재 보낼 분
reg [5:0]tx_ss=6'b000000;//현재 보낼 초

parameter IDLE_ST=0,
          START_ST=1,
          DATA_ST0=2,
          DATA_ST1=3,
          DATA_ST2=4,
          DATA_ST3=5,
          DATA_ST4=6,
          DATA_ST5=7,
          DATA_ST6=8,
          DATA_ST7=9,
          STOP_ST=10;
          
//모드에 따라서, cnt에 따라서 tx_result에 값 넣어주기
//모드에 따라서 reg tx_mm에 값 넣어주기
//tx_mm이 바뀔때마다 cnt값에 따라서 tx_restul에 넣어주기
always @(mm or ss or mm2 or ss2)
begin
if(st == 2'b01)//stopwatch
begin
    tx_mm<=mm;
    tx_ss<=ss;
end
else if(st == 2'b10)//alarm
begin
    tx_mm<=mm2;
    tx_ss<=ss2;
end
end

always @(txd_cnt)
begin
    case(txd_cnt)
        3'b000 : 
        begin
        if(tx_mm>6'b001001)
            tx_result<=(tx_mm/10)+"0";
        else
            tx_result<="0";
        end
        3'b001 : tx_result<=(tx_mm % 10)+"0"; // 분 일의자리 수
        3'b010 : tx_result<=":";
        3'b011 : 
        begin
        if(tx_ss>6'b001001)
            tx_result<=tx_ss/10+"0";
        else
            tx_result<="0";
        end
        3'b100 : tx_result<=(tx_ss % 10)+"0";
        3'b101 : tx_result<=8'h0D;
        default : tx_result<="";
    endcase
end

always @*//clk나 뭐 어떤 것에도 상관 없이
begin
case(tx_st)
    IDLE_ST : txd<=1;
    START_ST : txd<=0;
    DATA_ST0 : txd<=tx_result[0];
    DATA_ST1 : txd<=tx_result[1];
    DATA_ST2 : txd<=tx_result[2];
    DATA_ST3 : txd<=tx_result[3];
    DATA_ST4 : txd<=tx_result[4];
    DATA_ST5 : txd<=tx_result[5];
    DATA_ST6 : txd<=tx_result[6];
    DATA_ST7 : txd<=tx_result[7];
    STOP_ST : txd<=1;
    default : txd<=1;
endcase
end

always @(posedge clk)
begin
if(clk_cnt == 1084)//1084
begin
    clk_cnt<=0;
    case(tx_st)
        IDLE_ST : 
        begin
        if(stst==0)
            tx_st<=START_ST;
        else//stst=1때 즉,,,다 보내면
        begin
            txd_cnt<=0;
            tx_st<=START_ST;
        end
        end
        START_ST : tx_st<=DATA_ST0;
        DATA_ST0 : tx_st<=DATA_ST1;
        DATA_ST1 : tx_st<=DATA_ST2;
        DATA_ST2 : tx_st<=DATA_ST3;
        DATA_ST3 : tx_st<=DATA_ST4;
        DATA_ST4 : tx_st<=DATA_ST5;
        DATA_ST5 : tx_st<=DATA_ST6;
        DATA_ST6 : tx_st<=DATA_ST7;
        DATA_ST7 : tx_st<=STOP_ST;
        STOP_ST : 
        begin
            txd_cnt<=txd_cnt+1;//이거 안먹힘
            tx_st<=IDLE_ST;
        end
        default : tx_st<=IDLE_ST;
    endcase
end
else
    clk_cnt<=clk_cnt+1;
end

always @*
begin
if(txd_cnt<6)
begin
    stst<=0;
end
else
begin
    stst<=1;
end
end

endmodule