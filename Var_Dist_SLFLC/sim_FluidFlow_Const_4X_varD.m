%% A Learning-Based Closed-loop Fluid Flow Regulation

clc
clear variables
close all

%% Initial conditions

x10 = 10; %2;
x20 = 9; %3;
x30 = 6;
x40 = 5; %2;

k0 = 1;

dhx10 = 0;
dhx20 = 0;
dhx30 = 0;
dhx40 = 0;
z0 = [x10 x20 x30 x40 k0 dhx10 dhx20 dhx30 dhx40];

%% solve ODE using RK4

h = 0.001;
t0 = 0;
t = [t0];

Q = z0;

sim_t = 10;

while t(end) < sim_t
    t0 = t(end);
    x0 = (Q(end,:))';
    X = rk4('f_FluidFlow_Const_4X_VarD',t0,x0,h);
    t = [t;t0+h];
    Q = [Q;X'];
end
%% extract states
x_varD = Q(:,1);
y_varD = Q(:,2);
z_varD = Q(:,3);
xz_varD = Q(:,4);

k1_varD = Q(:,5);

dhx_varD = Q(:,6);
dhy_varD = Q(:,7);
dhz_varD = Q(:,8);
dhxz_varD = Q(:,9);

% Reference trajectory
r1x_varD = 5.*ones(size(t));
r1y_varD = 4.*ones(size(t));
r1z_varD = 10.*ones(size(t));
r1xz_varD = 9.*ones(size(t));



fileID = fopen('exp_const_4XUnVard.txt','r');
formatSpec = '%f %f %f %f %f';
sizeA = [5 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
t_c_varD = A(1,:);
u_x_varD = A(2,:);
u_y_varD = A(3,:);
u_z_varD = A(4,:);
u_xz_varD = A(5,:);

% %% Plotting
close all;
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaulttextInterpreter','latex');
green = [0, 150, 0]/255;

figure(1)
subplot(4,1,1); hold on;
plot(t,x_varD,'color',green);% actual trajectory
plot(t,r1x_varD,'--r'); % desired trajectory
legend({'Developed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
ylim([-0.05, 11]);
ylabel('$x_1$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,2); hold on;
plot(t,y_varD,'color',green);% actual trajectory
plot(t,r1y_varD,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
ylim([-0.05, 11]);
ylabel('$x_2$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure


subplot(4,1,3); hold on;
plot(t,z_varD,'color',green);% actual trajectory
plot(t,r1z_varD,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
ylim([-0.05, 11]);
ylabel('$x_3$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,4); hold on;
plot(t,xz_varD,'color',green);% actual trajectory
plot(t,r1xz_varD,'--r'); % desired trajectory
ylabel('$x_4$');
xlabel('Time [s]');
ylim([-0.05, 11]);
xlim([0, t(end)]);
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure



figure(2) 
subplot(411); hold on;
plot(t_c_varD,u_x_varD,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_1$');
xlim([0, t_c_varD(end)]);

Layout;

subplot(412); hold on;
plot(t_c_varD,u_y_varD,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_2$');
xlim([0, t_c_varD(end)]);

Layout;

subplot(413); hold on;
plot(t_c_varD,u_z_varD,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_3$');
xlim([0, t_c_varD(end)]);

Layout;

subplot(414); hold on;
plot(t_c_varD,u_xz_varD,'m');

%xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_4$');
xlabel('Time [s]');
xlim([0, t_c_varD(end)]);

Layout;



figure(3)
hold on;
plot(t,k1_varD,'c')
ylabel('$k$');
xlabel('Time [s]');
xlim([0, t(end)]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;


figure(4)
subplot(4,1,1); hold on;
plot(t,dhx_varD,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{1}$');
xlim([0, t(end)]);

Layout;

subplot(4,1,2); hold on;
plot(t,dhy_varD,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{2}$');
xlim([0, t(end)]);

Layout;


subplot(4,1,3); hold on;
plot(t,dhz_varD,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{3}$');
xlim([0, t(end)]);

Layout;


subplot(4,1,4); hold on;
plot(t,dhxz_varD,'b');

%xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{4}$');
xlabel('Time [s]');
xlim([0, t(end)]);

Layout;





figure(10)
subplot(2,2,1); hold on;
plot(t,x_varD);% actual trajectory
plot(t,r1x_varD,'--'); % desired trajectory
plot(t,y_varD);% actual trajectory
plot(t,r1y_varD,'--'); % desired trajectory
plot(t,z_varD);% actual trajectory
plot(t,r1z_varD,'--'); % desired trajectory
plot(t,xz_varD);% actual trajectory
plot(t,r1xz_varD,'--'); % desired trajectory
lgd = legend({'Developed ($x_1$)','Desired ($x_1$)','Developed ($x_2$)','Desired ($x_2$)','Developed ($x_3$)','Desired ($x_3$)','Developed ($x_4$)','Desired ($x_4$)'},'Orientation','horizontal');
lgd.NumColumns = 2;
xlim([0, t(end)]);
ylim([3.5, 11]);
xlabel('Time [s]');
ylabel('$x_{1,2,3,4}$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(2,2,2); hold on;
plot(t_c_varD,u_x_varD);
plot(t_c_varD,u_y_varD);
plot(t_c_varD,u_z_varD);
plot(t_c_varD,u_xz_varD);
lgd = legend({'$u_{1}$','$u_{2}$','$u_{3}$','$u_{4}$'},'Orientation','horizontal');
lgd.NumColumns = 4;
xlim([0, t(end)]);
% ylim([3.5, 11]);
xlabel('Time [s]');
ylabel('$u_{1,2,3,4}$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;
subplot(2,2,3); hold on;
plot(t,k1_varD,'c')
lgd = legend({'k'},'Orientation','horizontal');
lgd.NumColumns = 1;
xlim([0, t(end)]);
% ylim([3.5, 11]);
xlabel('Time [s]');
ylabel('$k$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;
subplot(2,2,4); hold on;
plot(t,dhx_varD);
plot(t,dhy_varD);
plot(t,dhz_varD);
plot(t,dhxz_varD);
lgd = legend({'$\hat{d}_{1}$','$\hat{d}_{2}$','$\hat{d}_{3}$','$\hat{d}_{4}$'},'Orientation','horizontal');
lgd.NumColumns = 4;
xlim([0, t(end)]);
% ylim([3.5, 11]);
xlabel('Time [s]');
ylabel('$\hat{d}_{1,2,3,4}$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;
