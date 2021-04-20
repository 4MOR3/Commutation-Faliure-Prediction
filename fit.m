function [fit_para,V_zfl_next]=fit(V,j) 
[row,col]=size(V);%3*5 row=3�̶���Ϊ3��
V_zfl_next=zeros(row,1);  %3*1 3�����һ��ֵ

fit_para  =zeros(row,5);   %3*3 3���Ӧ����ϵ��
% fit_para  =zeros(row,9);   %�����ú���ϵ���ĸ�����ȷ�� 5��ϵ��
frequency=j-1;
for i=1:row     %row=3�̶���Ϊ3��
    temp_V=V(i,:);

    %fun=inline('a(1)*exp(a(2)*t)+a(3)','a','t'); %��������
    fun=inline('a(1)+a(2)*exp(a(3)*t)+a(4)*exp(a(5)*t)','a','t'); %��������
%     fun=inline('a(1)*cos(a(2)*t+a(3))+(a(5)*cos(a(6)*t+a(7))+a(8)*cos(a(6)*t+a(9))).*exp(a(4)*t)','a','t'); %��������
    
    xx=1:col;
    yy=temp_V;
    
%     [a,~]=lsqcurvefit(fun,[0 0 -5 0 -5],xx,yy);
    [a,~]=lsqcurvefit(fun,[0 0 -0.5/frequency 0 -0.5/frequency],xx,yy);
%     [a,~]=lsqcurvefit(fun,[0 0 -0.05*frequency 0 -0.05*frequency],xx,yy);
%     [a,~]=lsqcurvefit(fun,[0 2*pi*frequency 0 -0.05 0 2*pi*frequency 0 0 0],xx,yy)
    
    
    fit_para(i,:)=a;    %%���ϵ������
    V_zfl_next(i)=fun(a,col+1);%%Ԥ����һ����
end
end