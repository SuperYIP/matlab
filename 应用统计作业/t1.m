%%
clear all
clc
close all
%% 加载数据
normal_data = load('E:\Code\matlab\应用统计作业\normal.mat').x;
test_data = load('E:\Code\matlab\应用统计作业\test.mat').y;
%% 求矩阵各变量的相关系数
r1 = corr(normal_data, 'type', 'pearson');
imagesc(r1);    %画相关系数图
colorbar
%% 数据标准化
[x_row, x_col] = size(normal_data);  %获得矩阵x的维度，将行列维度分别赋值给x_row，x_col
meanx = mean(normal_data); %求矩阵x均值
xx = normal_data - meanx;  %中心化(自己生成的数据处理到这里就可以，因为数据不会像工业数据一样出现巨大波动)
% stdx = std(x);   %计算x标准差
% xx = xx / std(x);   %标准化
%% 计算特征值和特征向量矩阵
c = cov(xx); %求xx协方差矩阵
[vector,  value] = eig(c); % vector:特征向量，value:特征值（对角矩阵）
value=diag(value);  %抽取矩阵value对角线元素（抽取出特征向量用于排序），
                    %此时为1维列向量，对一维列向量使用diag则会构成对角矩阵
[value, order] = sort(value,'descend'); %将特征值降序排序
vector = vector(:,order);    %将特征值按照特征向量顺序排序
%% 选取前k个特征值对应的特征向量
CRate = 0.85;   %设置贡献率阈值
index = 0;
while sum(value(1 : index)) / sum(value) < CRate %计算贡献率，贡献率=前n个特征值之和/总特征值之和
    index = index + 1; 
end
value2=value(1:index,:);   %抽取前index个特征值
value2=diag(value2); %将抽取的特征值重新变回对角矩阵
vector2 = vector(:,1:index);    %抽取前index个特征向量
%% 数据降维
normal_data_pca = xx * vector2;   %降维后的数据：中心化后数据乘选取的前k个特征向量
%% 对原始数据进行聚类分析：kmeans
K=3;
[idx,cen]=kmeans(normal_data,K,'Distance','sqeuclidean','Replicates',5,'Display','Final'); %idx是与data中的观测值对应的预测簇索引的向量。cen是包含最终质心位置的 3×2 矩阵。

