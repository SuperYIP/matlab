%% kpca实现步骤
%% 生成随机数据（椭圆形状）
ecc = axes2ecc(10,5);  % 根据长半轴和短半轴计算椭圆偏心率
[elat,elon] = ellipse1(1,2,[10 ecc],45);
x = [elat,elon];
plot(x(:,1),x(:,2),'k.');
%% 数据标准化
[x_row, x_col] = size(x);  %获得矩阵x的维度，将行列维度分别赋值给x_row，
meanx = mean(x); %求矩阵均值
xx = x - meanx;  %中心化(自己生成的数据处理到这里就可以，因为数据不会像工业数据一样出现巨大波动)
% stdx = std(x);   %计算标准差
% xx = xx ./ std(x);   %标准化:点除。

% %% PCA计算特征值和特征向量矩阵
% c = cov(xx); %求协方差矩阵
% [vector,  value] = eig(c); % vector:特征向量，value:特征值（对角矩阵）
% value=diag(value);  %抽取矩阵value对角线元素（抽取出特征向量用于排序），此时为1维列向量
% [value, order] = sort(value,'descend'); %将特征值降序排序
% vector = vector(:,order);    %将特征值按照特征向量顺序排序
% %% PCA数据降维
% y = xx * vector;
% figure(10);
% plot(x(:,1),x(:,2),'*');
% axis equal; 
% hold on;
% u1 = vector(2,1)/vector(1,1) * [max(max(x)) min(min(x))]  %y=k*x+b,过(0,0)点，则b=0
% u2 = vector(2,2)/vector(1,2) * [max(max(x)) min(min(x))]
% plot([max(max(x)) min(min(x))],u1,'r')   %画第一主元方向
% plot([max(max(x)) min(min(x))],u2,'g')  %画第二主元方向

%% 求核矩阵
c = 15; %核矩阵参数
for i = 1: x_row
    for j = 1: x_row
        K(i,j) = exp(-(norm(xx(i,:) - xx(j,:)))^2/c);   %核矩阵
    end
end
%% 中心化矩阵
unit = (1/x_row) * ones(x_row,x_row);    %ones生成全部为1的数组
Kp = K - unit*K - K*unit + unit*K*unit; % 中心化矩阵

%% 计算特征值和特征向量
[vector,  value] = eig(Kp); % vector:特征向量，value:特征值（对角矩阵）
value = value - mean(value);    %标准化特征值、特征向量
vector = vector - mean(vector);
value=diag(value);  %抽取矩阵value对角线元素（抽取出特征向量用于排序），此时为1维列向量
[value, order] = sort(value,'descend'); %将特征值降序排序
vector = vector(:,order);    %将特征值按照特征向量顺序排序

%% 抽取前k个特征值
CRate = 0.85;   %设置贡献率阈值
index = 0;
while sum(value(1 : index)) / sum(value) < CRate %计算贡献率，贡献率=前n个特征值之和/总特征值之和
    index = index + 1; 
end
value2=value(1:index,:);   %抽取前index个特征值
value2=diag(value2); %将抽取的特征值重新变回对角矩阵,为了后面计算T2统计量
vector2 = vector(:,1:index);    %抽取前index个特征向量
%% 投影
y = Kp * vector2;
figure(11);
subplot(2,1,1);
plot(x(:,1),x(:,2),'*');
axis equal; 
subplot(2,1,2);
plot(y(:,1),y(:,2),'*'); %绘制特征向量散点图
axis equal; 