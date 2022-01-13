%% 交叉路口交通流的元胞自动机仿真
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
C=ones(2*road_length+1,2*road_length+1);    %定义用于显示的图像矩阵
% 将除了路段的其他部分置为灰色
C(1:road_length,1:road_length)=0.5;
C(1:road_length,road_length+2:2*road_length+1)=0.5;
C(road_length+2:2*road_length+1,1:road_length)=0.5;
C(road_length+2:2*road_length+1,road_length+2:2*road_length+1)=0.5;

Ci=imshow(C);       %展示模拟情况
ti=0;%初始化时间
tp=title(['T = ',num2str(ti)]);%在标题处显示时间

%% 车辆进入概率、车速与红绿灯时长的设置
p=0.5;
% v=2;
light_time=20;
light_gp=0.5;

%% 循环阶段
infinite=10000;
Car=cell(infinite,1);
car_number=0;
car_on=0;
judge=0;     %标识符：用于判断是否有车将离开该区域
while 1
    ti=ti+1;
    %% 红绿灯判断——先红，再绿
    if mode(ti,light_time)==0   %当每次循环时间到时，切换符flag=1
        flag=0;
        C(road_length+3,road_length-2)=0;%红灯时为黑
    else
        if mod(ti,light_time)<=light_time*light_gp
            flag=1;     %当时间小于绿灯时间时，flag=1（绿灯）
            C(road_length+3,road_length-2)=1;%绿灯时为白
        else
            flag=0;     %当时间大于绿灯时间时，flag=0（红灯）
            C(road_length+3,road_length-2)=0;%红灯时为黑
        end
    end
    if ti~=1
       %% 根据车辆位置和性质使车辆移动
        %遍历所有道路上的车辆，获得道路上车辆的编号然后根据车辆数据元胞中的坐标进行移动即可
        car_ID=SearchCarData(Car);    %搜寻道路上存在的车辆，获得每个车辆的编号
        for i=1:size(car_ID,1)   %遍历所有在显示道路上的车辆
            car_data=Car{car_ID(i)};
            single_car_y=car_data(4);
            single_car_x=car_data(3);
            single_car_ID=car_ID(i); %ID需要是正着数
            judge=JudgeMarginCar(single_car_y,single_car_x,road_length);
            if judge==0
                [C,Car]=MoveCar(single_car_y,single_car_x,single_car_ID,Car,C,road_length,flag);
            else
                judge=0;
                [C,Car]=DeleteCar(single_car_y,single_car_x,single_car_ID,Car,C);
                car_on=car_on-1;
            end
        end
    end
    
    %% 新车辆的生成
    [newcar_ID,car_number,car_on,C]=CreateNewCar(ti,road_length,car_number,car_on,C);  %获取车辆数据（车辆状态、道路上车辆的编号、直行/左转/右转）、车辆编号、总的图像数据
    %传递参数：时间、道路上车的数量、图像矩阵数据、车辆在所有车辆中的编号
    %时间——判断第几次循环
    %道路上车的数量——之后在遍历车辆时能知道需要遍历的总数
    %图像矩阵数据——用来赋予生成车辆位置“0”值
    %车辆在所有车辆中的编号——用在处理总车辆数据矩阵
    if ~isempty(newcar_ID)
        Car{car_number}=newcar_ID;
    end
    
    %% 展示实时仿真结果
    set(Ci,'CData',C);%第一行是显示图像，C是图像的矩阵，Ci上面有定义，是显示图像。
    set(tp,'string',['T = ',num2str(ti)]);%第二行是设置图像的标题，显示T=当前时刻
    pause(0.1);
end
