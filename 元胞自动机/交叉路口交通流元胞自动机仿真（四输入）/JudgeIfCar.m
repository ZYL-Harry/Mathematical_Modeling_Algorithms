function [in_state_o,direction_o]=JudgeIfCar(Car_total,judge_x,judge_y,road_length)
Copy_Car_total=Car_total;
copy_car_3=Copy_Car_total(:,3);
copy_car_2=Copy_Car_total(:,2);
copy_car_4=Copy_Car_total(:,4);
for it=1:size(Copy_Car_total,1)
    if ~isempty(copy_car_3{it})
        copy_car_3{it}(3)=2*road_length+2-copy_car_3{it}(3)+1;
        copy_car_3{it}(4)=2*road_length+2-copy_car_3{it}(4)+1;
    end
    if ~isempty(copy_car_2{it})
        aa=copy_car_2{it}(3);
        bb=copy_car_2{it}(4);
        copy_car_2{it}(3)=2*road_length+2-bb+1;
        copy_car_2{it}(4)=aa;
    end
    if ~isempty(copy_car_4{it})
        aa=copy_car_4{it}(3);
        bb=copy_car_4{it}(4);
        copy_car_4{it}(3)=bb;
        copy_car_4{it}(4)=2*road_length+2-aa+1;
    end
    if isempty(copy_car_3{it})&&isempty(copy_car_2{it})&&isempty(copy_car_4{it})
        break;
    end
end
Copy_Car_total(:,3)=copy_car_3;
Copy_Car_total(:,2)=copy_car_2;
Copy_Car_total(:,4)=copy_car_4;

judge_location=cell(size(Car_total,1),size(Car_total,2));
for ix=1:size(Car_total,1)
    for iy=1:size(Car_total,2)
        judge_location{ix,iy}=[judge_y,judge_x];
    end
end
%遍历所有车辆，找出位置符合的项
index_2=cellfun(@search_2,Copy_Car_total,judge_location);   %符合项为“1”，不符合项为“0”
car_ID=find(index_2);       %车辆在所有车辆中的编号
in_state_o=Car_total{car_ID}(5);
direction_o=Car_total{car_ID}(2);
end