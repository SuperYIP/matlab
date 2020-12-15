%% 跑banana数据集
clear,clc,clear all;
load('E:\Code\matlab\SVDD\找的\SVDD-MATLAB-V2.0\data\banana.mat');
X = [banana(:,1),banana(:,2)];
Y = banana(:,3);
%%
%% 训练模型
SVMModel = fitcsvm(X, Y, 'BoxConstraint',10, 'KernelFunction','rbf', 'KernelScale','auto');    %使用训练数据及对应标签训练模型
sv = SVMModel.IsSupportVector;
%% 获取画等高线所需数据
h = 0.02; % 设置步长，在下面取网格点的时候用
[X1,X2] = meshgrid(min(X(:,1)):h:max(X(:,1)),min(X(:,2)):h:max(X(:,2)));   %将有数据点的区域网格化，
[label,score] = predict(SVMModel,[X1(:),X2(:)]);    %X1(:)将X1中数据转化为列向量，%预测时同理，数据还是那些数据，只不过空间改变了
scoreGrid = reshape(score(:,2),size(X1,1),size(X2,2));   %在这一步将数据score进行reshape，使其和X1，X2具有相同格式
%% 画图
figure
gscatter(X(:,1),X(:,2),Y)   %画原始数据散点图
hold on
plot(X(sv,1),X(sv,2),'ko','MarkerSize',10)
contour(X1,X2,scoreGrid,[-1 0 1],'LineWidth',1)    %画等高线，最后一个参数[0 0] 就是只绘制出score值为0的点的等高线, 也就是分界线. 
% colorbar;   %显示色阶的颜色栏
legend('positive','negative')   %设置图例标签，把图中出现的数据类型分别命名写上就行
hold off

