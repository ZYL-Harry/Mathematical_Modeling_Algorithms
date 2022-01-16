function car_ID=SearchCarData(Car)
%遍历所有车辆，找出子元胞的第1个元素(车辆状态)为0且第2个元素（选择方向）不为零的项
index_1=cellfun(@search_1,Car);   %符合项为“1”，不符合项为“0”
car_ID=find(index_1);       %车辆在所有车辆中的编号
end