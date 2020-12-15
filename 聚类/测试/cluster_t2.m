%%
n = 100;
t = randn(n,2);
e = 0.1* randn(n,2);
I = ones(n,1);
A = I * [-15,5] + t + e;
B = I * [25,-10] + 8*t + e;
data = [A; B];
%%
K=2;
[idx,cen]=kmeans(data,K,'Distance','sqeuclidean','Replicates',5,'Display','Final'); %idx是与data中的观测值对应的预测簇索引的向量。cen是包含最终质心位置的 3×2 矩阵。
%%
figure;
gscatter(data(:,1),data(:,2),idx,['r','g'])
hold on
scatter(cen(:,1),cen(:,2),300,'m*')
hold off
xlabel('花瓣长度')
ylabel('花瓣宽度')
title('kmeans分类')
set(gca,'FontSize',12)
set(gca,'FontWeight','bold')