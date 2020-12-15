%%
clear, clc, close all;
%%
load fisheriris;
X = meas(:,1:2);
y = ones(size(X,1),1);  %size(X,1) 返回X数据中第一维的长度
%%
SVMModel = fitcsvm(X, y, 'BoxConstraint',1, 'KernelFunction','rbf', 'KernelScale','auto','Standardize',true,'OutlierFraction',0.05);
svInd = SVMModel.IsSupportVector;
h = 0.02; % Mesh grid step size
[X1,X2] = meshgrid(min(X(:,1)):h:max(X(:,1)),min(X(:,2)):h:max(X(:,2)));    %meshgrid：变换空间，数据点
%还是原来的那些数据点，但是将空间改变了，所以数据格式改变了
t = [X1(:),X2(:)];
[label,score] = predict(SVMModel,[X1(:),X2(:)]);    %预测时同理，数据还是那些数据，只不过空间改变了
scoreGrid = reshape(score,size(X1,1),size(X2,2));   %在这一步将数据score进行reshape，使其和X1，X2具有相同格式
%因为画等高线时需要输入三个参数：横纵坐标和点的值，其格式应相同
%%
figure
plot(X(:,1),X(:,2),'k.')
hold on
plot(X(svInd,1),X(svInd,2),'ro','MarkerSize',10)
contour(X1,X2,scoreGrid, [-1 0 1 10])    %画等高线
colorbar;   %显示色阶的颜色栏
title('{\bf Iris Outlier Detection via One-Class SVM}')
xlabel('Sepal Length (cm)')
ylabel('Sepal Width (cm)')
legend('Observation','Support Vector')
hold off
%%
CVSVMModel = crossval(SVMModel);
[~,scorePred] = kfoldPredict(CVSVMModel);
outlierRate = mean(scorePred<0)
