function [C,Car]=MoveCar(car_y,car_x,car_ID,Car,C,road_length,flag)
direction=Car{car_ID}(2);   %拿到车辆的方向数据
C(car_y,car_x)=1;
if flag==1||(flag==0&&car_x>road_length)  %如果是绿灯，或者红灯情况下在非左侧路段，则正常通行
    if car_x==(road_length+1)&&car_y==(road_length+1)   %判断车的位置是否在路段端口中间
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
else   %如果是红灯，则先判断有没有到路口，再判断能不能向前通行
    if car_x==road_length&&car_y==(road_length+1)   %判断车的位置是否到达路口处
        new_y=car_y;
        new_x=car_x;
    elseif car_x<road_length&&car_y==(road_length+1)    %判断车的位置未到达路口而在左侧路段
        if C(car_y,car_x+1)==0
            new_y=car_y;
            new_x=car_x;
        else
            new_y=car_y;
            new_x=car_x+1;
        end        
    end
end
C(new_y,new_x)=0;
Car{car_ID}(3)=new_x;
Car{car_ID}(4)=new_y;
end