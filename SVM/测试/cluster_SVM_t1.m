%没有聚类，直接用一分类SVM
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
data = [A;B];
y = ones(size(data,1),1);

%% 一分类
SVMModel = fitcsvm(data, y, 'BoxConstraint',1, 'KernelFunction','rbf', 'KernelScale','auto' , 'Standardize',true,'OutlierFraction',0.01);%允许的离群值比例'OutlierFraction',0.01
ks = SVMModel.KernelParameters.Scale;   %输出模型核参数ks值。
sv = SVMModel.IsSupportVector;
h = 0.05; % Mesh grid step size
[X1,X2] = meshgrid(min(data(:,1))-10:h:max(data(:,1))+10,min(data(:,2))-10:h:max(data(:,2))+10);   
[~,score] = predict(SVMModel,[X1(:),X2(:)]);   
scoreGrid = reshape(score,size(X1,1),size(X2,2)); 

%%
figure;   %画原始数据和超平面
plot(data(:,1), data(:,2),'ko','LineWidth',1,'MarkerFaceColor', '#A2142F'); %画原始数据点，红色
hold on;
plot(data(sv,1), data(sv,2),'ko','LineWidth',1,'MarkerFaceColor', '#77AC30'); %画支持向量，绿色
hold on;
contour(X1,X2,scoreGrid,[-1 0 1],'ShowText','on','LineWidth',1)    %画等高线
