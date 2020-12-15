%% 直接SVDD
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
%%
SVDD = Svdd('positiveCost', 0.9,...
            'kernel', Kernel('type', 'gauss', 'width', 10),...
            'option', struct('display', 'on'));
    
%%
model = SVDD.train(trainData, trainLabel);  %function [net,tr,out3,out4,out5,out6]=train(net,varargin)
%%
plotDecisionBoundary(SVDD, model, trainData, trainLabel);
