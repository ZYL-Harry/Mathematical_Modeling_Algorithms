%% 随机生成两簇数据并绘制出来
X = [randn(100,2)*0.75+ones(100,2);
    randn(100,2)*0.5-ones(100,2)];
figure;
plot(X(:,1),X(:,2),'.');
title 'Randomly Generated Data';

%% K均值聚类处理
%K均值聚类相关参数的处理及kmeans函数
opts = statset('Display','final');
[idx,C] = kmeans(X,2,'Distance','cityblock','Replicates',5,'Options',opts);
%idx——与 X 中的观测值对应的预测簇索引的向量
%C——聚类最终的质心位置

figure;
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx','MarkerSize',15,'LineWidth',3) 
legend('Cluster 1','Cluster 2','Centroids','Location','NW')
title 'Cluster Assignments and Centroids'
hold off
