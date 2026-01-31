%% An FLC-Based Closed-loop Fluid Flow Regulation (No Disturbance)

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
    X = rk4('f_FluidFlow_Const_4X_NoLearningNoD',t0,x0,h);
    t = [t;t0+h];
    Q = [Q;X'];
end
%% extract states
x_CNST_FLCND = Q(:,1);
y_CNST_FLCND = Q(:,2);
z_CNST_FLCND = Q(:,3);
xz_CNST_FLCND = Q(:,4);

k1_CNST_FLCND = Q(:,5);

dhx_CNST_FLCND = Q(:,6);
dhy_CNST_FLCND = Q(:,7);
dhz_CNST_FLCND = Q(:,8);
dhxz_CNST_FLCND = Q(:,9);

% Reference trajectory
r1x_CNST_FLCND = 5.*ones(size(t));
r1y_CNST_FLCND = 4.*ones(size(t));
r1z_CNST_FLCND = 10.*ones(size(t));
r1xz_CNST_FLCND = 9.*ones(size(t));



fileID = fopen('exp_const_4XNLND.txt','r');
formatSpec = '%f %f %f %f %f';
sizeA = [5 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
t_c_CNST_FLCND = A(1,:);
u_x_CNST_FLCND = A(2,:);
u_y_CNST_FLCND = A(3,:);
u_z_CNST_FLCND = A(4,:);
u_xz_CNST_FLCND = A(5,:);

% %% Plotting
close all;
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaulttextInterpreter','latex');
green = [0, 150, 0]/255;

figure(1)
subplot(4,1,1); hold on;
plot(t,x_CNST_FLCND,'color',green);% actual trajectory
plot(t,r1x_CNST_FLCND,'--r'); % desired trajectory
legend({'Developed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_1$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,2); hold on;
plot(t,y_CNST_FLCND,'color',green);% actual trajectory
plot(t,r1y_CNST_FLCND,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_2$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure


subplot(4,1,3); hold on;
plot(t,z_CNST_FLCND,'color',green);% actual trajectory
plot(t,r1z_CNST_FLCND,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_3$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,4); hold on;
plot(t,xz_CNST_FLCND,'color',green);% actual trajectory
plot(t,r1xz_CNST_FLCND,'--r'); % desired trajectory
ylabel('$x_4$');
xlabel('Time [s]');
% ylim([-0.05, 11]);
xlim([0, t(end)]);
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure



figure(2) 
subplot(411); hold on;
plot(t_c_CNST_FLCND,u_x_CNST_FLCND,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_1$');
xlim([0, t_c_CNST_FLCND(end)]);

Layout;

subplot(412); hold on;
plot(t_c_CNST_FLCND,u_y_CNST_FLCND,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_2$');
xlim([0, t_c_CNST_FLCND(end)]);

Layout;

subplot(413); hold on;
plot(t_c_CNST_FLCND,u_z_CNST_FLCND,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_3$');
xlim([0, t_c_CNST_FLCND(end)]);

Layout;

subplot(414); hold on;
plot(t_c_CNST_FLCND,u_xz_CNST_FLCND,'m');

%xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_4$');
xlabel('Time [s]');
xlim([0, t_c_CNST_FLCND(end)]);

Layout;



figure(3)
hold on;
plot(t,k1_CNST_FLCND,'c')
ylabel('$k$');
xlabel('Time [s]');
xlim([0, t(end)]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;


figure(4)
subplot(4,1,1); hold on;
plot(t,dhx_CNST_FLCND,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{1}$');
xlim([0, t(end)]);

Layout;

subplot(4,1,2); hold on;
plot(t,dhy_CNST_FLCND,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{2}$');
xlim([0, t(end)]);

Layout;


subplot(4,1,3); hold on;
plot(t,dhz_CNST_FLCND,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{3}$');
xlim([0, t(end)]);

Layout;


subplot(4,1,4); hold on;
plot(t,dhxz_CNST_FLCND,'b');

%xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{4}$');
xlabel('Time [s]');
xlim([0, t(end)]);

Layout;



figure(10)
subplot(2,2,1); hold on;
plot(t,x_CNST_FLCND);% actual trajectory
plot(t,r1x_CNST_FLCND,'--'); % desired trajectory
plot(t,y_CNST_FLCND);% actual trajectory
plot(t,r1y_CNST_FLCND,'--'); % desired trajectory
plot(t,z_CNST_FLCND);% actual trajectory
plot(t,r1z_CNST_FLCND,'--'); % desired trajectory
plot(t,xz_CNST_FLCND);% actual trajectory
plot(t,r1xz_CNST_FLCND,'--'); % desired trajectory
lgd = legend({'FLC ($x_1$)','Desired ($x_1$)','FLC ($x_2$)','Desired ($x_2$)','FLC ($x_3$)','Desired ($x_3$)','FLC ($x_4$)','Desired ($x_4$)'},'Orientation','horizontal');
lgd.NumColumns = 2;
xlim([0, t(end)]);
ylim([-6, 11]);
xlabel('Time [s]');
ylabel('$x_{1,2,3,4}$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(2,2,2); hold on;
plot(t_c_CNST_FLCND,u_x_CNST_FLCND);
plot(t_c_CNST_FLCND,u_y_CNST_FLCND);
plot(t_c_CNST_FLCND,u_z_CNST_FLCND);
plot(t_c_CNST_FLCND,u_xz_CNST_FLCND);
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
plot(t,k1_CNST_FLCND,'c')
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
plot(t,dhx_CNST_FLCND);
plot(t,dhy_CNST_FLCND);
plot(t,dhz_CNST_FLCND);
plot(t,dhxz_CNST_FLCND);
lgd = legend({'$\hat{d}_{1}$','$\hat{d}_{2}$','$\hat{d}_{3}$','$\hat{d}_{4}$'},'Orientation','horizontal');
lgd.NumColumns = 4;
xlim([0, t(end)]);
% ylim([3.5, 11]);
xlabel('Time [s]');
ylabel('$\hat{d}_{1,2,3,4}$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;