function [C,Car]=DeleteCar(car_y,car_x,car_ID,Car,C)
Car{car_ID}(1)=0;  %使车辆的状态参数变为0表示已经到显示区域边界，接下来不再在显示区域的道路上
C(car_y,car_x)=1;
end