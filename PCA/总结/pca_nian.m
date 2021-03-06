%% 年哥写的！！
%%%PCA入门级简单编程及心得
clc %清除命令行窗口
clear %清除工作区，有时候工作区不及时清除会导致数据覆盖，从而照成实验结果偏差
close all %关闭现有图像窗口，原理同上

%%  数据生成  在数据生成是应在心里有一个大概预计数据究竟是什么样的分布
x1=randn(100,1); %生成100行1列的高斯随机数
x2=x1;
x=[x1 x2]; %将x1和X2放到一个矩阵中
figure(1)%调用一个图像窗口
plot(x(:,1),x(:,2),'k.') %画图
%%生成这个数据之后，如果对PCA理解基本透彻，在心里应该有一个预估，这个数据所求得的特征向量即投影方向应该是什么
%%最后通过PCA验证这个结果是否一致，看究竟是编程错误，还是算法理解错误，以便及时纠正
%%这里的特征向量若预计为（1,1），则对PCA有初步的理解，若为（二分之根号二，二分之根号二）则对PCA有进阶的掌握，且考虑问题更加全面
%% 数据预处理是数据分析的潜在步骤
[mm,nn]=size(x);%计算矩阵x的维度
meanx=mean(x);% 求x的均值
xx=x-meanx;  %这个语句其实是存在错误的 但是在新版的matlab中是可以直接运行的，可以思考一下为什么是错了，应该怎么改才合理
%% 还有如果将来涉及故障检测阶段，这一阶段是重中之重，基本所有的二年级和三年级的同学都在这出现过问题，切记慎重
%%  这里若对PCA进行过独立的推导，则看上去会更加的直观，更加容易理解
c=cov(xx);% 计算x的协方差矩阵的命令
c1=1/(mm-1)*(xx'*xx);%为什么要先转置，要考虑什么是协方差矩阵  这里使用的是协方差矩阵的定义，可以对比c和c1已确定步骤无误
[eigvector,eigvalue]=eig(c); %对矩阵c进行特征分解
%% 
eigvalue=diag(eigvalue);  %矩阵对角化
[eigenvalue,index]=sort(eigvalue,'descend'); %按顺序排列
eigenvalue=diag(eigenvalue); %矩阵对角化
eigervector=eigvector(:,index); %将特征向量按特征值的顺序排列；和自己预期的特征向量是否相同？若不是，究竟哪里出现了问题
%%数据降维，这里其实没有进行降维，只是进行了坐标轴的变换，有兴趣的同学可以自己编写一个三维数值例子进行验证
y=xx*eigervector;
figure(2)
plot(y(:,1),y(:,2),'k.')
var(y(:,1))% 考虑一下这个命令的含义和这个数值有什么特殊含义，和已学的PCA之中的哪一点知识是相关的
%%最后希望所有学弟学妹尽快进入学习状态，学业有成！



