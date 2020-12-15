%%
clear;
close all;
clc;
%%  导入数据
data = importdata('C:\Users\伊海迪\Desktop\2020 APMCM Problems\2020 APMCM Problem A\2010 APMCM Problem A Attachment\Attachment 1\graph1.csv').data;
data2 = load('C:\Users\伊海迪\Desktop\2020 APMCM Problems\2020 APMCM Problem A\2010 APMCM Problem A Attachment\Attachment 2\graph2.mat').graph2;
% %%  画原始数据图
% figure(1);
% plot(data(:,1),data(:,2));
% figure(2);
% plot(data2(:,1),data2(:,2));
%%  画之字形平行图案
% sort_data = sortrows(data, 2, 'descend');   %将所有坐标按y轴降序排列
pgon = polyshape(data2);
tr = triangulation(pgon);
model = createpde;
tnodes = tr.Points';
telements = tr.ConnectivityList';
geometryFromMesh(model,tnodes,telements);
generateMesh(model)
figure
pdemesh(model)
axis equal

%%
polyin = polyshape(data2);
plot(polyin)
polyout1 = polybuffer(polyin,1);
hold on
plot(polyout1)
hold off
