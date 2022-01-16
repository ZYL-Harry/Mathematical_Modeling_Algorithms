function [C,Car,car_number,car_on,judge,aa]=Up_Car(ti,C,Ct,Car,Car_total,car_number,car_on,judge,road_length,flag,light_time,light_gp,aa,rl)
    in_state=2;
    if flag==1
        flag_o=0;
    elseif flag==0
        flag_o=1;
    elseif flag==2
        flag_o=2;
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
            judge=multi_JudgeMarginCar(single_car_y,single_car_x,road_length);
            if judge==0
                [C,Car,aa]=multi_MoveCar(single_car_y,single_car_x,single_car_ID,Car,C,road_length,flag_o,Car_total,Ct,aa,rl);
            else
                judge=0;
                [C,Car]=DeleteCar(single_car_y,single_car_x,single_car_ID,Car,C);
                car_on=car_on-1;
            end
        end
    end
    
    %% 新车辆的生成
    [newcar_ID,car_number,car_on,C]=multi_CreateNewCar(ti,road_length,car_number,car_on,C,in_state);  %获取车辆数据（车辆状态、直行/左转/右转、车辆坐标（横纵）、车辆出现的时间）、更新后的总车辆数、道路上的总车辆数、总的图像数据
    %传递参数：时间、道路上车的数量、图像矩阵数据、车辆在所有车辆中的编号
    %时间——判断第几次循环
    %道路长度——赋予车辆位置
    %道路上车的数量——之后在遍历车辆时能知道需要遍历的总数
    %图像矩阵数据——用来赋予生成车辆位置“0”值
    %车辆在所有车辆中的编号——用在处理总车辆数据矩阵
    if ~isempty(newcar_ID)
        Car{car_number}=newcar_ID;
    end
end
