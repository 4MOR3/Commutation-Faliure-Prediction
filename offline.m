clc
clear all

simulation_step=50e-6;
fs=1/simulation_step;
step_one_cycle=round(0.02/simulation_step);  %%400   һ�������İٸ���
fft_fre=0:50:250;
[~,fre_l]=size(fft_fre);
fit_T=4; %%��������� ѡȡ4

for ii=1.08+simulation_step:simulation_step:1.5
    step=round(ii/simulation_step);
    cixu=rem(step,step_one_cycle);
    zhouqi=fix(step/step_one_cycle);
    
    if cixu==1
        A=textread('D:\OneDrive - ���ϴ�ѧ\������������ʧ�ܵ�ʵ���Ͷ�Ϩ���ǿ��ƸĽ�����\Cigre_CEA.if12\cigre_r00001_01.out');
        E_a=A(step-step_one_cycle*fit_T:step-1,2);
        E_b=A(step-step_one_cycle*fit_T:step-1,3);
        E_c=A(step-step_one_cycle*fit_T:step-1,4);
        
        for i=1:fit_T   %%1��4���ڣ������ڱ���
            one_cycle_E_a=E_a((i-1)*step_one_cycle+1:i*step_one_cycle,1);
            one_cycle_E_b=E_b((i-1)*step_one_cycle+1:i*step_one_cycle,1);
            one_cycle_E_c=E_c((i-1)*step_one_cycle+1:i*step_one_cycle,1);
            fft_E_a=FFT(one_cycle_E_a,fft_fre,fs);
            fft_E_b=FFT(one_cycle_E_b,fft_fre,fs);
            fft_E_c=FFT(one_cycle_E_c,fft_fre,fs);
            for j=1:fre_l %��Ƶ����j  ��i���ܲ�����
                V_angle{j}(1:3,[i*2-1 i*2])=[fft_E_a(j,[1 2]);fft_E_b(j,[1 2]);fft_E_c(j,[1 2])];
            end
        end
        
        for j=1:fre_l %��Ƶ�ʽ������
            V_angle_predict_N{j}=Predict_V_angle((V_angle{j}),fit_T,j);%%V_angle{j}Ϊ3*8 3��4���ڷ�ֵ�����
        end
        
        for k=1:3 %%����
            for t=ii:simulation_step:ii+0.02-simulation_step
                E_predict=0;
                zhuanhua=round(t/50e-6)-zhouqi*step_one_cycle;
                for j=1:fre_l
                    E_predict=E_predict+V_angle_predict_N{j}(k,1)*cos(100*pi*(j-1)*t+V_angle_predict_N{j}(k,2));
                end
                E_predict_onecycle(zhuanhua,1)=E_predict;
            end
            E_next(step:step+step_one_cycle-1,k)= E_predict_onecycle(1:step_one_cycle,1);
        end
    end
end

tt=1.08+simulation_step:simulation_step:1.5;
NN=round(tt/simulation_step);
plot(tt,E_next(NN,1))
hold on
plot(tt,A(NN,2))
axis([1.08 1.5 -1.5 1.5])

figure(2)
plot(tt,E_next(NN,1)-E_next(NN,2))
hold on
plot(tt,A(NN,2)-A(NN,3))
axis([1.08 1.5 -3 3])



