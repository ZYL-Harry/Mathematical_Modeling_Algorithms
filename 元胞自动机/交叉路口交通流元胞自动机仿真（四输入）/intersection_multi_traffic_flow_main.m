%% 交叉路口交通流元胞自动机（四输入双车道）
close all;
clc;
clear;%清屏命令

%% 图框设置
figure;%利用当前属性创建窗格
axes;%建立坐标轴
rand('state',0);
%这个命令应该是回到最开始的种子，
%否则森林的状态在你第二次运行的时候是接着上一次运行的结果
%不是一个新的状态
set(gcf,'DoubleBuffer','on');   %防止在不断循环画动画的时候会产生闪烁的现象

%% 交通图像初始化设置
% “1”白色——没车；“0”黑色——有车；“0.5”灰色——其他部分
road_length=50;    %定义单条道路长度为100
road_width=1;       %定义单条道路宽度为1
C=ones(2*road_length+2,2*road_length+2);    %定义用于显示的图像矩阵
% 将除了路段的其他部分置为灰色
C(1:road_length,1:road_length)=0.5;
C(1:road_length,road_length+3:2*road_length+2)=0.5;
C(road_length+3:2*road_length+2,1:road_length)=0.5;
C(road_length+3:2*road_length+2,road_length+3:2*road_length+2)=0.5;
CL=C;    CR=C;  CU=C;   CD=C;

%%RGB
A=0.7451*ones(2*road_length+2,2*road_length+2,3); %构造一个向量
R=0.7451*ones(2*road_length+2,2*road_length+2);   R(C==1)=255;    A(:,:,1)=R;
G=0.7451*ones(2*road_length+2,2*road_length+2);   G(C==1)=255;    A(:,:,2)=G;
B=0.7451*ones(2*road_length+2,2*road_length+2);   B(C==1)=255;    A(:,:,3)=B;

Ci=imshow(A);       %展示模拟情况
ti=0;%初始化时间
tp=title(['T = ',num2str(ti)]);%在标题处显示时间

%% 车辆进入概率、车速与红绿灯时长的设置
% p=0.5;
% v=2;
light_time=100;
light_gp=0.6;
light_yp_1=0.7;
light_rp=0.9;
light_yp_2=1;

