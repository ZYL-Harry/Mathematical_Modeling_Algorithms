%% 该实例中未进行参数调节，只进行了SVM分类
clc;clear;

%% 1. 生成训练集
% 生成3类样本（二维高斯分布）
mu = [5 5];
sigma = [1 0; 0 1];
X_1 = mvnrnd(mu, sigma, 100);
label_1 = ones(100, 1);
 
mu = [3 9];
sigma = [1 0; 0 1];
X_2 = mvnrnd(mu, sigma, 100);
label_2 = 2*ones(100, 1);
 
mu = [-1 7];
sigma = [1 0; 0 1];
X_3 = mvnrnd(mu, sigma, 100);
label_3 = 3*ones(100, 1);
 
% 整理
data = [X_1; X_2; X_3];
label = [label_1; label_2; label_3];

% 可视化
color_p = [150, 138, 191;12, 112, 104; 220, 94, 75]/255;
figure
ax = gscatter(data(:,1), data(:,2), label);
set(ax(1), 'Marker','o', 'MarkerSize', 7, 'MarkerEdgeColor','k', 'MarkerFaceColor', color_p(1,:));
set(ax(2), 'Marker','o', 'MarkerSize', 7, 'MarkerEdgeColor','k', 'MarkerFaceColor', color_p(2,:));
set(ax(3), 'Marker','o', 'MarkerSize', 7, 'MarkerEdgeColor','k', 'MarkerFaceColor', color_p(3,:));
legend('off')
set(gca, 'linewidth', 1.1)
title('Original data')
axis tight

%% 2. 训练SVM模型并对训练数据做预测
c = 0.7;  % trade-off parameter
g = 0.01; % kernel width
% 训练 SVM 模型 （选择高斯核函数）
cmd = ['-s', num2str(0), '-t', num2str(2), '-c ', num2str(c), ' -g ', num2str(g)];
%训练——svmtrain函数
model = svmtrain(label, data, cmd);
%svmtrain函数的返回值：SVM分类器模型
% 函数的第三个参数：
%     -s svm类型：SVM设置类型（默认0)
% 　　　　0 — C-SVC； 1 –v-SVC； 2 – 一类SVM； 3 — e-SVR； 4 — v-SVR
%     -t 核函数类型：核函数设置类型（默认2）
% 　　　　0 – 线性核函数：u’v
% 　　　　1 – 多项式核函数：（r*u’v + coef0)^degree
% 　　　　2 – RBF(径向基)核函数：exp(-r|u-v|^2）
% 　　　　3 – sigmoid核函数：tanh(r*u’v + coef0)
%     -d degree：核函数中的degree设置（针对多项式核函数）（默认3）
%     -g r(gamma）：核函数中的gamma函数设置（针对多项式/rbf/sigmoid核函数）（默认1/k，k为总类别数)
%     -r coef0：核函数中的coef0设置（针对多项式/sigmoid核函数）（（默认0)
%     -c cost：设置C-SVC，e -SVR和v-SVR的参数（损失函数）（默认1）
%     -n nu：设置v-SVC，一类SVM和v- SVR的参数（默认0.5）
%     -p p：设置e -SVR 中损失函数p的值（默认0.1）
%     -m cachesize：设置cache内存大小，以MB为单位（默认40）
%     -e eps：设置允许的终止判据（默认0.001）
%     -h shrinking：是否使用启发式，0或1（默认1）
%     -wi weight：设置第几类的参数C为weight*C (C-SVC中的C) （默认1）
%     -v n: n-fold交互检验模式，n为fold的个数，必须大于等于2
% 以上这些参数设置可以按照SVM的类型和核函数所支持的参数进行任意组合，
% 如果设置的参数在函数或SVM类型中没有也不会产生影响，程序不会接受该参数；如果应有的参数设置不正确，参数将采用默认值。

%预测——svmpredict函数
[~, acc, ~] = svmpredict(label, data, model);   %真正仅返回精度 
%svmpredict函数的返回值：
%第一个返回值是样本的预测类标号
%The first one, predictd_label, is a vector of predicted labels.
%第二个返回值是分类的正确率、回归的均方根误差、回归的平方相关系数
%The second output,accuracy, is a vector including accuracy (for classification), mean squared error, and squared correlation coefficient (for regression).
%第三个返回值是一个矩阵包含决策的值或者概率估计
%The third is a matrix containing decision values or probability estimates (if '-b 1' is specified).

%% 生成网格点并对所有坐标进行预测分类从而可以绘制底图
% 生成网格点
d = 0.02;
[X1, X2] = meshgrid(min(data(:,1)):d:max(data(:,1)), min(data(:,2)):d:max(data(:,2)));%得到所需网格的大小即其中所有坐标（X1：所有列，X2：所有行）
X_grid = [X1(:), X2(:)];    %点的“行”与“列”放在两列中
% 设定网格点标签（仅充当输入参数）
grid_label = ones(size(X_grid, 1), 1);

% 预测网格点标签
[pre_label, ~, ~] = svmpredict(grid_label, X_grid, model);
%由model所对应的模型（点的分布）将个坐标点分为三类

% 绘制网格点标签散点图
figure
color_b = [218, 216, 232; 179, 226, 219; 244, 195, 171]/255; % 边界区域颜色
gscatter(X_grid (:,1), X_grid (:,2), pre_label, color_b);
legend('off')
axis tight

%% 绘制原始坐标点+预测图
figure
color_p = [150, 138, 191;12, 112, 104; 220, 94, 75]/255; % 数据点颜色
color_b = [218, 216, 232; 179, 226, 219; 244, 195, 171]/255; % 边界区域颜色
hold on
ax(1:3) = gscatter(X_grid (:,1), X_grid (:,2), pre_label, color_b); %由对所有坐标点做预测所构成的划分图作为底层
legend('off')
axis tight

ax(4:6) = gscatter(data(:,1), data(:,2), label);    %绘制用于训练的点，可以看到训练效果
set(ax(4), 'Marker','o', 'MarkerSize', 7, 'MarkerEdgeColor','k', 'MarkerFaceColor', color_p(1,:));
set(ax(5), 'Marker','o', 'MarkerSize', 7, 'MarkerEdgeColor','k', 'MarkerFaceColor', color_p(2,:));
set(ax(6), 'Marker','o', 'MarkerSize', 7, 'MarkerEdgeColor','k', 'MarkerFaceColor', color_p(3,:));
legend('off')
set(gca, 'linewidth', 1.1)
title('Decision boundary (gaussian kernel function)')
axis tight
