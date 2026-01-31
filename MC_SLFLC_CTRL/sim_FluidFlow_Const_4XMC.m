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
    X = rk4MC('f_FluidFlow_Const_4XMC',t0,x0,ii,h);
    t = [t;t0+h];
    Q = [Q;X'];
end

QQ{ii} = Q;


end



for ii = 1:6

Q = QQ{ii};
%% extract states
x(:,ii) = Q(:,1);
y(:,ii) = Q(:,2);
z(:,ii) = Q(:,3);
xz(:,ii) = Q(:,4);

k1(:,ii) = Q(:,5);

dhx(:,ii) = Q(:,6);
dhy(:,ii) = Q(:,7);
dhz(:,ii) = Q(:,8);
dhxz(:,ii) = Q(:,9);

% Reference trajectory
r1x(:,ii) = 5.*ones(size(t));
r1y(:,ii) = 4.*ones(size(t));
r1z(:,ii) = 10.*ones(size(t));
r1xz(:,ii) = 9.*ones(size(t));

filename = sprintf('exp_const_4XUn_%d.txt', ii);
% Open the dynamically named file in append mode
fileID = fopen(filename, 'r');
formatSpec = '%f %f %f %f %f';
sizeA = [5 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
t_c(ii,:) = A(1,:);
u_x(ii,:) = A(2,:);
u_y(ii,:) = A(3,:);
u_z(ii,:) = A(4,:);
u_xz(ii,:) = A(5,:);
end

% %% Plotting
close all;
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaulttextInterpreter','latex');
green = [0, 150, 0]/255;

figure(1)
subplot(4,1,1); hold on;
plot(t,x,'color',green);% actual trajectory
plot(t,r1x,'--r'); % desired trajectory
legend({'Developed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
ylim([-0.05, 11]);
ylabel('$x_1$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,2); hold on;
plot(t,y,'color',green);% actual trajectory
plot(t,r1y,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
ylim([-0.05, 11]);
ylabel('$x_2$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure


subplot(4,1,3); hold on;
plot(t,z,'color',green);% actual trajectory
plot(t,r1z,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
ylim([-0.05, 11]);
ylabel('$x_3$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,4); hold on;
plot(t,xz,'color',green);% actual trajectory
plot(t,r1xz,'--r'); % desired trajectory
ylabel('$x_4$');
xlabel('Time [s]');
ylim([-0.05, 11]);
xlim([0, t(end)]);
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure



figure(2) 
subplot(411); hold on;
plot(t_c,u_x,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_1$');
xlim([0, t_c(end)]);

Layout;

subplot(412); hold on;
plot(t_c,u_y,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_2$');
xlim([0, t_c(end)]);

Layout;

subplot(413); hold on;
plot(t_c,u_z,'m');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_3$');
xlim([0, t_c(end)]);

Layout;

subplot(414); hold on;
plot(t_c,u_xz,'m');

%xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$u_4$');
xlabel('Time [s]');
xlim([0, t_c(end)]);

Layout;



figure(3)
hold on;
plot(t,k1,'c')
ylabel('$k$');
xlabel('Time [s]');
xlim([0, t(end)]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;


figure(4)
subplot(4,1,1); hold on;
plot(t,dhx,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{1}$');
xlim([0, t(end)]);

Layout;

subplot(4,1,2); hold on;
plot(t,dhy,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{2}$');
xlim([0, t(end)]);

Layout;


subplot(4,1,3); hold on;
plot(t,dhz,'b');

xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{3}$');
xlim([0, t(end)]);

Layout;


subplot(4,1,4); hold on;
plot(t,dhxz,'b');

%xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
ylabel('$\hat{d}_{4}$');
xlabel('Time [s]');
xlim([0, t(end)]);

Layout;