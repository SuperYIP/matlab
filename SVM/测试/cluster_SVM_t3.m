%聚类，然后二分类SVM,不太行
%% 初始化工作空间
clc
clear all
close all
%% 数值例子
n = 100;
t = randn(n,2);
e = 0.1* randn(n,2);
I = ones(n,1);
A = I * [-15,5] + t + e;
B = I * [25,-10] + 8*t + e;
data = [A; B];
%% kmeans 聚类
K=2;
[idx,cen]=kmeans(data,K,'Distance','sqeuclidean','Replicates',5); %idx是与data中的观测值对应的预测簇索引的向量。cen是包含最终质心位置的 3×2 矩阵。

%%  二分类
SVMModel = fitcsvm(data, idx, 'BoxConstraint',10, 'KernelFunction','rbf', 'KernelScale','auto' , 'Standardize',true,'OutlierFraction',0.02);%允许的离群值比例'OutlierFraction',0.01
ks = SVMModel.KernelParameters.Scale;
sv = SVMModel.IsSupportVector;
h = 0.05; % Mesh grid step size
oversize = 10;
[X1,X2] = meshgrid(min(data(:,1))-oversize:h:max(data(:,1))+oversize,min(data(:,2))-oversize:h:max(data(:,2))+oversize);   
[~,score] = predict(SVMModel,[X1(:),X2(:)]);   
scoreGrid = reshape(score(:,2),size(X1,1),size(X2,2)); 
%%
figure;
plot(data(:,1), data(:,2),'ko','LineWidth',1,'MarkerFaceColor', '#A2142F'); %画原始数据点,红色
hold on;
plot(data(sv,1), data(sv,2),'ko','LineWidth',1,'MarkerFaceColor', '#77AC30'); %画支持向量，绿色
hold on;
contour(X1,X2,scoreGrid,[-1 0 1],'ShowText','on','LineWidth',1)
hold on;

