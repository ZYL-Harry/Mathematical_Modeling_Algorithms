function judge=multi_JudgeMarginCar(car_y,car_x,road_length)
if car_x==(2*road_length+2)||car_y==1||car_y==(2*road_length+2)
    judge=1;
else
    judge=0;
end
end