
%% % PCA
%%% 此程序所学知识：randn、normrnd、diag、subplot
%% 数据生成(生成3维数据，其中第三维方差较小，降维后应去掉此维度，降到二维应为原三维从上俯视)
clear,clc,close all;
x_temp = randn(100, 2);   %生成2维数据，100行，2列；randn生成的是均值为0，方差为1的一组数
x_temp2 = normrnd(0, 0.1, [100,1]); %生成均值为0，方差为0.1的100行1列的一组数，normrnd可以指定生成数的均值和方差
x = [x_temp x_temp2];

%% 数据标准化
[x_row, x_col] = size(x);  %获得矩阵x的维度，将行列维度分别赋值给x_row，x_col
meanx = mean(x); %求矩阵x均值
xx = x - meanx;  %中心化(自己生成的数据处理到这里就可以，因为数据不会像工业数据一样出现巨大波动)
% stdx = std(x);   %计算x标准差
% xx = xx / std(x);   %标准化

%% 计算特征值和特征向量矩阵
c = cov(xx); %求xx协方差矩阵
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
value2=value(1:index,:);   %抽取前index个特征值
value2=diag(value2); %将抽取的特征值重新变回对角矩阵
vector2 = vector(:,1:index);    %抽取前index个特征向量

%% % 数据降维
y = xx * vector2;   %降维后的数据：中心化后数据乘选取的前k个特征向量
% cc = cov(y) %降维后的协方差矩阵，除对角线外值应该为0，程序里跑出来是近似于0的极小的数
var(y(:,1)) %计算方差：应等于最大特征值

%% % 故障检测
%% 计算统计量T2和SPE（分别是一个列表）
for i=1:x_row
    T(i) = xx(i,:) * vector2 * inv(value2) * vector2' * xx(i,:)';   %T2统计量
    Q(i) = (xx(i,:) - xx(i,:) * vector2 * vector2') * (xx(i,:) - xx(i,:) * vector2 * vector2')';    %SPE统计量
end

%% 通过核密度估计法计算控制限（从T2列表中选一个数）
[Df, xxx] = ksdensity(T,'function','cdf');
for i = 1 : 100   % 99%控制限
    Dfmin = min(abs(Df - 0.99));
    if abs(Df(1, i) - 0.99) == Dfmin    %控制限选择条件
        T2 = xxx(1, i); %控制限
        break
    end
end
[Df, xxx] = ksdensity(Q,'function','cdf');
for i = 1 : 100   % 99%控制限
    Dfmin = min(abs(Df - 0.99));
    if abs(Df(1, i) - 0.99) == Dfmin    %控制限选择条件
        SPE = xxx(1, i); %控制限
        break
    end
end

%% 新样本
f = [randn(100, 2) normrnd(0, 0.1, [100,1])];   %新样本与原样本相同，测试控制限是否正确
% 对新样本执行同样的数据处理操作
[f_row, f_col] = size(f);
f = f - meanx;     %使用训练样本均值进行标准化
for i=1:f_row
    f_T(i) = f(i,:) * vector2 * inv(value2) * vector2' * f(i,:)';
    f_Q(i) = (f(i,:) - f(i,:) * vector2 * vector2') * (f(i,:) - f(i,:) * vector2 * vector2')';
end

%% 画图
figure(1)   %画降维前后的图像
subplot(2,1,1); %将多个图画在一个figure上;;subplot(m,n,p) 将当前图窗划分为 m×n 网格，并在 p 指定的位置创建坐标区
plot3(x(:,1), x(:,2), x(:,3), 'k.')  %原始数据
subplot(2,1,2);
plot(y(:,1),y(:,2),'k.')
figure(2)   %画故障检测图像
subplot(2,1,1);
semilogy(f_T,'k')
line([0,100], [T2,T2],'LineStyle','--','Color','b');    %画线，横坐标从0~100，纵坐标T2~T2即一条直线.
xlabel('sample');
ylabel('T^2');
subplot(2,1,2);
semilogy(f_Q,'k')
line([0,100], [SPE,SPE],'LineStyle','--','Color','b');    %画线，横坐标从0~100，纵坐标SPE~SPE即一条直线.
xlabel('sample');
ylabel('SPE');
