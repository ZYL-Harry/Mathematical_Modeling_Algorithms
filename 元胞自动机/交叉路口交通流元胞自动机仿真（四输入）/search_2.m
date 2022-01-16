function z=search_2(Car,judge_location)    %找出子元胞的第1个元素为1且非空的项，并赋值“1”，其余赋值“0”
y=judge_location(1);
x=judge_location(2);
if ~isempty(Car)&&Car(3)==x&&Car(4)==y
    z=1;
else
    z=0;
end
end