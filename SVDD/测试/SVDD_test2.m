%% 聚类+SVDD
clear,clc,close all;
%% 
n = 100;
t = randn(n,2);
e = 0.1* randn(n,2);
I = ones(n,1);
A = I * [-15,5] + t + e;
B = I * [25,-10] + 8*t + e;
trainData = [A; B];
trainLabel = ones(size(trainData,1),1);
%% kmeans 聚类
K=2;
[idx,cen]=kmeans(trainData,K,'Distance','sqeuclidean','Replicates',5,'Display','Final'); %idx是与data中的观测值对应的预测簇索引的向量。cen是包含最终质心位置的 3×2 矩阵。
%%
SVDD = Svdd('positiveCost', 0.9,...
            'kernel', Kernel('type', 'gauss', 'width', 14),...
            'option', struct('display', 'on'));
    
%% 循环训练每个模态
for i = 1:K
    data_temp = [trainData(idx==i,1),trainData(idx==i,2)];
    label_temp = ones(size(data_temp,1),1);
    model = SVDD.train(data_temp, label_temp);
    plotDecisionBoundary(SVDD, model, data_temp, label_temp);
end

%%

