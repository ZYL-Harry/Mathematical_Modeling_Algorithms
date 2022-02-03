function ret=Select(individuals,sizepop)
% 本函数对每一代种群中的染色体进行选择，以进行后面的交叉和变异
% individuals input  : 种群信息
% sizepop     input  : 种群规模
% opts        input  : 选择方法的选择
% ret         output : 经过选择后的种群

individuals.fitness= 1./(individuals.fitness);  % 取函数的倒数作为适应度
sumfitness=sum(individuals.fitness);
sumf=individuals.fitness./sumfitness;   % 基于适应度比例的选择函数
index=[];
% 轮盘赌法
for i=1:sizepop   %转sizepop次轮盘，对染色体中的每个个体进行选择
    pick=rand(1);
    while pick==0
        pick=rand(1);
    end
    for j=1:sizepop
        pick=pick-sumf(j);
        if pick<0
            index=[index j];
            break;  %寻找落入的区间，此次转轮盘选中了染色体i，注意：在转sizepop次轮盘的过程中，有可能会重复选择某些染色体
        end
    end
end
individuals.chrom=individuals.chrom(index,:);
individuals.fitness=individuals.fitness(index);
ret=individuals;