%% SVDD跑论文数值例子
clear all
clc
addpath(genpath(pwd))

%% load training data and testing data
y1 = linspace(-1.5,1.5,495);
y2 = -2 * y1.^2 + 0.1 * randn(1,495);
trainData = [y1' y2'];
trainLabel = ones(size(trainData,1),1);
testData = [-1.25,-1; -0.5,-3; -0.75,0.5; 1,-4; 1,0.75];
testLabel = [-1; -1; -1; -1; -1];
%% creat an SVDD object
SVDD = Svdd('positiveCost', 0.8,...
            'kernel', Kernel('type', 'gauss', 'width', 1));


%% train and test SVDD model
% train an SVDD model 
model = SVDD.train(trainData, trainLabel);
%train有四个输出，第三个支持向量数，第四个支持向量占比
% test the SVDD model
result = SVDD.test(model,testData, testLabel);

%% Visualization
% plot the curve of testing result
plotTestResult(model, result)
plotDecisionBoundary(SVDD, model, trainData, trainLabel);





