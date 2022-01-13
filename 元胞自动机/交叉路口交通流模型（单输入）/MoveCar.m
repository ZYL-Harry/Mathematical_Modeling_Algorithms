function [C,Car]=MoveCar(car_y,car_x,car_ID,Car,C,road_length)
direction=Car{car_ID}(2);   %拿到车辆的方向数据
C(car_y,car_x)=1;
if car_x==(road_length+1)&&car_y==(road_length+1)   %判断车的位置是否在路段端口
    if direction==1
        new_y=car_y;
        new_x=car_x+1;
    elseif direction==2
        new_y=car_y-1;
        new_x=car_x;
    elseif direction==3
        new_y=car_y+1;
        new_x=car_x;
    end
elseif car_x~=(road_length+1)&&car_y==(road_length+1)   %判断车的位置是否在横向的路段
    new_y=car_y;
    new_x=car_x+1;
elseif car_x==(road_length+1)&&car_y<(road_length+1)    %判断车的位置是否在向上的路段
    new_y=car_y-1;
    new_x=car_x;
elseif car_x==(road_length+1)&&car_y>(road_length+1)    %判断车的位置是否在向下的路段
    new_y=car_y+1;
    new_x=car_x;
end
C(new_y,new_x)=0;
Car{car_ID}(3)=new_x;
Car{car_ID}(4)=new_y;
end