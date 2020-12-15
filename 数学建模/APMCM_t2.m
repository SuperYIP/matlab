%% 读取数据
clear,clc,close all;
[num, txt, raw] = xlsread('C:\Users\伊海迪\Desktop\数学建模\数据部分\进出口总额_美国_当月值1960-2020.xlsx'); %进出口总额表的所有数据
i_e_month = num(9:end-1, 3); %2006-01 ~2019-12的数据，每月一个数据
[num, txt, raw] = xlsread('C:\Users\伊海迪\Desktop\数学建模\数据部分\美国_GDP（季度数据）1929-2020.xlsx'); %进出口总额表的所有数据
GDP_quarter = num(4:59, 4);  %2006-01 ~2019-12的数据，每季度一个数据
GDP_quarter_time = raw(5:60, 2);    %抽出时间
%%  处理数据，使两个数据具有相同格式
i_e_quarter = [];   %2006-01 ~2019-12的数据，每季度一个数据
temp = 0;   %临时保存每季度数据
for i=1:size(i_e_month,1)
    if mod(i,3) ~= 0
       temp = temp + i_e_month(i); 
    else
       i_e_quarter = [i_e_quarter;temp];
       temp = 0;
    end
end

%%  求两向量相关系数
r1=corr(i_e_quarter, GDP_quarter, 'type', 'pearson')

%% 画图
plot(zscore(GDP_quarter), '-*b')
hold on;
plot(zscore(i_e_quarter), '-or');
% set(gca,'YLim',[0 1.3] * 100000);%X轴的数据显示范围为0-2.5
% set(gca,'xtick',1:56)
set(gca, 'xticklabel', GDP_quarter_time(1:8:end,:));
legend('GDP', 'Import and export volume');
xlabel('time');
ylabel('Economic volume (after standardization)');
% plot(GDP_quarter_time, '-*b');
%%
