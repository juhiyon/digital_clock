`timescale 1ns / 1ps
module uart_tx(clk, st, mm, ss, mm2, ss2, txd);
input clk;
input [1:0] st;
input [5:0]mm; 
input [5:0]ss;
input [5:0]mm2; 
input [5:0]ss2;
output reg txd;

reg [11:0] clk_cnt=0;//125MHZ�� 115200���巹��Ʈ ���߱� ����
reg [3:0] tx_st=4'b0000;//idle,start,data,stop ���� ��Ÿ���� ����
reg [7:0] tx_result;//���� ���� ���ڰ� �������� ��Ÿ���� ����
reg stst=0;//cnt ���¿� ����.
reg [2:0] txd_cnt=0;//00:00���� �� �������� ������ ��, ���� ���� ���� ���� ��ġ ��Ÿ��
reg [5:0]tx_mm=6'b000000;//���� ���� ��
reg [5:0]tx_ss=6'b000000;//���� ���� ��

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
          
//��忡 ����, cnt�� ���� tx_result�� �� �־��ֱ�
//��忡 ���� reg tx_mm�� �� �־��ֱ�
//tx_mm�� �ٲ𶧸��� cnt���� ���� tx_restul�� �־��ֱ�
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
        3'b001 : tx_result<=(tx_mm % 10)+"0"; // �� �����ڸ� ��
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

always @*//clk�� �� � �Ϳ��� ��� ����
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
        else//stst=1�� ��,,,�� ������
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
            txd_cnt<=txd_cnt+1;//�̰� �ȸ���
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