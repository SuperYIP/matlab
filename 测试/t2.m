%% 
angle = -30; % 角度
angle = angle/180*pi;
r = 0:0.01:2*pi; % 转一圈
p = [(8*cos(r))' (3*sin(r))']; % 未旋转
alpha = [cos(angle) -sin(angle)
       sin(angle) cos(angle)];
p1 = p*alpha; % 转后
ell = patch(p1(:,1),p1(:,2),[255 225 225]/255,'EdgeColor',[1 0 0]);

%%
ecc = axes2ecc(10,5);  % 根据长半轴和短半轴计算椭圆偏心率
[elat,elon] = ellipse1(1,2,[10 ecc],45);
scatter(elat,elon);
%%
%% 生成随机数据（椭圆形状）
rot_deg = rand(200,1)*2*pi;  %生成随机的角度
radius = 5*rand(200,1); %生成随机的半径
x = [radius.*sin(rot_deg),radius.*cos(rot_deg)];  %原始样本数据
scatter(x(:,1),x(:,2),'k');
%%
x = linspace(0,200);
y = cos(x)
plot(x,y)

%%
v = [1,2,3];
v= zscore(v)
v