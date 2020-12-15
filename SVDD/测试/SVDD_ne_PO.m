%{
   SVDD跑论文数值例子，使用工具包中的自动调参。。
%}

%%
clear all
close all
clc
addpath(genpath(pwd))

%% 数值例子
y1 = linspace(-1.5,1.5,495);
y2 = -2 * y1.^2 + 0.1 * randn(1,495);
trainData = [y1' y2'];
trainLabel = ones(size(trainData,1),1);
testData = [-1.25,-1; -0.5,-3; -0.75,0.5; 1,-4; 1,0.75];
testLabel = [-1; -1; -1; -1; -1];
%% creat an SVDD object
SVDD = Svdd('positiveCost', 0.9,... %惩罚因子C
            'kernel', Kernel('type', 'gauss', 'width', 1),...   %核函数系数西格玛
            'option', struct('display', 'on'));

%% setting of the optimization problem
optimization = struct('model', SVDD,...
                      'parameterName', {{'positiveCost',...
                                         'width'}},...
                      'option', struct('type', 'crossvalidation',...    %交叉验证，5折
                                       'Kfolds', 5,...
                                       'display', 'on'));

%% creat the optimization problem
problem = ypea_problem();
problem.type = 'min';   %???
problem.vars = ypea_var('x', 'real',...
                        'size', 2,...   %变量数
                        'lower_bound', [10^-1, 2^-8],...
                        'upper_bound', [10^0, 2^8]);   
% sphere = ypea_test_function('sphere');
problem.obj_func = @(sol) computeObjValue(sol.x);

%% parameter setting of optimization algorithm 
pso = ypea_pso();
pso.max_iter = 20; %最大迭代次数
pso.pop_size = 20;
pso.w = 0.5;
pso.wdamp = 1;
pso.c1 = 1;
pso.c2 = 2;
phi1 = 2.05;
phi2 = 2.05;
pso.use_constriction_coeffs(phi1, phi2);

% get the optimized parameters of SVDD and kernel 
pso_best_sol = pso.solve(problem);
SVDD = getOptimizedResult(optimization, pso_best_sol.solution.x);

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





