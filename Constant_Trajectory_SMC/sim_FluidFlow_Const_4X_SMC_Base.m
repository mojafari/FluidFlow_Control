%% An SMC-Based Closed-loop Fluid Flow Regulation (With Disturbance)

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
    X = rk4('f_FluidFlow_SMC_Base',t0,x0,h);
    t = [t;t0+h];
    Q = [Q;X'];
end
%% extract states
x_SMC = Q(:,1);
y_SMC = Q(:,2);
z_SMC = Q(:,3);
xz_SMC = Q(:,4);

% Reference trajectory
r1x_SMC = 5.*ones(size(t));
r1y_SMC = 4.*ones(size(t));
r1z_SMC = 10.*ones(size(t));
r1xz_SMC = 9.*ones(size(t));



fileID = fopen('exp_const_4X_SMC_Base.txt','r');
formatSpec = '%f %f %f %f %f';
sizeA = [5 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
t_c_SMC = A(1,:);
u_x_SMC = A(2,:);
u_y_SMC = A(3,:);
u_z_SMC = A(4,:);
u_xz_SMC = A(5,:);

% %% Plotting
close all;
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaulttextInterpreter','latex');
green = [0, 150, 0]/255;

figure(1)
subplot(4,1,1); hold on;
plot(t,x_SMC,'color',green);% actual trajectory
plot(t,r1x_SMC,'--r'); % desired trajectory
legend({'SMC','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_1$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,2); hold on;
plot(t,y_SMC,'color',green);% actual trajectory
plot(t,r1y_SMC,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_2$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure


subplot(4,1,3); hold on;
plot(t,z_SMC,'color',green);% actual trajectory
plot(t,r1z_SMC,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_3$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,4); hold on;
plot(t,xz_SMC,'color',green);% actual trajectory
plot(t,r1xz_SMC,'--r'); % desired trajectory
ylabel('$x_4$');
xlabel('Time [s]');
% ylim([-0.05, 11]);
xlim([0, t(end)]);
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure



figure(2) 
subplot(411); hold on;
plot(t_c_SMC,u_x_SMC,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_1$');
xlim([0, t_c_SMC(end)]);

Layout;

subplot(412); hold on;
plot(t_c_SMC,u_y_SMC,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_2$');
xlim([0, t_c_SMC(end)]);

Layout;

subplot(413); hold on;
plot(t_c_SMC,u_z_SMC,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_3$');
xlim([0, t_c_SMC(end)]);

Layout;

subplot(414); hold on;
plot(t_c_SMC,u_xz_SMC,'m');

%xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_4$');
xlabel('Time [s]');
xlim([0, t_c_SMC(end)]);

Layout;



k1_SMC = ones(size(t));
dhx_SMC = zeros(size(t));
dhy_SMC = zeros(size(t));
dhz_SMC = zeros(size(t));
dhxz_SMC = zeros(size(t));

figure(10)
subplot(2,2,1); hold on;
plot(t,x_SMC);% actual trajectory
plot(t,r1x_SMC,'--'); % desired trajectory
plot(t,y_SMC);% actual trajectory
plot(t,r1y_SMC,'--'); % desired trajectory
plot(t,z_SMC);% actual trajectory
plot(t,r1z_SMC,'--'); % desired trajectory
plot(t,xz_SMC);% actual trajectory
plot(t,r1xz_SMC,'--'); % desired trajectory
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
plot(t_c_SMC,u_x_SMC);
plot(t_c_SMC,u_y_SMC);
plot(t_c_SMC,u_z_SMC);
plot(t_c_SMC,u_xz_SMC);
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
plot(t,k1_SMC,'c')
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
plot(t,dhx_SMC);
plot(t,dhy_SMC);
plot(t,dhz_SMC);
plot(t,dhxz_SMC);
lgd = legend({'$\hat{d}_{1}$','$\hat{d}_{2}$','$\hat{d}_{3}$','$\hat{d}_{4}$'},'Orientation','horizontal');
lgd.NumColumns = 4;
xlim([0, t(end)]);
% ylim([3.5, 11]);
xlabel('Time [s]');
ylabel('$\hat{d}_{1,2,3,4}$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;