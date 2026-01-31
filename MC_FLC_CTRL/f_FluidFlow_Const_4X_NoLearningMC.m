function dx = f_FluidFlow_Const_4X_NoLearningMC(t,s,i)
%% Reference trajectory
r = [5 4 10 9]';
rd = [0 0 0 0]';
UNN = [0.03,0.06,0.09,0.12,0.15,0.18];
%% disturbance
d_1 = 5;    % actual disturbance
d_2 = 5;    % actual disturbance
d_3 = 5;    % actual disturbance
d_4 = 5;    % actual disturbance
d1 = 1.*[d_1 d_2 d_3 d_4]';

%% params
L1 = 557.7;
L2 = 1016.9;
L3 = 41.0;
L4 = -628.9;

M11 = -86.1;
M22 = -392.4;
M23 = 263.9;
M32 = -218.3;
M33 = -7.6;
M41 = 43.4;
M44 = -113.5;

N111 = 1.8;
N121 = -2.2;
N131 = -2.3;
N141 = -6.8;
N212 = 75.0;
N313 = 5.0;
N314 = 3.9;
N414 = 2.9;
N424 = -9.8;
N434 = 6.3;
N444 = -7.3;

O2222 = -2.5;
O2233 = -2.5;
O3223 = -0.2;
O3333 = -0.2;

%% States assignment
x1 = s(1);
x2 = s(2);
x3 = s(3);
x4 = s(4);

k = s(5);

dhx1 = s(6);
dhx2 = s(7);
dhx3 = s(8);
dhx4 = s(9);

X = [x1 x2 x3 x4]';

dh = [dhx1 dhx2 dhx3 dhx4]';

%% control gains and learning rate of gradient descent
alpha = 0*1.50; %50;
alphadh = 0*1.10; %10;

kd = 1*1.20; %2;


%% Definition of Fluid Flow parameters

dx1 = L1 + M11*x1 + N111*x1^2 + N121*x1*x2 + N131*x1*x3 + N141*x1*x4;
dx2 = L2 + M22*x2 + M23*x3 + N212*x1*x2 + O2222*x2^3 + O2233*x2*x3^2;
dx3 = L3 + M32*x2 + M33*x3 + N313*x1*x3 + N314*x1*x4 + O3223*x3*x2^2 + O3333*x3^3;
dx4 = L4 + M41*x1 + M44*x4 + N414*x1*x4 + N424*x2*x4 + N434*x3*x4 + N444*x4^2;


F = [dx1;dx2;dx3;dx4];
d2 = UNN(i).*[dx1;dx2;dx3;dx4];
d = d1 + d2;
B = eye(4);

%% cost definitions
e = X - r;
ed = -k*eye(4)*e + d - dh;

c = ed + kd*eye(4)*e;

%% First order ODEs
dk = alpha*c'*e;
ddh = alphadh*c;

u = inv(B)*(-F - k*eye(4)*e + rd -dh);

filename = sprintf('exp_const_4XNLUn_%d.txt', i);
% Open the dynamically named file in append mode
fileID = fopen(filename, 'a');
fprintf(fileID,'%f %f %f\n',[t;u(1);u(2);u(3);u(4)]);
fclose(fileID);
dx = [F+B*u+d;dk;ddh];

end