%% 循环阶段
infinite=10000;
Car=cell(infinite,4);
car_number_l=0; car_number_r=0; car_number_u=0; car_number_d=0;
car_on_l=0;     car_on_r=0;     car_on_u=0;     car_on_d=0;
judge_l=0;      judge_r=0;      judge_u=0;      judge_d=0;      %标识符：用于判断是否有车将离开该区域
flag=0;
aa=-1;
rl=-1;    rlo=-1;
while 1
    ti=ti+1;
    %% 红绿灯判断——先绿，再黄，再红
    la=mod(ti,light_time);
    if la<=light_time*light_gp
        flag=1;     %当时间小于绿灯时间时，flag=1（绿灯）
        rl=light_time*light_gp-la;
    elseif la>light_time*light_gp&&la<=light_time*light_yp_1
        flag=2;
        rl=0;
    elseif la>light_time*light_yp_1&&la<=light_time*light_rp
        flag=0;
        rlo=light_time*light_rp-la;
    elseif la>light_time*light_rp&&la<=light_time*light_yp_2
        flag=2;
        rl=0;
        aa=0;
    end
    %% 车辆控制
    [CL,Car(:,1),car_number_l,car_on_l,judge_l,flag,aa]=Left_Car(ti,CL,C,Car(:,1),Car,car_number_l,car_on_r,judge_l,road_length,flag,light_time,light_gp,aa,rl);
    CL(CL==0.5)=10;  CR(CR==0.5)=10;  CU(CU==0.5)=10;  CD(CD==0.5)=10;
    CL(CL==1)=3;    CR(CR==1)=3;    CU(CU==1)=3;    CD(CD==1)=3;
    C(C==4)=0.5;    C(C==13)=0;  C(C==14)=0;  C(C==15)=0;  C(C==16)=0;  C(C==12)=1;
    C=CL+rot90(CR,2)+rot90(CU,3)+rot90(CD);
    CL(CL==10)=0.5;  CR(CR==10)=0.5;  CU(CU==10)=0.5;  CD(CD==10)=0.5;
    CL(CL==3)=1;    CR(CR==3)=1;    CU(CU==3)=1;    CD(CD==3)=1;
    CL(CL==4)=0;    CR(CR==5)=0;    CU(CU==6)=0;    CD(CD==7)=0;
    C(C==4)=0.5;    C(C==13)=0;  C(C==14)=0;  C(C==15)=0;  C(C==16)=0;  C(C==12)=1;
    [CR,Car(:,3),car_number_r,car_on_r,judge_r,flag,aa]=Right_Car(ti,CR,C,Car(:,3),Car,car_number_r,car_on_r,judge_r,road_length,flag,light_time,light_gp,aa,rl);
    CL(CL==0.5)=10;  CR(CR==0.5)=10;  CU(CU==0.5)=10;  CD(CD==0.5)=10;
    CL(CL==1)=3;    CR(CR==1)=3;    CU(CU==1)=3;    CD(CD==1)=3;
    CL(CL==0)=4;    CR(CR==0)=5;    CU(CU==0)=6;    CD(CD==0)=7;
    C=CL+rot90(CR,2)+rot90(CU,3)+rot90(CD);
    CL(CL==10)=0.5;  CR(CR==10)=0.5;  CU(CU==10)=0.5;  CD(CD==10)=0.5;
    CL(CL==3)=1;    CR(CR==3)=1;    CU(CU==3)=1;    CD(CD==3)=1;
    CL(CL==4)=0;    CR(CR==5)=0;    CU(CU==6)=0;    CD(CD==7)=0;
    C(C==4)=0.5;    C(C==13)=0;  C(C==14)=0;  C(C==15)=0;  C(C==16)=0;  C(C==12)=1;
    [CU,Car(:,2),car_number_u,car_on_u,judge_u,aa]=Up_Car(ti,CU,C,Car(:,2),Car,car_number_u,car_on_u,judge_u,road_length,flag,light_time,light_gp,aa,rlo);
    CL(CL==0.5)=10;  CR(CR==0.5)=10;  CU(CU==0.5)=10;  CD(CD==0.5)=10;
    CL(CL==1)=3;    CR(CR==1)=3;    CU(CU==1)=3;    CD(CD==1)=3;
    CL(CL==0)=4;    CR(CR==0)=5;    CU(CU==0)=6;    CD(CD==0)=7;
    C=CL+rot90(CR,2)+rot90(CU,3)+rot90(CD);
    CL(CL==10)=0.5;  CR(CR==10)=0.5;  CU(CU==10)=0.5;  CD(CD==10)=0.5;
    CL(CL==3)=1;    CR(CR==3)=1;    CU(CU==3)=1;    CD(CD==3)=1;
    CL(CL==4)=0;    CR(CR==5)=0;    CU(CU==6)=0;    CD(CD==7)=0;
    C(C==4)=0.5;    C(C==13)=0;  C(C==14)=0;  C(C==15)=0;  C(C==16)=0;  C(C==12)=1;
    [CD,Car(:,4),car_number_d,car_on_d,judge_d,aa]=Down_Car(ti,CD,C,Car(:,4),Car,car_number_d,car_on_d,judge_d,road_length,flag,light_time,light_gp,aa,rlo);
    
    %% 图像生成，考虑几种搭配可能：灰加灰（其他加其他）40_灰、黑加白（车辆与道路）13_青/14_蓝/15_紫/16_橙、白加白（道路与道路12_白 & 绿灯与绿灯19_绿）、黑加黑（红灯与红灯）17_红
    CL(CL==0.5)=10;  CR(CR==0.5)=10;  CU(CU==0.5)=10;  CD(CD==0.5)=10;
    CL(CL==1)=3;    CR(CR==1)=3;    CU(CU==1)=3;    CD(CD==1)=3;
    CL(CL==0)=4;    CR(CR==0)=5;    CU(CU==0)=6;    CD(CD==0)=7;
    C=CL+rot90(CR,2)+rot90(CU,3)+rot90(CD);
    
    %% 设置红绿灯图像
    if flag==1
        % 左右相对的道路
        C(road_length+4,road_length-1)=19;%绿灯时为白
        C(road_length-1,road_length+4)=19;
        % 上下相对的道路
        C(road_length-1,road_length-1)=17;%红灯时为黑
        C(road_length+4,road_length+4)=17;
    elseif flag==0
        % 左右相对的道路
        C(road_length+4,road_length-1)=17;%红灯时为黑
        C(road_length-1,road_length+4)=17;
        % 上下相对的道路
        C(road_length-1,road_length-1)=19;%绿灯时为白
        C(road_length+4,road_length+4)=19;
    elseif flag==2
        % 左右相对的道路
        C(road_length+4,road_length-1)=20;%红灯时为黑
        C(road_length-1,road_length+4)=20;
        % 上下相对的道路
        C(road_length-1,road_length-1)=20;%黄灯时为黄
        C(road_length+4,road_length+4)=20;
    end
    
     %% 图像更新
    %%RGB
    R=zeros(2*road_length+2,2*road_length+2);   R(C==40)=0.7451;    R(C==13)=0;   R(C==14)=0;    R(C==15)=0.62745;    R(C==16)=1;       R(C==12)=255;   R(C==19)=0;     R(C==17)=255;       R(C==20)=255;   A(:,:,1)=R;
    G=zeros(2*road_length+2,2*road_length+2);   G(C==40)=0.7451;    G(C==13)=255; G(C==14)=0;    G(C==15)=0.12549;    G(C==16)=0.64706; G(C==12)=255;   G(C==19)=255;   G(C==17)=0;         G(C==20)=255;   A(:,:,2)=G;
    B=zeros(2*road_length+2,2*road_length+2);   B(C==40)=0.7451;    B(C==13)=255; B(C==14)=255;  B(C==15)=0.94118;    B(C==16)=0;       B(C==12)=255;   B(C==19)=0;     B(C==17)=0;         B(C==20)=0;     A(:,:,3)=B;
    set(Ci,'CData',A);%第一行是显示图像，C是图像的矩阵，Ci上面有定义，是显示图像
    set(tp,'string',['T = ',num2str(ti)]);%第二行是设置图像的标题，显示T=当前时刻
    pause(0.01);
    
    %% 车辆矩阵数据更新
    CL(CL==10)=0.5;  CR(CR==10)=0.5;  CU(CU==10)=0.5;  CD(CD==10)=0.5;
    CL(CL==3)=1;    CR(CR==3)=1;    CU(CU==3)=1;    CD(CD==3)=1;
    CL(CL==4)=0;    CR(CR==5)=0;    CU(CU==6)=0;    CD(CD==7)=0;
    C(C==4)=0.5;    C(C==13)=0;  C(C==14)=0;  C(C==15)=0;  C(C==16)=0;  C(C==12)=1;
end



