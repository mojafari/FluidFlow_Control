clc
clear all

load OpenLoopData.mat;

t = out.tout;
x_open = out.Out.Data(:,1);
y_open = out.Out.Data(:,2);
z_open = out.Out.Data(:,3);
xz_open = out.Out.Data(:,4);

% Reference trajectory
r1x_open = out.In.Data(1).*ones(size(t));
r1y_open = out.In.Data(2).*ones(size(t));
r1z_open = out.In.Data(3).*ones(size(t));
r1xz_open = out.In.Data(4).*ones(size(t));

% %% Plotting
close all;
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaulttextInterpreter','latex');
green = [0, 150, 0]/255;

figure(1)
subplot(4,1,1); hold on;
plot(t,x_open,'color',green);% actual trajectory
plot(t,r1x_open,'--r'); % desired trajectory
legend({'Open-Loop','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_1$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,2); hold on;
plot(t,y_open,'color',green);% actual trajectory
plot(t,r1y_open,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_2$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure


subplot(4,1,3); hold on;
plot(t,z_open,'color',green);% actual trajectory
plot(t,r1z_open,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(end)]);
% ylim([-0.05, 11]);
ylabel('$x_3$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,4); hold on;
plot(t,xz_open,'color',green);% actual trajectory
plot(t,r1xz_open,'--r'); % desired trajectory
ylabel('$x_4$');
xlabel('Time [s]');
% ylim([-0.05, 11]);
xlim([0, t(end)]);
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure



figure(2)
subplot(4,1,1); hold on;
plot(t,x_open,'color',green);% actual trajectory
plot(t,r1x_open,'--r'); % desired trajectory
legend({'Open-Loop','Desired'},'Orientation','horizontal')
xlim([0, t(1001)]);
% ylim([-0.05, 11]);
ylabel('$x_1$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,2); hold on;
plot(t,y_open,'color',green);% actual trajectory
plot(t,r1y_open,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(1001)]);
% ylim([-0.05, 11]);
ylabel('$x_2$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure


subplot(4,1,3); hold on;
plot(t,z_open,'color',green);% actual trajectory
plot(t,r1z_open,'--r'); % desired trajectory
% legend({'Proposed','Desired'},'Orientation','horizontal')
xlim([0, t(1001)]);
% ylim([-0.05, 11]);
ylabel('$x_3$');
xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(4,1,4); hold on;
plot(t,xz_open,'color',green);% actual trajectory
plot(t,r1xz_open,'--r'); % desired trajectory
ylabel('$x_4$');
xlabel('Time [s]');
% ylim([-0.05, 11]);
xlim([0, t(1001)]);
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure




figure(10)
subplot(2,1,1); hold on;
plot(t,x_open);% actual trajectory
plot(t,r1x_open,'--'); % desired trajectory
plot(t,y_open);% actual trajectory
plot(t,r1y_open,'--'); % desired trajectory
plot(t,z_open);% actual trajectory
plot(t,r1z_open,'--'); % desired trajectory
plot(t,xz_open);% actual trajectory
plot(t,r1xz_open,'--'); % desired trajectory
lgd = legend({'Open-Loop ($x_1$)','Desired ($x_1$)','Open-Loop ($x_2$)','Desired ($x_2$)','Open-Loop ($x_3$)','Desired ($x_3$)','Open-Loop ($x_4$)','Desired ($x_4$)'},'Orientation','horizontal');
lgd.NumColumns = 4;
xlim([0, t(end)]);
% ylim([3.5, 11]);
xlabel('Time [s]');
ylabel('$x_{1,2,3,4}$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure

subplot(2,1,2); hold on;
plot(t,x_open);% actual trajectory
plot(t,r1x_open,'--'); % desired trajectory
plot(t,y_open);% actual trajectory
plot(t,r1y_open,'--'); % desired trajectory
plot(t,z_open);% actual trajectory
plot(t,r1z_open,'--'); % desired trajectory
plot(t,xz_open);% actual trajectory
plot(t,r1xz_open,'--'); % desired trajectory
% lgd = legend({'Open-Loop ($x_1$)','Desired ($x_1$)','Open-Loop ($x_2$)','Desired ($x_2$)','Open-Loop ($x_3$)','Desired ($x_3$)','Open-Loop ($x_4$)','Desired ($x_4$)'},'Orientation','horizontal');
% lgd.NumColumns = 2;
xlim([0, t(1001)]);
% ylim([3.5, 11]);
xlabel('Time [s]');
ylabel('$x_{1,2,3,4}$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout; % Fancy layout for figure
