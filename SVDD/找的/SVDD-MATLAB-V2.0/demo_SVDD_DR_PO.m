%{
    SVDD application with positive training data
    ( Dimensionality Reduction AND Parameter Optimization)

    Notice:  
    
     (1)     Dimensionality Reduction is realized based on drtoolbox.
             For details about drtoolbox, please visit the website:
             http://lvdmaaten.github.io/drtoolbox/

     (2)     Parameter Optimization is realized based on the YPEA toolbox.
             For details about YPEA toolbox, please visit the website:
             https://yarpiz.com/477/ypea-yarpiz-evolutionary-algorithms?tdsourcetag=s_pctim_aiomsg
%}

%%
clear all
close all
clc
addpath(genpath(pwd))

%% load training data and testing data
load('E:\Code\matlab\SVDD\找的\SVDD-MATLAB-V2.0\data\demoData.mat')

%% Dimensionality Reduction using drtoolbox
%{
------------------------------------------------------------------------
Notice:  

 (1)     Details please see the 'Readme.txt' file in the folder:
         '.\DimensionalityReduction\drtoolbox'  

 (2)     You can change the value of no_dims to the target dimensionality.

------------------------------------------------------------------------
%}
% take Isomap for example
% estimate the intrinsic dimensionality of trainData
% no_dims = round(intrinsic_dim(trainData, 'MLE'));
no_dims = 2;
[trainData, mapping] = compute_mapping(trainData, 'Isomap', no_dims);
testData = out_of_sample(testData, mapping);

%% creat an SVDD object                 
SVDD = Svdd('positiveCost', 0.9,...
            'kernel', Kernel('type', 'gauss', 'width', 16));
        
%% setting of the optimization problem
%{
------------------------------------------------------------------------
Notice:  

 (1)     The default model validation method is k-fold cross-validation.
         You can close the cross-validation by setting the field 'option':
                                       
              'option', struct('type', 'normal',...
                               'display', 'on'));
                                       
 (2)     The field 'parameterName' is the names of the parameters that need
         to be optimized. 

------------------------------------------------------------------------
%}
optimization = struct('model', SVDD,...
                      'parameterName', {{'positiveCost',...
                                         'width'}},...
                      'option', struct('type', 'crossvalidation',...
                                       'Kfolds', 5,...
                                       'display', 'on'));

%% creat the optimization problem
%{
------------------------------------------------------------------------
Notice:  

 (1)     For the property 'vars', it is worth noting:
                
                  problem.vars = ypea_var(...
                        'x', 'real',...
                        'size', 3,...
                        'lower_bound', [10^-1, 10^-1, 2^-5],...
                        'upper_bound', [10^0, 10^0, 2^5]);  

         where 'size' is number of the parameters that need to be optimized.
         The 'lower_bound' and 'upper_bound' are the lower boundary and
         upper boundary of the parameters that need to be optimized. 
         If you wand to change the parameters that need to be optimized, 
         you only need to modify 'size', 'lower_bound', and 'upper_bound'.

------------------------------------------------------------------------
%}
problem = ypea_problem();
problem.type = 'min';
problem.vars = ypea_var('x', 'real',...
                        'size', 2,...
                        'lower_bound', [10^-1, 2^-8],...
                        'upper_bound', [10^0, 2^8]);      
problem.obj_func = @(sol) computeObjValue(sol.x);

%% parameter setting of optimization algorithm 
%{
------------------------------------------------------------------------
Notice:  

 (1)     The parameter setting of different optimization algorithms are
         diffrent. Details please see the m-files in the folder:
         '.\Optimization\ypea-master\src\ypea\doc'  

 (2)     The parameter setting of the optimization algorithm is an important 
         factor affecting the accuracy and speed of the optimization results. 
         Please set the parameters of the optimization algorithm appropriately.
------------------------------------------------------------------------
%}
% take Particle Swarm Optimization (PSO) for example
pso = ypea_pso();
pso.max_iter = 20;
pso.pop_size = 5;
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

%% train and test the SVDD model based on the optimized parameters
% train an SVDD model
model = SVDD.train(trainData, trainLabel);
% test the SVDD model
result = SVDD.test(model, testData, testLabel);

%% Visualization
% plot the curve of testing result
plotTestResult(model, result)
% plot the decision boundary
plotDecisionBoundary(SVDD, model, trainData, trainLabel);
