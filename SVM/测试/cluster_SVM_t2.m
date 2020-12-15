%聚类，然后一分类SVM
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
y = ones(size(data,1),1);
%% kmeans 聚类
K=2;
[idx,cen]=kmeans(data,K,'Distance','sqeuclidean','Replicates',5,'Display','Final'); %idx是与data中的观测值对应的预测簇索引的向量。cen是包含最终质心位置的 3×2 矩阵。

%%  多模态一分类
figure;
for i = 1:K
    data_temp = [data(idx==i,1),data(idx==i,2)];
    y = ones(size(data_temp,1),1);
    SVMModel = fitcsvm(data_temp, y, 'BoxConstraint',1, 'KernelFunction','rbf', 'KernelScale','auto' , 'Standardize',true,'OutlierFraction',0.02);%允许的离群值比例'OutlierFraction',0.01
    sv = SVMModel.IsSupportVector;
    h = 0.05; % Mesh grid step size
    oversize = 10;
    [X1,X2] = meshgrid(min(data_temp(:,1))-oversize:h:max(data_temp(:,1))+oversize,min(data_temp(:,2))-oversize:h:max(data_temp(:,2))+oversize);   
    [~,score] = predict(SVMModel,[X1(:),X2(:)]);   
    scoreGrid = reshape(score,size(X1,1),size(X2,2)); 
    plot(data_temp(:,1), data_temp(:,2),'ko','LineWidth',1,'MarkerFaceColor', '#A2142F'); %画原始数据点,红色
    hold on;
    plot(data_temp(sv,1), data_temp(sv,2),'ko','LineWidth',1,'MarkerFaceColor', '#77AC30'); %画支持向量，绿色
    hold on;
    contour(X1,X2,scoreGrid,[-1 0 1],'ShowText','on','LineWidth',1)
    hold on;
end

