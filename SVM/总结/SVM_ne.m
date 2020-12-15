%% Numerical examples：数值例子；；论文中的数值例子实现
clear,clc,close all;
y1 = linspace(-1.5,1.5,495);
y2 = -2 * y1.^2 + 0.1 * randn(1,495);
X = [y1' y2'];
y = ones(size(X,1),1);
fault_sample = [-1.25,-1; -0.5,-3; -0.75,0.5; 1,-4; 1,0.75];


% X = [X; fault_sample];    %训练样本中包含离群点
% y = ones(size(X,1),1);
%%
SVMModel = fitcsvm(X, y, 'BoxConstraint',1, 'KernelFunction','rbf', 'KernelScale',0.3, 'Standardize',true);%允许的离群值比例'OutlierFraction',0.01
ks = SVMModel.KernelParameters.Scale;   %输出模型核参数ks值。
%KernelScale：按原始内核比例缩放的RBF西格玛参数，是根号2倍的西格玛，本例0.3左右，数值越小，拟合的越好
[~, score] = predict(SVMModel, X);
[~, score2] = predict(SVMModel, fault_sample);

h = 0.02; % Mesh grid step size
[X1,X2] = meshgrid(min(X(:,1)):h:max(X(:,1)),min(X(:,2)):h:max(X(:,2)));   
[~,score3] = predict(SVMModel,[X1(:),X2(:)]);   
scoreGrid = reshape(score3,size(X1,1),size(X2,2)); 
%%
figure(1);   %画原始数据和超平面
plot(y1, y2, 'kd');
hold on;
contour(X1,X2,scoreGrid, [0 0])    %画等高线
colorbar;   %显示色阶的颜色栏
hold on;
plot(fault_sample(:,1), fault_sample(:,2), 'bo');   %画故障点
figure(2);  %画故障检测
plot(score','kd')
hold on;
plot(score2','bo')
line([0,size(X,1)], [0,0],'LineStyle','--','Color','b');    %画线，横坐标从0~960（共960个观测值）
xlabel('sample');
ylabel('score');