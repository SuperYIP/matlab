%使用matlab自带的关于花的数据进行二分类实验（150*4），其中，每一行代表一朵花，
%共有150行（朵)，每一朵包含4个属性值（特征），即4列。且每1-50，51-100，101-150行的数据为同一类，分别为setosa青风藤类，versicolor云芝类，virginica锦葵类
%%
%二分类SVM例子，画出支持向量和分类超平面
%%
clear, clc, close all;
%% 获取数据，软间隔数值例子
load fisheriris     %下载数据包含：meas（150*4花特征数据）,和species（150*1 花的类属性数据）
%去除setosa一类，将数据变为二类数据
inds = ~strcmp(species,'setosa');   %strcmp比较两字符串，相同返回1，不同返回0；~取反的意思
X = meas(inds,3:4); %取数据后两个维度，去掉"setosa"这种花的数据
Y = species(inds);  %去掉"setosa"这种花的数据所对应的label
% %% 硬间隔数值例子
% %训练数据20 x 2,20行代表20个训练样本点，第一列代表横坐标，第二列纵坐标
% X = [-3 0;4 0;4 -2;3 -3;-3 -2;1 -4;-3 -4;0 1; -1 0;...
%     2 2; 3 3; -2 -1;-4.5 -4; 2 -1;5 -4;-2 2;-2 -3;0 2;1 -2;2 0];
% %Group 20 x 1, 20行代表训练数据对应点属于哪一类（1类，-1类）
% Y = [1 -1 -1 -1 1 -1 1 1 1 -1 -1 1 1 -1  -1 1 1 1 -1 -1]';
%% 训练模型
SVMModel = fitcsvm(X,Y);    %使用训练数据及对应标签训练模型
% SVMModel = fitcsvm(X,Y,'Standardize',true);  %1.标准化数据。。2处需做相应改动
sv = SVMModel.SupportVectors;   %获取支持向量
% sv = SVMModel.IsSupportVector;  %2.支持向量获取方式改变，此时变为在原始数据标注是否为支持向量。。3处画图要相应改变 
%% 获取画等高线所需数据
h = 0.02; % 设置步长，在下面取网格点的时候用
[X1,X2] = meshgrid(min(X(:,1)):h:max(X(:,1)),min(X(:,2)):h:max(X(:,2)));   %将有数据点的区域网格化，
%meshgrid：变换空间，数据点还是原来的那些数据点，但是将空间改变了，所以数据格式改变了
[label,score] = predict(SVMModel,[X1(:),X2(:)]);    %X1(:)将X1中数据转化为列向量，%预测时同理，数据还是那些数据，只不过空间改变了
%第一个返回值label为n*1的矩阵，代表样本X所属的类别，第二个返回值score为N*2的矩阵，代表样本X属于到超平面的距离
%score有两列，两列值互为相反数。超平面处score值=0，支持向量处score值为正负一，其余点的距离值以支持向量值为标准
scoreGrid = reshape(score(:,2),size(X1,1),size(X2,2));   %在这一步将数据score进行reshape，使其和X1，X2具有相同格式
%因为画等高线时需要输入三个参数：横纵坐标和点的值，其格式应相同  %%score有两列，任取一列即可
%% 画图
figure
gscatter(X(:,1),X(:,2),Y)   %画原始数据散点图
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)  %画支持向量，在支持向量外画黑圈，黑圈大小为10
% plot(X(sv,1),X(sv,2),'ko','MarkerSize',10)  %3.画支持向量。。sv此时是一列0，1值，指示原数据的支持向量位置
contour(X1,X2,scoreGrid,[-1 0 1])    %画等高线，最后一个参数[0 0] 就是只绘制出score值为0的点的等高线, 也就是分界线. 
%[-1 0 1]，即画3条等高线，值分别为-1，0，1。如果想画一条，如值为0的等高线，即[0 0]  %score=0，即w*x+b=0，即分类超平面
colorbar;   %显示色阶的颜色栏
legend('positive','negative','Support Vector')   %设置图例标签，把图中出现的数据类型分别命名写上就行
hold off

%跑banana数据集
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
% plot(X(sv,1),X(sv,2),'ko','MarkerSize',10)
contour(X1,X2,scoreGrid,[0 0],'LineWidth',1)    %画等高线，最后一个参数[0 0] 就是只绘制出score值为0的点的等高线, 也就是分界线. 
% colorbar;   %显示色阶的颜色栏
legend('positive','negative')   %设置图例标签，把图中出现的数据类型分别命名写上就行
hold off

