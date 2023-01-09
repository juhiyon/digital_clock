module alarm(st, wt_clk, btn[3], btn[2], btn[1], btn[0], mm2, ss2);
input [1:0] st;
input wt_clk;
input [3:0] btn;
output reg [5:0]mm2=6'b0;//���߿� uart ��⿡ ���� st���� ���� ��� mm/mm2, ss/ss2 �ٸ��� �� ����
output reg [5:0]ss2=6'b0;
//btn3=minutes rising
//btn2=seconds rising
//btn1=rst
//btn0=start falling
//�� �� ��ư ����(�� �۵� �״��)

always@(posedge wt_clk)
begin
if(st == 2'b10)
begin
    case(btn)
        4'b1000 : //minutes rising
        begin
            if(mm2>58)
                mm2<=mm2;
            else
                mm2<=mm2+1;
        end
        4'b0100 : //seconds rising
        begin
            if(ss2>58)
                ss2<=ss2;
            else
                ss2<=ss2+1;
        end
        4'b0010 : //rst
        begin
            mm2<=0;
            ss2<=0;
        end
        4'b0001 : 
        begin
            if(ss2==0)
            begin
                if(mm2>0)//�� mm2=1,2,3,4 ��
                begin
                    mm2<=mm2-1;
                    ss2<=59;
                end
                else//�� mm2=0
                begin
                    mm2<=mm2;
                    ss2<=ss2;
                end
            end
            else
                ss2<=ss2-1;
        end
        default : 
        begin
            mm2<=mm2;
            ss2<=ss2;
        end
   endcase     
end
end

endmodule
