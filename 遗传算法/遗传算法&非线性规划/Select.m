function ret=Select(individuals,sizepop)
% ��������ÿһ����Ⱥ�е�Ⱦɫ�����ѡ���Խ��к���Ľ���ͱ���
% individuals input  : ��Ⱥ��Ϣ
% sizepop     input  : ��Ⱥ��ģ
% opts        input  : ѡ�񷽷���ѡ��
% ret         output : ����ѡ������Ⱥ

individuals.fitness= 1./(individuals.fitness);  % ȡ�����ĵ�����Ϊ��Ӧ��
sumfitness=sum(individuals.fitness);
sumf=individuals.fitness./sumfitness;   % ������Ӧ�ȱ�����ѡ����
index=[];
% ���̶ķ�
for i=1:sizepop   %תsizepop�����̣���Ⱦɫ���е�ÿ���������ѡ��
    pick=rand(1);
    while pick==0
        pick=rand(1);
    end
    for j=1:sizepop
        pick=pick-sumf(j);
        if pick<0
            index=[index j];
            break;  %Ѱ����������䣬�˴�ת����ѡ����Ⱦɫ��i��ע�⣺��תsizepop�����̵Ĺ����У��п��ܻ��ظ�ѡ��ĳЩȾɫ��
        end
    end
end
individuals.chrom=individuals.chrom(index,:);
individuals.fitness=individuals.fitness(index);
ret=individuals;