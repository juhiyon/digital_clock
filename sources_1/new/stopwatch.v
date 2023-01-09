module stopwatch(st, wt_clk, btn[3], btn[2], btn[1], btn[0], mm, ss);
input [1:0] st;
input wt_clk;
input [3:0] btn;
output reg [5:0]mm=6'b0;
output reg [5:0]ss=6'b0;
//btn3=��� �� ����
//btn2=����
//btn1=����
//�� �� ��ư ����(�� �۵� �״��)

always@(posedge wt_clk)
begin
if(st == 2'b01)
begin
    case(btn)
        4'b1000 : //��� �� ����
        begin
            if(ss>59)
            begin
                ss<=0;
                if(mm>59)
                begin
                    mm<=0;
                end
                else
                    mm<=mm+1;
            end
            else
                ss<=ss+1;
        end
        4'b0100 : //����
        begin
            ss<=ss;
            mm<=mm;
        end
        4'b0010 : //�ʱ�ȭ
        begin
            mm<=0;
            ss<=0;
        end
        default : 
        begin
            mm<=mm;
            ss<=ss;
        end
   endcase     
end
end

endmodule
