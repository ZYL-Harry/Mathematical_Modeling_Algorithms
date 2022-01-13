function y=search_1(Car)    %找出子元胞的第1个元素为1且非空的项，并赋值“1”，其余赋值“0”
if ~isempty(Car)&&Car(1)==1
    y=1;
else
    y=0;
end
end