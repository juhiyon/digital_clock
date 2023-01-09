module mode(sw[0], sw[1], st);
input [1:0] sw;
output reg [1:0] st;

//sw input�� �ٲ� �� ���� st �ٲ��ش�
always@*
begin
    case(sw)
        2'b01 : st <= 2'b01;//sw0�� ������ ��ž��ġ,st=1
        2'b10 : st <= 2'b10;//alarm ���,st=2
        default : st<=3'b00;//�ƹ��͵� ��� ����, st=0
    endcase
end

endmodule
