function out=FFT(data,fre,fs)
[~,fre_l]=size(fre);% 1*4
N=length(data);
fft_result=fft(data,N);  %ÿ�������N�θ���Ҷ����N+1�У�����ֱ������
modulus_value=abs(fft_result)*2/N; %��ģ��*2/NΪ�̶���ʽ
for i=1:fre_l    %%ȡ��Ƶ���µķ�ֵ�����
        multiple=floor(fre(i)/fs*N)+1;%temp�����Ǳ�Ƶ�������˴���Ϊ0 1 2 3
        %��0�η����ڵ�1�У��˴�tempȡ1 2 3 4��floorΪȡ��
        out(i,1)=modulus_value(multiple);
        out(i,2)=angle(fft_result(multiple));
    end
    out(1,1)=out(1,1)/2; %Ŀǰ�в��������
end