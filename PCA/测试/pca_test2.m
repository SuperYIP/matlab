
% % PCA实现步骤
%% 数据生成
ecc = axes2ecc(10,5);  % 根据长半轴和短半轴计算椭圆偏心率
[elat,elon] = ellipse1(1,2,[10 ecc],45);
x = [elat,elon];


%% 数据标准化
[x_row, x_col] = size(x);  %获得矩阵x的维度，将行列维度分别赋值给x_row，x_col
meanx = mean(x); %求矩阵均值
x = x - meanx;  %中心化(自己生成的数据处理到这里就可以，因为数据不会像工业数据一样出现巨大波动)
stdx = std(x);   %计算标准差
x = x ./ stdx;  %标准化数据

%% 计算特征值和特征向量矩阵
cov_x = cov(x); %求协方差矩阵
[vector,  value] = eig(cov_x); % vector:特征向量，value:特征值（对角矩阵）
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
value2=diag(value2); %将抽取的特征值重新变回对角矩阵,为了后面计算T2统计量
vector2 = vector(:,1:index);    %抽取前index个特征向量

%% 数据降维
y = x * vector2;
figure(4)
subplot(2,1,1);
scatter(x(:,1),x(:,2));
axis equal;
hold on;
plot([0,vector2(1,1)],[0,vector2(2,1)],'r');
hold on;
plot([0,vector2(1,2)],[0,vector2(2,2)],'g');

subplot(2,1,2);
plot(y(:,1),y(:,2),'k.')
axis equal;
