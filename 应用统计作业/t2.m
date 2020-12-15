%%
clear all;
close all;
clc;
%% 生成数据
m = 1000;
x1 = randn(m ,1);
x2 = 5 * x1;
% x3 = 3 * x1;
% x4 = x1 + 2*x2 + 4*x3;
x = [x1, x2];
r1 = corr(x, 'type', 'pearson');
%% 分析线性相关性
C = cov(x);
[V, D] = eig(C);