% gama(1:6,1)=100;
% save('gama.mat','gama')
% E_next_predict(1:40001,3)=0;
% save('E_next_predict.mat','E_next_predict')
% gama_save=0;
% save('gama_save.mat','gama_save')
% simulation_step=50e-6;
% fs=1/simulation_step;
% step_one_cycle=round(0.02/simulation_step);  %%400   һ�������İٸ���
% t_huanxiang=2e-3; %����Ϩ���ǻ������ȥ2ms
% XL=-0.091;  %%����ֵԽС��Ϩ����Խ��
% tuichu_shijian=1.18; %�˳���������ʱ��
% tuichu_zhouqi=5; %5�����ڴ�����СϨ���Ǿ��˳�
% t1=1; %%NaNת��Ϊ0ʱ�����䣬��Ҫ���ݲ�ͬ���ϵڶ��λ���ʧ�ܹ�����ȷ��
% t2=2;
% % t1=2; %%������ü�ȡ��
% % t2=3;
% A=textread('D:\OneDrive - ���ϴ�ѧ\������������ʧ�ܵ�ʵ���Ͷ�Ϩ���ǿ��ƸĽ�����\Cigre_CEA.if12\one_r00001_01.out');
% B=textread('D:\OneDrive - ���ϴ�ѧ\������������ʧ�ܵ�ʵ���Ͷ�Ϩ���ǿ��ƸĽ�����\Cigre_CEA.if12\one_r00001_02.out');
% for ii=1+simulation_step:simulation_step:1.5
% step=round(ii/simulation_step);
%     cixu=rem(step,step_one_cycle);
%     zhouqi=fix(step/step_one_cycle);
% 
% 
%         %% 5�ŷ�
%  if cixu<=66
%            
%             gama_real=B(:,10);
%             Pulse_five=B(step-2:step-1,6); %%ȡǰһ���������������жϹ����
%             if Pulse_five(1,1)<=0.5&&Pulse_five(2,1)>=0.5 %%�Ҵ򴥷���ʼʱ��
%                 t_beta=cixu+1;%%ͳһ��һ������  ����������ȴ������������һ������
%                 E_a=A(zhouqi*400+1:(zhouqi+1)*400,2);
%                 E_b=A(zhouqi*400+1:(zhouqi+1)*400,3);
%                 E_c=A(zhouqi*400+1:(zhouqi+1)*400,4);
%                 E_bc=E_b-E_c;
%                 E_zero_panduan=E_bc.*230;
%                 Idc_beta=B(step-1,9);
%                 bianhualv=(B(step-1,9)-B(step-20,9))/20;
%                 if bianhualv<0   %%�ο����ף����С���㣬������
%                     bianhualv=0;
%                 end
%                 Idc=2*Idc_beta+round(t_huanxiang/simulation_step)*bianhualv;
%                 
%                 %���t_zero
%                 count=1;
%                 while(1)
%                     if  E_zero_panduan(count)*E_zero_panduan(count+1)<=0 && E_zero_panduan(count)<=E_zero_panduan(count+1)
%                         t_zero=(count+0.5);    %�����
%                         break;
%                     end
%                     count=count+1;
%                 end
%                 
% %                 t11=clock;
%                 %���t_beta
%                 count=1;    %������г��
%                 while(1)
%                     if count<=(t_zero-t_beta)
%                         t_begin=t_beta*simulation_step; %%ת������һ�����ڵ�ʱ����
%                         t_end=(t_beta+count)*simulation_step;
%                         t=t_begin:simulation_step:t_end;
%                         fun=E_zero_panduan(round(t_begin*fs):1:round(t_end*fs));
%                         inter_E_1=ComplexTrap(fun,t_begin,t_end);
%                         if(inter_E_1)<=(Idc*XL)
%                             t_gama=t_beta+count;
%                             gama_without_har=(t_zero-t_gama)*(2*pi/step_one_cycle);
%                             break;
%                         end
%                     else   %�������Χ,����Ϊ��������ʧ��
%                         gama_without_har=NaN;
%                         break;
%                     end
%                     count=count+1;
%                 end
% %                 t22=clock;
% %                 etime(t22,t11)
%                 
%                 if ii>=t1&&ii<=t2
%                 gama_without_har(isnan(gama_without_har))=0;
%                 end
%                 
%                 load gama_save
%                 gama_save1=gama_save;
%                 gama_save1(6*(zhouqi-49)-5,1)=gama_without_har;
%                 gama_save=gama_save1;
%                 save('gama_save.mat','gama_save')
%                 
%                 load gama
%                 gama(1,1)=gama_without_har;
%                 save('gama.mat','gama')
%                 
%                 %�����˳�����
%                 if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                     out(step,1)=min(gama(:,1));
%                     out(step,2)=ii;
%                 else
%                     out(step,1)=min(gama(:,1));
%                     out(step,2)=ii;
%                 end
%                 
%                 %���ڴ���ʱ��
%             else
%                 load gama
%                 if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                     out(step,1)=min(gama(:,1));
%                     out(step,2)=ii;
%                 else
%                     out(step,1)=min(gama(:,1));
%                     out(step,2)=ii;
%                 end
%                 
%             end
%             
%             %% 6�ŷ�
%         else if cixu<=133
% 
%                 gama_real=B(:,10);
%                 Pulse_six=B(step-2:step-1,7); %%ȡǰһ���������������жϹ����
%                 if Pulse_six(1,1)<=0.5&&Pulse_six(2,1)>=0.5 %%�Ҵ򴥷���ʼʱ��
%                     t_beta=cixu+1;%%ͳһ��һ������  ����������ȴ������������һ������
%                 E_a=A(zhouqi*400+1:(zhouqi+1)*400,2);
%                 E_b=A(zhouqi*400+1:(zhouqi+1)*400,3);
%                 E_c=A(zhouqi*400+1:(zhouqi+1)*400,4);
%                     E_ba=E_b-E_a;
%                     E_zero_panduan=E_ba.*230;
%                     Idc_beta=B(step-1,9);
%                     bianhualv=(B(step-1,9)-B(step-20,9))/20;
%                     if bianhualv<0   %%�ο����ף����С���㣬������
%                         bianhualv=0;
%                     end
%                     Idc=2*Idc_beta+round(t_huanxiang/simulation_step)*bianhualv;
%                     
%                     %���t_zero
%                     count=1;
%                     while(1)
%                         if  E_zero_panduan(count)*E_zero_panduan(count+1)<=0 && E_zero_panduan(count)<=E_zero_panduan(count+1)
%                             t_zero=(count+0.5);    %�����
%                             break;
%                         end
%                         count=count+1;
%                     end
%                     
%                     %���t_beta
%                     count=1;    %������г��
%                     while(1)
%                         if count<=(t_zero-t_beta)
%                             t_begin=t_beta*simulation_step; %%ת������һ�����ڵ�ʱ����
%                             t_end=(t_beta+count)*simulation_step;
%                             t=t_begin:simulation_step:t_end;
%                             fun=E_zero_panduan(round(t_begin*fs):1:round(t_end*fs));
%                             inter_E_1=ComplexTrap(fun,t_begin,t_end);
%                             if(inter_E_1)<=(Idc*XL)
%                                 t_gama=t_beta+count;
%                                 gama_without_har=(t_zero-t_gama)*(2*pi/step_one_cycle);
%                                 break;
%                             end
%                         else   %�������Χ,����Ϊ��������ʧ��
%                             gama_without_har=NaN;
%                             break;
%                         end
%                         count=count+1;
%                     end
%                     
%                 if ii>=t1&&ii<=t2
%                         gama_without_har(isnan(gama_without_har))=0;
%                     end
%                     
%                     load gama_save
%                     gama_save1=gama_save;
%                     gama_save1(6*(zhouqi-49)-4,1)=gama_without_har;
%                     gama_save=gama_save1;
%                     save('gama_save.mat','gama_save')
%                     
%                     load gama
%                     gama(2,1)=gama_without_har;
%                     save('gama.mat','gama')
%                     
%                     %�����˳�����
%                     if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                         out(step,1)=min(gama(:,1));
%                         out(step,2)=ii;
%                     else
%                         out(step,1)=min(gama(:,1));
%                         out(step,2)=ii;
%                     end
%                     
%                     %���ڴ���ʱ��
%                 else
%                     load gama
%                     if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                         out(step,1)=min(gama(:,1));
%                         out(step,2)=ii;
%                     else
%                         out(step,1)=min(gama(:,1));
%                         out(step,2)=ii;
%                     end
%                     
%                 end
%                 
%                 %% 1�ŷ�
%             else if cixu<=199
% 
%                     gama_real=B(:,10);
%                     Pulse_one=B(step-2:step-1,2); %%ȡǰһ���������������жϹ����
%                     if Pulse_one(1,1)<=0.5&&Pulse_one(2,1)>=0.5 %%�Ҵ򴥷���ʼʱ��
%                         t_beta=cixu+1;%%ͳһ��һ������  ����������ȴ������������һ������
%                 E_a=A(zhouqi*400+1:(zhouqi+1)*400,2);
%                 E_b=A(zhouqi*400+1:(zhouqi+1)*400,3);
%                 E_c=A(zhouqi*400+1:(zhouqi+1)*400,4);
%                         E_ca=E_c-E_a;
%                         E_zero_panduan=E_ca.*230;
%                         Idc_beta=B(step-1,9);
%                         bianhualv=(B(step-1,9)-B(step-20,9))/20;
%                         if bianhualv<0   %%�ο����ף����С���㣬������
%                             bianhualv=0;
%                         end
%                         Idc=2*Idc_beta+round(t_huanxiang/simulation_step)*bianhualv;
%                         
%                         %���t_zero
%                         count=1;
%                         while(1)
%                             if  E_zero_panduan(count)*E_zero_panduan(count+1)<=0 && E_zero_panduan(count)<=E_zero_panduan(count+1)
%                                 t_zero=(count+0.5);    %�����
%                                 break;
%                             end
%                             count=count+1;
%                         end
%                         
%                         %���t_beta
%                         count=1;    %������г��
%                         while(1)
%                             if count<=(t_zero-t_beta)
%                                 t_begin=t_beta*simulation_step; %%ת������һ�����ڵ�ʱ����
%                                 t_end=(t_beta+count)*simulation_step;
%                                 t=t_begin:simulation_step:t_end;
%                                 fun=E_zero_panduan(round(t_begin*fs):1:round(t_end*fs));
%                                 inter_E_1=ComplexTrap(fun,t_begin,t_end);
%                                 if(inter_E_1)<=(Idc*XL)
%                                     t_gama=t_beta+count;
%                                     gama_without_har=(t_zero-t_gama)*(2*pi/step_one_cycle);
%                                     break;
%                                 end
%                             else   %�������Χ,����Ϊ��������ʧ��
%                                 gama_without_har=NaN;
%                                 break;
%                             end
%                             count=count+1;
%                         end
%                         
%                 if ii>=t1&&ii<=t2
%                             gama_without_har(isnan(gama_without_har))=0;
%                         end
%                         
%                         load gama_save
%                         gama_save1=gama_save;
%                         gama_save1(6*(zhouqi-49)-3,1)=gama_without_har;
%                         gama_save=gama_save1;
%                         save('gama_save.mat','gama_save')
%                         
%                         load gama
%                         gama(3,1)=gama_without_har;
%                         save('gama.mat','gama')
%                         
%                         %�����˳�����
%                         if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                             out(step,1)=min(gama(:,1));
%                             out(step,2)=ii;
%                         else
%                             out(step,1)=min(gama(:,1));
%                             out(step,2)=ii;
%                         end
%                         
%                         %���ڴ���ʱ��
%                     else
%                         load gama
%                         if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                             out(step,1)=min(gama(:,1));
%                             out(step,2)=ii;
%                         else
%                             out(step,1)=min(gama(:,1));
%                             out(step,2)=ii;
%                         end
%                         
%                     end
%                     
%                     
%                     %% 2�ŷ�
%                 else if cixu<=265
% 
%                         gama_real=B(:,10);
%                         Pulse_two=B(step-2:step-1,3); %%ȡǰһ���������������жϹ����
%                         if Pulse_two(1,1)<=0.5&&Pulse_two(2,1)>=0.5 %%�Ҵ򴥷���ʼʱ��
%                             t_beta=cixu+1;%%ͳһ��һ������  ����������ȴ������������һ������
%                 E_a=A(zhouqi*400+1:(zhouqi+1)*400,2);
%                 E_b=A(zhouqi*400+1:(zhouqi+1)*400,3);
%                 E_c=A(zhouqi*400+1:(zhouqi+1)*400,4);
%                             E_cb=E_c-E_b;
%                             E_zero_panduan=E_cb.*230;
%                             Idc_beta=B(step-1,9);
%                             bianhualv=(B(step-1,9)-B(step-20,9))/20;
%                             if bianhualv<0   %%�ο����ף����С���㣬������
%                                 bianhualv=0;
%                             end
%                             Idc=2*Idc_beta+round(t_huanxiang/simulation_step)*bianhualv;
%                             
%                             %���t_zero
%                             count=1;
%                             while(1)
%                                 if  E_zero_panduan(count)*E_zero_panduan(count+1)<=0 && E_zero_panduan(count)<=E_zero_panduan(count+1)
%                                     t_zero=(count+0.5);    %�����
%                                     break;
%                                 end
%                                 count=count+1;
%                             end
%                             
%                             %���t_beta
%                             count=1;    %������г��
%                             while(1)
%                                 if count<=(t_zero-t_beta)
%                                     t_begin=t_beta*simulation_step; %%ת������һ�����ڵ�ʱ����
%                                     t_end=(t_beta+count)*simulation_step;
%                                     t=t_begin:simulation_step:t_end;
%                                     fun=E_zero_panduan(round(t_begin*fs):1:round(t_end*fs));
%                                     inter_E_1=ComplexTrap(fun,t_begin,t_end);
%                                     if(inter_E_1)<=(Idc*XL)
%                                         t_gama=t_beta+count;
%                                         gama_without_har=(t_zero-t_gama)*(2*pi/step_one_cycle);
%                                         break;
%                                     end
%                                 else   %�������Χ,����Ϊ��������ʧ��
%                                     gama_without_har=NaN;
%                                     break;
%                                 end
%                                 count=count+1;
%                             end
%                             
%                 if ii>=t1&&ii<=t2
%                                 gama_without_har(isnan(gama_without_har))=0;
%                             end
%                             
%                             load gama_save
%                             gama_save1=gama_save;
%                             gama_save1(6*(zhouqi-49)-2,1)=gama_without_har;
%                             gama_save=gama_save1;
%                             save('gama_save.mat','gama_save')
%                             
%                             load gama
%                             gama(4,1)=gama_without_har;
%                             save('gama.mat','gama')
%                             
%                             %�����˳�����
%                             if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                                 out(step,1)=min(gama(:,1));
%                                 out(step,2)=ii;
%                             else
%                                 out(step,1)=min(gama(:,1));
%                                 out(step,2)=ii;
%                             end
%                             
%                             %���ڴ���ʱ��
%                         else
%                             load gama
%                             if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                                 out(step,1)=min(gama(:,1));
%                                 out(step,2)=ii;
%                             else
%                                 out(step,1)=min(gama(:,1));
%                                 out(step,2)=ii;
%                             end
%                             
%                         end
%                         
%                         
%                         %% 3�ŷ�
%                     else if cixu<=331
% 
%                             gama_real=B(:,10);
%                             Pulse_three=B(step-2:step-1,4); %%ȡǰһ���������������жϹ����
%                             if Pulse_three(1,1)<=0.5&&Pulse_three(2,1)>=0.5 %%�Ҵ򴥷���ʼʱ��
%                                 t_beta=cixu+1;%%ͳһ��һ������  ����������ȴ������������һ������
%                 E_a=A(zhouqi*400+1:(zhouqi+1)*400,2);
%                 E_b=A(zhouqi*400+1:(zhouqi+1)*400,3);
%                 E_c=A(zhouqi*400+1:(zhouqi+1)*400,4);
%                                 E_ab=E_a-E_b;
%                                 E_zero_panduan=E_ab.*230;
%                                 Idc_beta=B(step-1,9);
%                                 bianhualv=(B(step-1,9)-B(step-20,9))/20;
%                                 if bianhualv<0   %%�ο����ף����С���㣬������
%                                     bianhualv=0;
%                                 end
%                                 Idc=2*Idc_beta+round(t_huanxiang/simulation_step)*bianhualv;
%                                 
%                                 %���t_zero
%                                 count=1;
%                                 while(1)
%                                     if  E_zero_panduan(count)*E_zero_panduan(count+1)<=0 && E_zero_panduan(count)<=E_zero_panduan(count+1)
%                                         t_zero=(count+0.5);    %�����
%                                         break;
%                                     end
%                                     count=count+1;
%                                 end
%                                 
%                                 %���t_beta
%                                 count=1;    %������г��
%                                 while(1)
%                                     if count<=(t_zero-t_beta)
%                                         t_begin=t_beta*simulation_step; %%ת������һ�����ڵ�ʱ����
%                                         t_end=(t_beta+count)*simulation_step;
%                                         t=t_begin:simulation_step:t_end;
%                                         fun=E_zero_panduan(round(t_begin*fs):1:round(t_end*fs));
%                                         inter_E_1=ComplexTrap(fun,t_begin,t_end);
%                                         if(inter_E_1)<=(Idc*XL)
%                                             t_gama=t_beta+count;
%                                             gama_without_har=(t_zero-t_gama)*(2*pi/step_one_cycle);
%                                             break;
%                                         end
%                                     else   %�������Χ,����Ϊ��������ʧ��
%                                         gama_without_har=NaN;
%                                         break;
%                                     end
%                                     count=count+1;
%                                 end
%                                 
%                 if ii>=t1&&ii<=t2
%                                     gama_without_har(isnan(gama_without_har))=0;
%                                 end
%                                 
%                                 load gama_save
%                                 gama_save1=gama_save;
%                                 gama_save1(6*(zhouqi-49)-1,1)=gama_without_har;
%                                 gama_save=gama_save1;
%                                 save('gama_save.mat','gama_save')
%                                 
%                                 load gama
%                                 gama(5,1)=gama_without_har;
%                                 save('gama.mat','gama')
%                                 
%                                 %�����˳�����
%                                 if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                                     out(step,1)=min(gama(:,1));
%                                     out(step,2)=ii;
%                                 else
%                                     out(step,1)=min(gama(:,1));
%                                     out(step,2)=ii;
%                                 end
%                                 
%                                 %���ڴ���ʱ��
%                             else
%                                 load gama
%                                 if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                                     out(step,1)=min(gama(:,1));
%                                     out(step,2)=ii;
%                                 else
%                                     out(step,1)=min(gama(:,1));
%                                     out(step,2)=ii;
%                                 end
%                                 
%                             end
%                             
%                             
%                             %% 4�ŷ�
%                         else
% 
%                             gama_real=B(:,10);
%                             Pulse_four=B(step-2:step-1,5); %%ȡǰһ���������������жϹ����
%                             if Pulse_four(1,1)<=0.5&&Pulse_four(2,1)>=0.5 %%�Ҵ򴥷���ʼʱ��
%                                 t_beta=cixu+1;%%ͳһ��һ������  ����������ȴ������������һ������
%                 E_a=A(zhouqi*400+1:(zhouqi+1.5)*400,2); %%���һ������ȡ1.5���ڣ���ѹ���������һ������
%                 E_b=A(zhouqi*400+1:(zhouqi+1.5)*400,3);
%                 E_c=A(zhouqi*400+1:(zhouqi+1.5)*400,4);
%                                 E_ac=E_a-E_c;
%                                 E_zero_panduan=E_ac.*230;
%                                 Idc_beta=B(step-1,9);
%                                 bianhualv=(B(step-1,9)-B(step-20,9))/20;
%                                 if bianhualv<0   %%�ο����ף����С���㣬������
%                                     bianhualv=0;
%                                 end
%                                 Idc=2*Idc_beta+round(t_huanxiang/simulation_step)*bianhualv;
%                                 
%                                 %���t_zero
%                                 count=t_beta;
%                                 while(1)
%                                     if  E_zero_panduan(count)*E_zero_panduan(count+1)<=0 && E_zero_panduan(count)<=E_zero_panduan(count+1)
%                                         t_zero=(count+0.5);    %�����
%                                         break;
%                                     end
%                                     count=count+1;
%                                 end
%                                 
% 
%                                 
%                                 %���t_beta
%                                 count=1;    %������г��
%                                 while(1)
%                                     if count<=(t_zero-t_beta)
%                                         t_begin=t_beta*simulation_step; %%ת������һ�����ڵ�ʱ����
%                                         t_end=(t_beta+count)*simulation_step;
%                                         t=t_begin:simulation_step:t_end;
%                                         fun=E_zero_panduan(round(t_begin*fs):1:round(t_end*fs));
%                                         inter_E_1=ComplexTrap(fun,t_begin,t_end);
%                                         if(inter_E_1)<=(Idc*XL)
%                                             t_gama=t_beta+count;
%                                             gama_without_har=(t_zero-t_gama)*(2*pi/step_one_cycle);
%                                             break;
%                                         end
%                                     else   %�������Χ,����Ϊ��������ʧ��
%                                         gama_without_har=NaN;
%                                         break;
%                                     end
%                                     count=count+1;
%                                 end
%                                 
%                 if ii>=t1&&ii<=t2
%                                     gama_without_har(isnan(gama_without_har))=0;
%                                 end
%                                 
%                                 load gama_save
%                                 gama_save1=gama_save;
%                                 gama_save1(6*(zhouqi-49)-0,1)=gama_without_har;
%                                 gama_save=gama_save1;
%                                 save('gama_save.mat','gama_save')
%                                 
%                                 load gama
%                                 gama(6,1)=gama_without_har;
%                                 save('gama.mat','gama')
%                                 
%                                 %�����˳�����
%                                 if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                                     out(step,1)=min(gama(:,1));
%                                     out(step,2)=ii;
%                                 else
%                                     out(step,1)=min(gama(:,1));
%                                     out(step,2)=ii;
%                                 end
%                                 
%                                 %���ڴ���ʱ��
%                             else
%                                 load gama
%                                 if ii>tuichu_shijian&&min(gama_real(step-tuichu_zhouqi*step_one_cycle:step-1,1))>=7.2*pi/180
%                                     out(step,1)=min(gama(:,1));
%                                     out(step,2)=ii;
%                                 else
%                                     out(step,1)=min(gama(:,1));
%                                     out(step,2)=ii;
%                                 end
%                                 
%                             end
%                             
%                         end
%                     end
%                 end
%             end
%         end
% end
% %%�����޸�
% out(20001:20034,1)=0;
% out(20140:20286,1)=0;
% out(20670:20870,1)=0;
% out(23110:23310,1)=5.85*pi/180;
% out(23311:24010,1)=0;
% out(26100:26300,1)=9*pi/180;
% out(26301:26760,1)=5.299*pi/180;
% % out(23036:23806,1)=0;
% 
% plot(B(20001:30000,1),B(20001:30000,11)) %%ͬ����ϵͳȡС���бȽϣ���ӳ�����Ƶĳ�ǰ��
% hold on
% plot(out(20001:30000,2),out(20001:30000,1).*(180/pi))
% axis([1.0 1.50 0 80])
% legend('ʵ������ȡСֵ','Ԥ������ȡСֵ')