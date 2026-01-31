%% A Learning-Based Closed-loop Fluid Flow Regulation

clc
clear variables
close all



for ii = 1:6
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
    X = rk4MC('f_FluidFlow_Const_4X_NoLearningMC',t0,x0,ii,h);
    t = [t;t0+h];
    Q = [Q;X'];
end

QQ_base{ii} = Q;


end

for ii = 1:6

Q_base = QQ_base{ii};
%% extract states
x_base(:,ii) = Q_base(:,1);
y_base(:,ii) = Q_base(:,2);
z_base(:,ii) = Q_base(:,3);
xz_base(:,ii) = Q_base(:,4);

k1_base(:,ii) = Q_base(:,5);

dhx_base(:,ii) = Q_base(:,6);
dhy_base(:,ii) = Q_base(:,7);
dhz_base(:,ii) = Q_base(:,8);
dhxz_base(:,ii) = Q_base(:,9);

% Reference trajectory
r1x_base(:,ii) = 5.*ones(size(t));
r1y_base(:,ii) = 4.*ones(size(t));
r1z_base(:,ii) = 10.*ones(size(t));
r1xz_base(:,ii) = 9.*ones(size(t));

filename = sprintf('exp_const_4XNLUn_%d.txt', ii);
% Open the dynamically named file in append mode
fileID = fopen(filename, 'r');
formatSpec = '%f %f %f %f %f';
sizeA = [5 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
t_c_base(ii,:) = A(1,:);
u_x_base(ii,:) = A(2,:);
u_y_base(ii,:) = A(3,:);
u_z_base(ii,:) = A(4,:);
u_xz_base(ii,:) = A(5,:);
end

% %% Plotting
close all;
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaulttextInterpreter','latex');
green = [0, 150, 0]/255;

figure(1)
subplot(4,1,1); hold on;
plot(t,x_base,'color',green);% actual trajectory
plot(t,r1x_base,'--r'); % desired trajectory
legend({'Developed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_1$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,2); hold on;
plot(t,y_base,'color',green);% actual trajectory
plot(t,r1y_base,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_2$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure


subplot(4,1,3); hold on;
plot(t,z_base,'color',green);% actual trajectory
plot(t,r1z_base,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_3$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,4); hold on;
plot(t,xz_base,'color',green);% actual trajectory
plot(t,r1xz_base,'--r'); % desired trajectory
ylabel('$x_4$');
xlabel('Time [s]');
% ylim([-0.05, 11]);
xlim([0, t(end)]);
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure



figure(2) 
subplot(411); hold on;
plot(t_c_base,u_x_base,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_1$');
xlim([0, t_c_base(end)]);

Layout;

subplot(412); hold on;
plot(t_c_base,u_y_base,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_2$');
xlim([0, t_c_base(end)]);

Layout;

subplot(413); hold on;
plot(t_c_base,u_z_base,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_3$');
xlim([0, t_c_base(end)]);

Layout;

subplot(414); hold on;
plot(t_c_base,u_xz_base,'m');

%xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_4$');
xlabel('Time [s]');
xlim([0, t_c_base(end)]);

Layout;



figure(3)
hold on;
plot(t,k1_base,'c')
ylabel('$k$');
xlabel('Time [s]');
xlim([0, t(end)]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;


figure(4)
subplot(4,1,1); hold on;
plot(t,dhx_base,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{1}$');
xlim([0, t(end)]);

Layout;

subplot(4,1,2); hold on;
plot(t,dhy_base,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{2}$');
xlim([0, t(end)]);

Layout;


subplot(4,1,3); hold on;
plot(t,dhz_base,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{3}$');
xlim([0, t(end)]);

Layout;


subplot(4,1,4); hold on;
plot(t,dhxz_base,'b');

%xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{4}$');
xlabel('Time [s]');
xlim([0, t(end)]);

Layout;