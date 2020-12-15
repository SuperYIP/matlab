%% 张老师上课留的作业
clear
clc
close all
%% 协方差矩阵（已知）
c = [2 2 -2; 2 5 -4; -2 -4 5];  %协方差矩阵
[vector,  value] = eig(c);  % vector:特征向量，value:特征值（对角矩阵）
value = diag(value);    %抽取矩阵对角线
[value, order] = sort(value, 'descend'); %将特征值降序排序
vector = vector(:,order);    %将特征值按照特征向量顺序排序
%% 计算贡献率，贡献率=前n个特征值之和/总特征值之和
for i = 1:size(value,1)
    CRate(i) = value(i) / sum(value);    %保存贡献率，各主成分贡献率 = 各主成分特征值/总特征值之和
end

%% 计算各主成分，以下代码无法运行！
for j = 1:size(vector,2)    % 得到vector的列数，即主成分个数
   y(j) = X * vector(:,1);  % 计算各主成分
end