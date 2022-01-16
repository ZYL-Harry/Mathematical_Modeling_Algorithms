function [car_ID,car_number,car_on,C]=CreateNewCar(ti,road_length,car_number,car_on,C)
p=0.5;
if ti==1
    C(road_length+1,1)=0;   %如果是第一次循环则需要直接生成新车辆
    car_state=1;    %车辆状态——在道路上“1”
    car_number=car_number+1;    %车辆总数加1
    car_on=car_on+1;            %显示的道路上的车辆总数加1
    car_ID=[car_state,ceil(3*rand(1)),1,road_length+1,ti];   %生成车辆时，生成该车辆数据（车辆状态、1直行/2左转/3右转）
%     car_ID=mat2cell(single_car,1,2);
else
    % 每次循环之后根据概率来判断是否生成新车辆
    in_p=rand(1);   %该循环时刻车辆进入的概率
    if in_p>p
        C(road_length+1,1)=0;   %当有车辆进入的概率达到一定值时，在进入路口处生成一辆车
        car_state=1;    %车辆状态——在道路上“1”
        car_number=car_number+1;    %车辆总数加1
        car_on=car_on+1;            %显示的道路上的车辆总数加1
        car_ID=[car_state,ceil(3*rand(1)),1,road_length+1,ti];   %生成车辆时，生成该车辆数据（车辆状态、道路上车辆的编号、直行/左转/右转）
%         car_ID=mat2cell(single_car,1,2);
    else
        car_ID=[];
    end
end
end