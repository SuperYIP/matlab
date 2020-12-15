%% %PCA
%%% 此程序所学知识：
%%  数据生成  生成二维数据，x2=x1+b，b为随机数==》线性带噪声数据
clear,clc,close all;
x1 = randn(100, 1); %生成100行1列的高斯随机数
x2 = x1 + 0.1 * randn(100,1); %给x2数据加入噪声
x = [x1 x2]; %将x1和X2放到一个矩阵中

%% 数据标准化
[x_row, x_col] = size(x);  %获得矩阵x的维度，将行列维度分别赋值给x_row，x_col
meanx = mean(x); %求矩阵均值
xx1 = x - meanx;  %中心化(自己生成的数据处理到这里就可以，因为数据不会像工业数据一样出现巨大波动)
% stdx = std(x);   %计算标准差
% xx = xx / std(x);   %标准化
%% 计算特征值和特征向量矩阵
c = cov(xx1); %求协方差矩阵
[vector,  value] = eig(c); % vector:特征向量，value:特征值（对角矩阵）
value=diag(value);  %抽取矩阵value对角线元素（抽取出特征向量用于排序），
                    %此时为1维列向量，对一维列向量使用diag则会构成对角矩阵
[value, order] = sort(value,'descend'); %将特征值降序排序
vector = vector(:,order);    %将特征值按照特征向量顺序排序

%% 选取前k个特征值对应的特征向量
CRate = 0.85;   %设置贡献率阈值
index = 0;
while sum(value(1 : index)) / sum(value) < CRate %计算贡献率，贡献率=前n个特征值之和/总特征值之和
    index = index + 1; 
end
value2=value(1:index);   %抽取前index个特征值
value2=diag(value2); %将抽取的特征值重新变回对角矩阵
vector2 = vector(:,1:index);    %抽取前index个特征向量

%% % 故障检测
%% 计算统计量T2和SPE（分别是一个列表）
for i = 1 : x_row
    T(i) = xx1(i,:) * vector2 * inv(value2) * vector2' * xx1(i,:)';   %T2统计量
end

%% 通过核密度估计法计算控制限（从T2列表中选一个数）
[Df, xx] = ksdensity(T,'function','cdf');
for i = 1 : 100   % 99%控制限
    Dfmin = min(abs(Df - 0.99));
    if abs(Df(1, i) - 0.99) == Dfmin    %控制限选择条件
        T2 = xx(1, i); %控制限
        break
    end
end



%% 降维、画图
y= xx1 * vector; %这里还是乘了vector，应为通过贡献率求的话会直接将第二主元去掉，没法画图了
figure(1)%调用一个图像窗口
a = sqrt(T2 * value(1));    %椭圆的长轴
b = sqrt(T2 * value(2));    %椭圆的短轴
t = linspace(0, 2 * pi, 1000);  %0到2*pi之间等距生成1000个点

% subplot(3,1,1); %画原始数据
plot(x(:,1),x(:,2),'k.') 
axis equal;
hold on;
%点斜式求主元方向
u1 = vector(2,1)/vector(1,1) * [max(max(x)) min(min(x))] ; %y=k*x+b,过(0,0)点，则b=0
u2 = vector(2,2)/vector(1,2) * [max(max(x)) min(min(x))];
plot([max(max(x)) min(min(x))],u1,'r')   %画第一主元方向
plot([max(max(x)) min(min(x))],u2,'g')  %画第二主元方向

subplot(3,1,2); %画降维后的数据,椭圆控制限
plot(y(:,1),y(:,2),'k.');  %降维后的数据
hold on;
la = a * cos(t); %椭圆参数方程
lb = b * sin(t);
plot(la , lb );
axis equal; %使横纵坐标间距相同

subplot(3,1,3); %标准化数据，圆形控制限
plot(y(:,1)/a,y(:,2)/b,'k.')
hold on;
la = cos(t);
lb =  sin(t);
plot(la , lb );
axis equal; %使横纵坐标间距相同






