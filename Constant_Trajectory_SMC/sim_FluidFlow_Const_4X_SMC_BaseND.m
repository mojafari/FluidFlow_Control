%% An SMC-Based Closed-loop Fluid Flow Regulation (No Disturbance)

clc
clear variables
close all

%% Initial conditions
x0  = [10;9;6;5];

z0 = x0;

%% solve ODE using RK4

h = 0.001;% maybe 0.001
t0 = 0;
t = [t0];

Q = z0';

sim_t = 10;

while t(end) < sim_t
    t0 = t(end);
    x0 = (Q(end,:))';
    X = rk4('f_FluidFlow_SMC_BaseND',t0,x0,h);
    t = [t;t0+h];
    Q = [Q;X'];
end
%% extract states
x_SMCND = Q(:,1);
y_SMCND = Q(:,2);
z_SMCND = Q(:,3);
xz_SMCND = Q(:,4);

% Reference trajectory
r1x_SMCND = 5.*ones(size(t));
r1y_SMCND = 4.*ones(size(t));
r1z_SMCND = 10.*ones(size(t));
r1xz_SMCND = 9.*ones(size(t));



fileID = fopen('exp_const_4X_SMC_BaseND.txt','r');
formatSpec = '%f %f %f %f %f';
sizeA = [5 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
t_c_SMCND = A(1,:);
u_x_SMCND = A(2,:);
u_y_SMCND = A(3,:);
u_z_SMCND = A(4,:);
u_xz_SMCND = A(5,:);

% %% Plotting
close all;
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaulttextInterpreter','latex');
green = [0, 150, 0]/255;

figure(1)
subplot(4,1,1); hold on;
plot(t,x_SMCND,'color',green);% actual trajectory
plot(t,r1x_SMCND,'--r'); % desired trajectory
legend({'SMC','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_1$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,2); hold on;
plot(t,y_SMCND,'color',green);% actual trajectory
plot(t,r1y_SMCND,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_2$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure


subplot(4,1,3); hold on;
plot(t,z_SMCND,'color',green);% actual trajectory
plot(t,r1z_SMCND,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_3$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,4); hold on;
plot(t,xz_SMCND,'color',green);% actual trajectory
plot(t,r1xz_SMCND,'--r'); % desired trajectory
ylabel('$x_4$');
xlabel('Time [s]');
% ylim([-0.05, 11]);
xlim([0, t(end)]);
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure



figure(2) 
subplot(411); hold on;
plot(t_c_SMCND,u_x_SMCND,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_1$');
xlim([0, t_c_SMCND(end)]);

Layout;

subplot(412); hold on;
plot(t_c_SMCND,u_y_SMCND,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_2$');
xlim([0, t_c_SMCND(end)]);

Layout;

subplot(413); hold on;
plot(t_c_SMCND,u_z_SMCND,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_3$');
xlim([0, t_c_SMCND(end)]);

Layout;

subplot(414); hold on;
plot(t_c_SMCND,u_xz_SMCND,'m');

%xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_4$');
xlabel('Time [s]');
xlim([0, t_c_SMCND(end)]);

Layout;


k1_SMCND = ones(size(t));
dhx_SMCND = zeros(size(t));
dhy_SMCND = zeros(size(t));
dhz_SMCND = zeros(size(t));
dhxz_SMCND = zeros(size(t));

figure(10)
subplot(2,2,1); hold on;
plot(t,x_SMCND);% actual trajectory
plot(t,r1x_SMCND,'--'); % desired trajectory
plot(t,y_SMCND);% actual trajectory
plot(t,r1y_SMCND,'--'); % desired trajectory
plot(t,z_SMCND);% actual trajectory
plot(t,r1z_SMCND,'--'); % desired trajectory
plot(t,xz_SMCND);% actual trajectory
plot(t,r1xz_SMCND,'--'); % desired trajectory
lgd = legend({'SMC ($x_1$)','Desired ($x_1$)','SMC ($x_2$)','Desired ($x_2$)','SMC ($x_3$)','Desired ($x_3$)','SMC ($x_4$)','Desired ($x_4$)'},'Orientation','horizontal');
lgd.NumColumns = 2;
xlim([0, t(end)]);
ylim([-6, 11]);
xlabel('Time [s]');
ylabel('$x_{1,2,3,4}$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(2,2,2); hold on;
plot(t_c_SMCND,u_x_SMCND);
plot(t_c_SMCND,u_y_SMCND);
plot(t_c_SMCND,u_z_SMCND);
plot(t_c_SMCND,u_xz_SMCND);
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
plot(t,k1_SMCND,'c')
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
plot(t,dhx_SMCND);
plot(t,dhy_SMCND);
plot(t,dhz_SMCND);
plot(t,dhxz_SMCND);
lgd = legend({'$\hat{d}_{1}$','$\hat{d}_{2}$','$\hat{d}_{3}$','$\hat{d}_{4}$'},'Orientation','horizontal');
lgd.NumColumns = 4;
xlim([0, t(end)]);
% ylim([3.5, 11]);
xlabel('Time [s]');
ylabel('$\hat{d}_{1,2,3,4}$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;