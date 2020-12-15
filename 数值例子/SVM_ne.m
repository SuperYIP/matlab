%% 多模态，冬妮
n = 100;
t = randn(n,2);
e = 0.1* randn(n,2);
I = ones(n,1);
A = I * [-15,5] + t + e;
B = I * [25,-10] + 8*t + e;
%% 赵丽颖数值例子
clc,clear all,close all;
t1 = normrnd(0,1,100,1);

t2 = normrnd(0,1,100,1);
x1 = 5 + normrnd(0,1,100,1);
y1 = 2*normrnd(0,1,100,1);
x2 = -5 + 0.2*normrnd(0,1,100,1);
y2 = 0.1*normrnd(0,1,100,1);
x3 = -2 + 0.5*normrnd(0,1,100,1);
y3 = -4 + 0.5*normrnd(0,1,100,1);
x = [x1;x2;x3];
y = [y1;y2;y3];
plot(x, y, 'b.');
%% 自己整的
n = 100; %数据点个数
x1 = 4 + 3*sqrt(rand(1,n)).*cos(2*pi*rand(1,n)); %
y1 = 6+ 3*sqrt(rand(1,n)).*sin(2*pi*rand(1,n));
x2 = 16 + 5*sqrt(rand(1,n)).*cos(2*pi*rand(1,n)); %
y2 = 18+ 5*sqrt(rand(1,n)).*sin(2*pi*rand(1,n));
data = [x1',y1'; x2', y2'];