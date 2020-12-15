%% 验证score值涵义--为样本点到超平面距离，以支持向量到超平面距离1为标准
clear,clc,close all;
x1 = [0,1; 0,2; 0,3; 0,4; 0,5];    %-1,1; -1,2;-2,1; -3,2;
x2 = [3,1; 3,2; 3,3; 3,4; 3,5];    %5,1; 5,2;6,1; 6,2;
X = [x1;x2];
Y([1:5],1)=1;
Y([6:10],1)=-1;
%%
%% 训练模型
SVMModel = fitcsvm(X, Y);    %使用训练数据及对应标签训练模型 , 'BoxConstraint',10, 'KernelFunction','rbf', 'KernelScale',2^0.5*2
%BoxConstraint:惩罚因子C，，，KernelScale：可改变核函数系数sigma，KernelScale= 根号2∗sigma
sv = SVMModel.IsSupportVector;
%% 获取画等高线所需数据
h = 0.1; % 设置步长，在下面取网格点的时候用
[X1,X2] = meshgrid(min(X(:,1)):h:max(X(:,1)),min(X(:,2)):h:max(X(:,2)));   %将有数据点的区域网格化，
%meshgrid：变换空间，数据点还是原来的那些数据点，但是将空间改变了，所以数据格式改变了
[label,score] = predict(SVMModel,[X1(:),X2(:)]);    %X1(:)将X1中数据转化为列向量，%预测时同理，数据还是那些数据，只不过空间改变了
%第一个返回值label为n*1的矩阵，代表样本X所属的类别，第二个返回值score为N*2的矩阵，代表样本X属于label的可能性，
%score有两列，第一列是X属于第一类的可能性，第二列是X属于第二类的可能性。两列值互为相反数。
scoreGrid = reshape(score(:,2),size(X1,1),size(X2,2));   %在这一步将数据score进行reshape，使其和X1，X2具有相同格式
%因为画等高线时需要输入三个参数：横纵坐标和点的值，其格式应相同  %%score有两列，任取一列即可
%% 画图
figure
gscatter(X(:,1),X(:,2),Y)   %画原始数据散点图
hold on
plot(X(sv,1),X(sv,2),'ko','MarkerSize',10)
contour(X1,X2,scoreGrid,[-1 0 1])    %画等高线，最后一个参数[0 0] 就是只绘制出score值为0的点的等高线, 也就是分界线. 
colorbar;   %显示色阶的颜色栏
legend('positive','negative')   %设置图例标签，把图中出现的数据类型分别命名写上就行
hold off
%%
%% 论文中的数值例子
clear,clc,close all;
y1 = linspace(-1.5,1.5,495);
y2 = -2 * y1.^2 + 0.1 * randn(1,495);
X = [y1' y2'];
y = ones(size(X,1),1);
fault_sample = [-1.25,-1; -0.5,-3; -0.75,0.5; 1,-4; 1,0.75];
%%
SVMModel = fitcsvm(X, y, 'BoxConstraint',1, 'KernelFunction','rbf', 'KernelScale','auto','Standardize',true);
[~, score] = predict(SVMModel, X);
[~, score2] = predict(SVMModel, fault_sample);

h = 0.02; % Mesh grid step size
[X1,X2] = meshgrid(min(X(:,1)):h:max(X(:,1)),min(X(:,2)):h:max(X(:,2)));   
[~,score3] = predict(SVMModel,[X1(:),X2(:)]);   
scoreGrid = reshape(score3,size(X1,1),size(X2,2)); 
%%
figure(1);   %画故障检测图像
plot(y1, y2, 'kd');
hold on;
contour(X1,X2,scoreGrid, [0 0])    %画等高线
colorbar;   %显示色阶的颜色栏
hold on;
plot(fault_sample(:,1), fault_sample(:,2), 'bo');
figure(2);
plot(score','kd')
hold on;
plot(score2','bo')
line([0,size(X,1)], [0,0],'LineStyle','--','Color','b');    %画线，横坐标从0~960（共960个观测值）
xlabel('sample');
ylabel('score');