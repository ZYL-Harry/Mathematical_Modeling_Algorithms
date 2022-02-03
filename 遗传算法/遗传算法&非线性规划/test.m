function flag=test(lenchrom,bound,code)
% lenchrom   input : 染色体长度
% bound      input : 变量的取值范围
% code       output: 染色体的编码值

flag=1;
[n,m]=size(code);

for i=1:n
    if code(i)<bound(i,1) || code(i)>bound(i,2)   %判断染色体的编码值是否在变量的取值范围内，如果不是则输出0
        flag=0;
    end
end