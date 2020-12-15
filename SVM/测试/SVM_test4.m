%%
clear, clc, close all;
%%
x = load("E:\Code\matlab\PCA\TE数据\不分模态\测试集\d00_te.dat");   %全部为正常数据
f = load("E:\Code\matlab\PCA\TE数据\不分模态\测试集\d01_te.dat");    %共采集960个观测值，其中前160个观测值为正常数据。
X = x(:,[1:22, 42:52]); %选取其中33维
y = ones(size(X,1),1);  %size(X,1) 返回X数据中第一维的长度
f = f(:,[1:22, 42:52]);
%%
SVMModel = fitcsvm(X, y, 'BoxConstraint',1, 'KernelFunction','rbf', 'KernelScale','auto', 'Standardize',true,'OutlierFraction',0.05);
[~,score] = predict(SVMModel,f);    %预测时同理，数据还是那些数据，只不过空间改变了
%%
figure(2)   %画故障检测图像
plot(score','ko')
line([0,size(X,1)], [0,0],'LineStyle','--','Color','b');    %画线，横坐标从0~960（共960个观测值）
xlabel('sample');
ylabel('score');
