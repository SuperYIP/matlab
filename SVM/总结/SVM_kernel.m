%% 生成椭圆套椭圆数据
clear,clc,clear all;
ecc = axes2ecc(8,5);  % 根据长半轴和短半轴计算椭圆偏心率
[elat,elon] = ellipse1(1,2,[10 ecc],45);
x = [elat,elon] + randn(100,1);
ecc2 = axes2ecc(6,3);  % 根据长半轴和短半轴计算椭圆偏心率
[elat2,elon2] = ellipse1(1,2,[6 ecc],45);
y = [elat2,elon2] + randn(100,1);
X = [x;y];
Y([1:100],1)=1;
Y([101:200],1)=-1;
%%
%% 训练模型
SVMModel = fitcsvm(X, Y, 'BoxConstraint',10, 'KernelFunction','rbf', 'KernelScale',2^0.5*2);    %使用训练数据及对应标签训练模型
%BoxConstraint:惩罚因子C，，，KernelScale：可改变核函数系数sigma，KernelScale= 根号2∗sigma
%高斯核的参数σ取值与样本的划分精细程度有关：σ越小，低维空间中选择的曲线越复杂，试图将每个样本与其他样本都区分开来；分的类别越细，容易出现过拟合；σ越大，分的类别越粗，可能导致无法将数据区分开来，容易出现欠拟合。
%惩罚因子C的取值权衡了经验风险和结构风险：C越大，经验风险越小，结构风险越大，容易出现过拟合；C越小，模型复杂度越低，容易出现欠拟合。
sv = SVMModel.IsSupportVector;
%% 获取画等高线所需数据
h = 0.02; % 设置步长，在下面取网格点的时候用
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
legend('versicolor','virginica')   %设置图例标签，把图中出现的数据类型分别命名写上就行
hold off
%%
