function [C,Car,aa]=multi_MoveCar(car_y,car_x,car_ID,Car,C,road_length,flag,Car_total,Ct,aa,rl)
in_state=Car{car_ID}(5);    %拿到车辆进入输入口的数据（1——左输入；2——上输入；3——右输入；4——下输入）
direction=Car{car_ID}(2);   %拿到车辆的方向数据
C(car_y,car_x)=1;
m=0;    n=0;    v=0;    w=0;   
if flag==1||(flag==0&&car_x>road_length)||(flag==2&&car_x>road_length)  %如果是绿灯，或者红灯情况下在非左侧路段，则正常通行
    if car_x==(road_length)&&car_y==(road_length+2)     %位于停车线
        %判断该车前面一格有没有车辆
        if (in_state==1&&Ct(road_length+2,road_length+1)==1)||(in_state==3&&Ct(road_length+1,road_length+2)==1)||(in_state==2&&Ct(road_length+1,road_length+1)==1)||(in_state==4&&Ct(road_length+2,road_length+2)==1)
            if in_state==1
                judge_x_1=road_length+1;
                judge_y_1=road_length+1;
                judge_x_2=road_length+2;
                judge_y_2=road_length+1;
                judge_x_3=road_length+3;
                judge_y_3=road_length+1;
                judge_x_4=road_length+4;
                judge_y_4=road_length+1;
                judge_x_5=road_length+5;
                judge_y_5=road_length+1;
            elseif in_state==3
                judge_x_1=road_length+2;
                judge_y_1=road_length+2;
                judge_x_2=road_length+1;
                judge_y_2=road_length+2;
                judge_x_3=road_length;
                judge_y_3=road_length+2;
                judge_x_4=road_length-1;
                judge_y_4=road_length+2;
                judge_x_5=road_length-2;
                judge_y_5=road_length+2;
            elseif in_state==2
                judge_x_1=road_length+2;
                judge_y_1=road_length+1;
                judge_x_2=road_length+2;
                judge_y_2=road_length+2;
                judge_x_3=road_length+2;
                judge_y_3=road_length+3;
                judge_x_4=road_length+2;
                judge_y_4=road_length+4;
                judge_x_5=road_length+2;
                judge_y_5=road_length+5;
            elseif in_state==4
                judge_x_1=road_length+1;
                judge_y_1=road_length+2;
                judge_x_2=road_length+1;
                judge_y_2=road_length+1;
                judge_x_3=road_length+1;
                judge_y_3=road_length;
                judge_x_4=road_length+1;
                judge_y_4=road_length-1;
                judge_x_5=road_length+1;
                judge_y_5=road_length-2;
            end
            if Ct(judge_y_1,judge_x_1)==1
                %左前方一格没有车则正常通行
                new_y=car_y;
                new_x=car_x+1;
            else
                %左前方一格有车，则判断其与自身优先级与自己的方向
                [in_state_o,direction_o]=JudgeIfCar(Car_total,judge_x_1,judge_y_1,road_length);
                if in_state<in_state_o&&direction~=2    %判断优先级和方向是否~=2的车辆就可以通行
                    new_y=car_y;
                    new_x=car_x+1;
                else   %剩下方向==2的车辆
                    if in_state>in_state_o   %自身优先级低时，等待
                        new_y=car_y;
                        new_x=car_x;
                    else   %direction==2
                        a_2=Ct(judge_y_2,judge_x_2);
                        a_5=Ct(judge_y_5,judge_x_5);
                        a_3=Ct(judge_y_3,judge_x_3);
                        a_4=Ct(judge_y_4,judge_x_4);
                        if a_2==1&&a_5==1&&a_3==1&&a_4==1   %判断左前方两~五格有没有车
                            new_y=car_y;
                            new_x=car_x+1;
                        else
                            %判断左前方两~五格有车但direction_o==3的情况
                            if a_2==0
                                [in_state_o,direction_o]=JudgeIfCar(Car_total,judge_x_2,judge_y_2,road_length);
                                if direction_o==3
                                    m=1;
                                end
                            end
                            if a_3==0
                                [in_state_o,direction_o]=JudgeIfCar(Car_total,judge_x_3,judge_y_3,road_length);
                                if direction_o==3
                                    n=1;
                                end
                            end
                            if a_4==0
                                [in_state_o,direction_o]=JudgeIfCar(Car_total,judge_x_4,judge_y_4,road_length);
                                if direction_o==3
                                    v=1;
                                end
                            end
                            if a_5==0
                                [in_state_o,direction_o]=JudgeIfCar(Car_total,judge_x_5,judge_y_5,road_length);
                                if rl<=2
                                    w=1;
                                end
                            end
                            if m==1&&n==1&&v==1&&w==1
                                new_y=car_y;
                                new_x=car_x+1;
                            else
                                new_y=car_y;
                                new_x=car_x;
                                aa=1;
                            end
                        end
                    end
                end
            end
        else %前面一格有车辆则等待
            new_y=car_y;
            new_x=car_x;
        end
    elseif car_x==(road_length+1)&&car_y==(road_length+2)   %离开停车线一格
        if direction==3
            new_y=car_y+1;
            new_x=car_x;
        else
            if (in_state==1&&Ct(road_length+2,road_length+2)==1)||(in_state==3&&Ct(road_length+1,road_length+1)==1)||(in_state==2&&Ct(road_length+2,road_length+1)==1)||(in_state==4&&Ct(road_length+1,road_length+2)==1)
                if direction==1
                    new_y=car_y;
                    new_x=car_x+1;
                elseif direction==2
                    new_y=car_y;
                    new_x=car_x+1;
                end
            else
                new_y=car_y;
                new_x=car_x;
            end
        end
    elseif car_x==(road_length+2)&&car_y==(road_length+2)   %离开停车线两格
        if direction==1
            new_y=car_y;
            new_x=car_x+1;
        elseif direction==2
            %判断左侧一格有没有车
            if (in_state==1&&Ct(road_length+1,road_length+2)==1)||(in_state==3&&Ct(road_length+2,road_length+1)==1)||(in_state==2&&Ct(road_length+2,road_length+2)==1)||(in_state==4&&Ct(road_length+1,road_length+1)==1)
                if in_state==1
                    judge_x=road_length+3;
                    judge_y=road_length+1;
                elseif in_state==3
                    judge_x=road_length;
                    judge_y=road_length+2;
                elseif in_state==2
                    judge_x=road_length+2;
                    judge_y=road_length+3;
                elseif in_state==4
                    judge_x=road_length+1;
                    judge_y=road_length;
                end
                if flag==0||flag==2||Ct(judge_y,judge_x)==1
                    new_y=car_y-1;
                    new_x=car_x;
                else
                    [in_state_o,direction_o]=JudgeIfCar(Car_total,judge_x,judge_y,road_length);
                    if aa==1
                        aa=0;
                        new_y=car_y-1;
                        new_x=car_x;
                    elseif in_state<in_state_o
                        new_y=car_y-1;
                        new_x=car_x;
                    else
                        new_y=car_y;
                        new_x=car_x;
                    end
                end
            else
                new_y=car_y;
                new_x=car_x;
            end
        end
    elseif car_x~=(road_length)&&car_x~=(road_length+1)&&car_x~=(road_length+2)&&car_y==(road_length+2)   %判断车的位置是否在横向的路段
        if C(car_y,car_x+1)==1
            new_y=car_y;
            new_x=car_x+1;
        else
            new_y=car_y;
            new_x=car_x;
        end
    elseif car_x==(road_length+2)&&car_y<(road_length+2)    %判断车的位置是否在向上的路段
        new_y=car_y-1;
        new_x=car_x;
    elseif car_x==(road_length+1)&&car_y>(road_length+2)    %判断车的位置是否在向下的路段
        new_y=car_y+1;
        new_x=car_x;
    end
else   %如果是红灯，则先判断有没有到路口，再判断能不能向前通行
    if car_x==road_length&&car_y==(road_length+2)   %判断车的位置是否到达路口处
        new_y=car_y;
        new_x=car_x;
    elseif car_x<road_length&&car_y==(road_length+2)    %判断车的位置未到达路口而在左侧路段
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