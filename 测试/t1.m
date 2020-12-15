%%
clear,clc,clear all;
y1 = linspace(-1.5,1.5,495);
y2 = -2 * y1.^2 + 0.1 * randn(1,495);
X = [y1' y2'];
y = ones(size(X,1),1);
fault_sample = [-1.25,-1; -0.5,-3; -0.75,0.5; 1,-4; 1,0.75];
%%
SVMModel = fitcsvm(X, y, 'BoxConstraint',1, 'KernelFunction','rbf', 'KernelScale','auto','Standardize',true,'OutlierFraction',0.05);
[~, score] = predict(SVMModel, X);
%%
figure(1);   %画故障检测图像
plot(y1, y2, 'kd');
hold on;
plot(fault_sample(:,1), fault_sample(:,2), 'k.');
figure(2);
plot(score','ko')
line([0,size(X,1)], [0,0],'LineStyle','--','Color','b');    %画线，横坐标从0~960（共960个观测值）
xlabel('sample');
ylabel('score');