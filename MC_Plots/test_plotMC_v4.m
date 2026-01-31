clc
clear all
close all

%% Load data
load MC_SLFLC_10.mat   % Enhanced controller
load MC_FLC_10.mat     % Baseline controller (Feedback Linearization-based Control)

%% Global plotting setup
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');
set(groot,'defaulttextInterpreter','latex');

green = [0 150 0]/255;
red   = [180 40 40]/255;
blue  = [0 0.45 0.8];
mag   = [0.7 0 0.7];
alphaEnv = 0.25;

uncertainty = [3 6 9 12 15 18];

states   = {'x','y','z','xz'};
states_b = {'x_base','y_base','z_base','xz_base'};
refs     = {'r1x','r1y','r1z','r1xz'};
stateLabs = {'$x_1$','$x_2$','$x_3$','$x_4$'};

uStates   = {'u_x','u_y','u_z','u_xz'};
uStates_b = {'u_x_base','u_y_base','u_z_base','u_xz_base'};
uLabs     = {'$u_1$','$u_2$','$u_3$','$u_4$'};

dStates = {'dhx','dhy','dhz','dhxz'};
dLabs   = {'$\hat d_1$','$\hat d_2$','$\hat d_3$','$\hat d_4$'};

%% ============================================================
%% FIGURE 1 — Enhanced Controller: State Envelopes
%% ============================================================

figure(1)
for s = 1:4
    X = eval(states{s});
    R = eval(refs{s});

    subplot(4,1,s); hold on;

    fill([t; flipud(t)], ...
         [min(X,[],2); flipud(max(X,[],2))], ...
         green,'FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t,mean(X,2),'Color',green,'LineWidth',1.6);
    plot(t,R(:,1),'--r','LineWidth',1.2);

    xlim([0 t(end)]); 
    ylim([-0.05 11]);
    ylabel(stateLabs{s});
    yticklabels(strrep(yticklabels,'-','$-$'))

    if s<4, xticks([]); else xlabel('Time [s]'); end
    if s==1
        legend({'Envelope','Mean','Desired'}, ...
               'Orientation','horizontal');
    end
    Layout;
end

%% ============================================================
%% FIGURE 2 — Baseline Controller: State Envelopes
%% ============================================================

figure(2)
for s = 1:4
    X = eval(states_b{s});
    R = eval(refs{s});

    subplot(4,1,s); hold on;

    fill([t; flipud(t)], ...
         [min(X,[],2); flipud(max(X,[],2))], ...
         red,'FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t,mean(X,2),'Color',red,'LineWidth',1.6);
    plot(t,R(:,1),'--k','LineWidth',1.2);

    xlim([0 t(end)]); 
    ylim([-13 13]);
    ylabel(stateLabs{s});
    yticklabels(strrep(yticklabels,'-','$-$'))

    if s<4, xticks([]); else xlabel('Time [s]'); end
    if s==1
        legend({'Envelope','Mean','Desired'}, ...
               'Orientation','horizontal');
    end
    Layout;
end

%% ============================================================
%% FIGURE 3 — Control Inputs (Enhanced): Envelopes
%% ============================================================

figure(3)
for s = 1:4
    U = eval(uStates{s});   % [MC × time]
    U = U';
    t_c = t_c(1,:);

    subplot(4,1,s); hold on;

    fill([t_c'; flipud(t_c')], ...
         [min(U,[],2); flipud(max(U,[],2))], ...
         'm','FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t_c,mean(U,2),'Color',mag,'LineWidth',1.6);

    ylabel(uLabs{s});
    yticklabels(strrep(yticklabels,'-','$-$'))
    xlim([0 t_c(end)])

    if s<4, xticks([]); else xlabel('Time [s]'); end
    if s==1
        legend({'Envelope','Mean'},'Orientation','horizontal');
    end
    Layout;
end



%% ============================================================
%% FIGURE 4 — Control Inputs (Baseline): Envelopes
%% ============================================================

figure(4)
for s = 1:4
    U = eval(uStates_b{s});   % [MC × time]
    U = U';
    t_c = t_c_base(1,:);

    subplot(4,1,s); hold on;

    fill([t_c'; flipud(t_c')], ...
         [min(U,[],2); flipud(max(U,[],2))], ...
         'm','FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t_c,mean(U,2),'Color',mag,'LineWidth',1.6);

    ylabel(uLabs{s});
    yticklabels(strrep(yticklabels,'-','$-$'))
    xlim([0 t_c(end)])

    if s<4, xticks([]); else xlabel('Time [s]'); end
    if s==1
        legend({'Envelope','Mean'},'Orientation','horizontal');
    end
    Layout;
end
%% ============================================================
%% FIGURE 5 — Adaptive Gain k (Enhanced)
%% ============================================================

figure(5); hold on;
fill([t; flipud(t)], ...
     [min(k1,[],2); flipud(max(k1,[],2))], ...
     'c','FaceAlpha',alphaEnv,'EdgeColor','none');
plot(t,mean(k1,2),'c','LineWidth',1.6);

xlabel('Time [s]');
ylabel('$k$');
xlim([0 t(end)]);
yticklabels(strrep(yticklabels,'-','$-$'))
legend({'Envelope','Mean'},'Orientation','horizontal');
Layout;

%% ============================================================
%% FIGURE 6 — Disturbance Estimates (Enhanced)
%% ============================================================

figure(6)
for s = 1:4
    D = eval(dStates{s});

    subplot(4,1,s); hold on;

    fill([t; flipud(t)], ...
         [min(D,[],2); flipud(max(D,[],2))], ...
         blue,'FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t,mean(D,2),'Color',blue,'LineWidth',1.6);

    ylabel(dLabs{s});
    yticklabels(strrep(yticklabels,'-','$-$'))
    xlim([0 t(end)])

    if s<4, xticks([]); else xlabel('Time [s]'); end
    if s==1
        legend({'Envelope','Mean'},'Orientation','horizontal');
    end
    Layout;
end

%% ============================================================
%% FIGURE 7 — RMS Tracking Error vs Uncertainty
%% ============================================================

figure(7); box on;
for s = 1:4
    X  = eval(states{s});
    Xb = eval(states_b{s});
    R  = eval(refs{s});

    for ii = 1:6
        RMS_e(ii) = sqrt(mean((X(:,ii)-R(:,ii)).^2));
        RMS_b(ii) = sqrt(mean((Xb(:,ii)-R(:,ii)).^2));
    end

    subplot(2,2,s); hold on;
    plot(uncertainty,RMS_e,'o-','Color',green,'LineWidth',1.8);
    plot(uncertainty,RMS_b,'s--','Color',red,'LineWidth',1.8);

    xlabel('Uncertainty [\%]');
    ylabel(['RMS ' stateLabs{s}]);
    grid on;

    if s==1
        legend({'Enhanced','Baseline'},'Location','northwest');
    end
    Layout;
end
sgtitle('RMS Tracking Error vs Parametric Uncertainty','Interpreter','latex');

%% ============================================================
%% FIGURE 8 — RMS Control Effort vs Uncertainty
%% ============================================================

figure(8); box on;
for s = 1:4
    U  = eval(uStates{s});
    Ub = eval(uStates_b{s});

    for ii = 1:6
        RMSu_e(ii) = sqrt(mean(U(ii,:).^2));
        RMSu_b(ii) = sqrt(mean(Ub(ii,:).^2));
    end

    subplot(2,2,s); hold on;
    plot(uncertainty,RMSu_e,'o-','Color',green,'LineWidth',1.8);
    plot(uncertainty,RMSu_b,'s--','Color',red,'LineWidth',1.8);

    xlabel('Uncertainty [\%]');
    ylabel(['RMS ' uLabs{s}]);
    grid on;

    if s==1
        legend({'Enhanced','Baseline'},'Location','northwest');
    end
    Layout;
end
sgtitle('RMS Control Effort vs Parametric Uncertainty','Interpreter','latex');

%% ============================================================
%% FIGURE 9 — Worst-Case Error Boxplots (18%)
%% ============================================================

worst = 6;
figure(9); box on;

for s = 1:4
    X  = eval(states{s});
    Xb = eval(states_b{s});
    R  = eval(refs{s});

    subplot(2,2,s);
    boxplot([X(:,worst)-R(:,worst), Xb(:,worst)-R(:,worst)], ...
            'Labels',{'Enhanced','Baseline'});
    ylabel(['Error ' stateLabs{s}]);
    grid on;
    Layout;
end
sgtitle('Tracking Error Distribution at 18\% Uncertainty','Interpreter','latex');



%% ============================================================
%% FIGURE 10 — NRMS Tracking Error vs Uncertainty
%% ============================================================

figure(10); box on;

for s = 1:4
    X  = eval(states{s});
    Xb = eval(states_b{s});
    R  = eval(refs{s});

    for ii = 1:6
        e  = X(:,ii)  - R(:,ii);
        eb = Xb(:,ii) - R(:,ii);

        RMS_e  = sqrt(mean(e.^2));
        RMS_b  = sqrt(mean(eb.^2));
        RMS_r  = sqrt(mean(R(:,ii).^2));   % reference RMS

        NRMS_e(ii) = RMS_e / RMS_r;
        NRMS_b(ii) = RMS_b / RMS_r;
    end

    subplot(2,2,s); hold on;
    plot(uncertainty,NRMS_e,'o-','Color',green,'LineWidth',1.8);
    plot(uncertainty,NRMS_b,'s--','Color',red,'LineWidth',1.8);

    xlabel('Uncertainty [\%]');
    ylabel(['NRMS ' stateLabs{s}]);
    grid on;

    if s==1
        legend({'Enhanced','Baseline'},'Location','northwest');
    end
    Layout;
end

sgtitle('Normalized RMS Tracking Error vs Parametric Uncertainty', ...
        'Interpreter','latex');

%% ============================================================
%% FIGURE 11 — NRMS Control Effort vs Uncertainty
%% ============================================================

figure(11); box on;

for s = 1:4
    U  = eval(uStates{s});
    Ub = eval(uStates_b{s});

    for ii = 1:6
        u  = U(ii,:);
        ub = Ub(ii,:);

        RMSu_e = sqrt(mean(u.^2));
        RMSu_b = sqrt(mean(ub.^2));

        umax = max(abs([u ub]));   % common normalization

        NRMSu_e(ii) = RMSu_e / umax;
        NRMSu_b(ii) = RMSu_b / umax;
    end

    subplot(2,2,s); hold on;
    plot(uncertainty,NRMSu_e,'o-','Color',green,'LineWidth',1.8);
    plot(uncertainty,NRMSu_b,'s--','Color',red,'LineWidth',1.8);

    xlabel('Uncertainty [\%]');
    ylabel(['NRMS ' uLabs{s}]);
    grid on;

    if s==1
        legend({'Enhanced','Baseline'},'Location','northwest');
    end
    Layout;
end

sgtitle('Normalized RMS Control Effort vs Parametric Uncertainty', ...
        'Interpreter','latex');


%% ============================================================
%% FIGURE 12 — Peak Control Effort vs Uncertainty
%% ============================================================

figure(12); box on;

for s = 1:4
    U  = eval(uStates{s});
    Ub = eval(uStates_b{s});

    for ii = 1:6
        Peak_e(ii) = max(abs(U(ii,:)));
        Peak_b(ii) = max(abs(Ub(ii,:)));
    end

    subplot(2,2,s); hold on;
    plot(uncertainty,Peak_e,'o-','Color',green,'LineWidth',1.8);
    plot(uncertainty,Peak_b,'s--','Color',red,'LineWidth',1.8);

    xlabel('Uncertainty [\%]');
    ylabel(['Peak ' uLabs{s}]);
    grid on;

    if s==1
        legend({'Enhanced','Baseline'},'Location','northwest');
    end
    Layout;
end

sgtitle('Peak Control Effort vs Parametric Uncertainty', ...
        'Interpreter','latex');






figure(100)

%% ===== (1,1) States =====
subplot(2,2,1); hold on;
for s = 1:4
    X = eval(states{s});
    R = eval(refs{s});

    fill([t; flipud(t)], ...
         [min(X,[],2); flipud(max(X,[],2))], ...
         green,'FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t,mean(X,2),'Color',green,'LineWidth',1.4);
    plot(t,R(:,1),'--r','LineWidth',1.1);
end
title('States');
xlabel('Time [s]');
ylabel('States');
xlim([0 t(end)]);
Layout;

%% ===== (1,2) Control Inputs =====
subplot(2,2,2); hold on;
for s = 1:4
    U = eval(uStates{s})';     % time × MC
    fill([t_c'; flipud(t_c')], ...
         [min(U,[],2); flipud(max(U,[],2))], ...
         mag,'FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t_c,mean(U,2),'Color',mag,'LineWidth',1.4);
end
title('Control Inputs');
xlabel('Time [s]');
ylabel('u');
xlim([0 t_c(end)]);
Layout;

%% ===== (2,1) Adaptive Gain k =====
subplot(2,2,3); hold on;
fill([t; flipud(t)], ...
     [min(k1,[],2); flipud(max(k1,[],2))], ...
     'c','FaceAlpha',alphaEnv,'EdgeColor','none');
plot(t,mean(k1,2),'c','LineWidth',1.6);

title('Adaptive Gain $k$');
xlabel('Time [s]');
ylabel('$k$');
xlim([0 t(end)]);
Layout;

%% ===== (2,2) Disturbance Estimates =====
subplot(2,2,4); hold on;
for s = 1:4
    D = eval(dStates{s});
    fill([t; flipud(t)], ...
         [min(D,[],2); flipud(max(D,[],2))], ...
         blue,'FaceAlpha',alphaEnv,'EdgeColor','none');
    plot(t,mean(D,2),'Color',blue,'LineWidth',1.4);
end
title('Disturbance Estimates');
xlabel('Time [s]');
ylabel('$\hat d$');
xlim([0 t(end)]);
Layout;




figure(110)

%% ===== (1,1) States =====
subplot(2,2,1); hold on;
for s = 1:4
    X = eval(states_b{s});
    R = eval(refs{s});

    fill([t; flipud(t)], ...
         [min(X,[],2); flipud(max(X,[],2))], ...
         red,'FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t,mean(X,2),'Color',red,'LineWidth',1.4);
    plot(t,R(:,1),'--k','LineWidth',1.1);
end
title('States');
xlabel('Time [s]');
ylabel('States');
xlim([0 t(end)]);
Layout;

%% ===== (1,2) Control Inputs =====
subplot(2,2,2); hold on;
for s = 1:4
    U = eval(uStates_b{s})';
    fill([t_c_base'; flipud(t_c_base')], ...
         [min(U,[],2); flipud(max(U,[],2))], ...
         mag,'FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t_c_base,mean(U,2),'Color',mag,'LineWidth',1.4);
end
title('Control Inputs');
xlabel('Time [s]');
ylabel('u');
xlim([0 t_c_base(end)]);
Layout;

%% ===== (2,1) k = 1 (constant) =====
subplot(2,2,3); hold on;
plot(t,ones(size(t)),'k','LineWidth',1.6);

title('Gain $k$');
xlabel('Time [s]');
ylabel('$k$');
xlim([0 t(end)]);
Layout;

%% ===== (2,2) Disturbance Estimates = 0 =====
subplot(2,2,4); hold on;
plot(t,zeros(size(t)),'k','LineWidth',1.6);

title('Disturbance Estimates');
xlabel('Time [s]');
ylabel('$\hat d$');
xlim([0 t(end)]);
Layout;







cols = lines(4);      % consistent colors for channels

figure(1000)

%% ============================================================
%% (1,1) States — Enhanced
%% ============================================================
subplot(2,2,1); hold on;

for s = 1:4
    X = eval(states{s});   % time × MC
    R = eval(refs{s});     % time × 1

    % Envelope
    fill([t; flipud(t)], ...
         [min(X,[],2); flipud(max(X,[],2))], ...
         cols(s,:), ...
         'FaceAlpha',alphaEnv,'EdgeColor','none');

    % Mean trajectory
    plot(t,mean(X,2),'Color',cols(s,:),'LineWidth',1.5);

    % Desired trajectory
    plot(t,R(:,1),'--','Color',cols(s,:),'LineWidth',1.2);
end

% title('States (Enhanced)');
xlabel('Time [s]');
ylabel('$x_{1,2,3,4}$');
xlim([0 t(end)]);
yticklabels(strrep(yticklabels,'-','$-$'))

lgd = legend({ ...
    'Env $x_1$','Mean $x_1$','Ref $x_1$', ...
    'Env $x_2$','Mean $x_2$','Ref $x_2$', ...
    'Env $x_3$','Mean $x_3$','Ref $x_3$', ...
    'Env $x_4$','Mean $x_4$','Ref $x_4$'}, ...
    'Orientation','horizontal');
lgd.NumColumns = 3;

Layout;

%% ============================================================
%% (1,2) Control Inputs — Enhanced
%% ============================================================
subplot(2,2,2); hold on;

for s = 1:4
    U = eval(uStates{s})';     % time × MC

    fill([t_c'; flipud(t_c')], ...
         [min(U,[],2); flipud(max(U,[],2))], ...
         cols(s,:), ...
         'FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t_c,mean(U,2),'Color',cols(s,:),'LineWidth',1.5);
end

% title('Control Inputs (Enhanced)');
xlabel('Time [s]');
ylabel('$u_{1,2,3,4}$');
xlim([0 t_c(end)]);
yticklabels(strrep(yticklabels,'-','$-$'))

lgd = legend({'Env $u_1$', 'Mean $u_1$', ...
    'Env $u_2$', 'Mean $u_2$', ...
    'Env $u_3$', 'Mean $u_3$', ...
    'Env $u_4$', 'Mean $u_4$'}, ...
             'Orientation','horizontal');
lgd.NumColumns = 4;

Layout;

%% ============================================================
%% (2,1) Adaptive Gain k — Enhanced
%% ============================================================
subplot(2,2,3); hold on;

fill([t; flipud(t)], ...
     [min(k1,[],2); flipud(max(k1,[],2))], ...
     'c','FaceAlpha',alphaEnv,'EdgeColor','none');

plot(t,mean(k1,2),'c','LineWidth',1.6);

% title('Adaptive Gain $k$');
xlabel('Time [s]');
ylabel('$k$');
xlim([0 t(end)]);
yticklabels(strrep(yticklabels,'-','$-$'))

lgd = legend({'Envelope','Mean'},'Orientation','horizontal');
lgd.NumColumns = 2;

Layout;

%% ============================================================
%% (2,2) Disturbance Estimates — Enhanced
%% ============================================================
subplot(2,2,4); hold on;

for s = 1:4
    D = eval(dStates{s});   % time × MC

    fill([t; flipud(t)], ...
         [min(D,[],2); flipud(max(D,[],2))], ...
         cols(s,:), ...
         'FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t,mean(D,2),'Color',cols(s,:),'LineWidth',1.5);
end

% title('Disturbance Estimates (Enhanced)');
xlabel('Time [s]');
ylabel('$\hat d_{1,2,3,4}$');
xlim([0 t(end)]);
yticklabels(strrep(yticklabels,'-','$-$'))

lgd = legend({'Env $\hat d_1$','Mean $\hat d_1$', ...
    'Env $\hat d_2$','Mean $\hat d_2$', ...
    'Env $\hat d_3$','Mean $\hat d_3$', ...
    'Env $\hat d_4$','Mean $\hat d_4$'}, ...
             'Orientation','horizontal');
lgd.NumColumns = 4;

Layout;



figure(1100)

%% ============================================================
%% (1,1) States — Baseline
%% ============================================================
subplot(2,2,1); hold on;

for s = 1:4
    X = eval(states_b{s});
    R = eval(refs{s});

    fill([t; flipud(t)], ...
         [min(X,[],2); flipud(max(X,[],2))], ...
         cols(s,:), ...
         'FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t,mean(X,2),'Color',cols(s,:),'LineWidth',1.5);
    plot(t,R(:,1),'--','Color',cols(s,:),'LineWidth',1.2);
end

% title('States (Baseline)');
xlabel('Time [s]');
ylabel('$x_{1,2,3,4}$');
xlim([0 t(end)]);
yticklabels(strrep(yticklabels,'-','$-$'))

lgd = legend({ ...
    'Env $x_1$/$u_1$','Mean $x_1$/$u_1$','Ref $x_1$', ...
    'Env $x_2$/$u_2$','Mean $x_2$/$u_2$','Ref $x_2$', ...
    'Env $x_3$/$u_3$','Mean $x_3$/$u_3$','Ref $x_3$', ...
    'Env $x_4$/$u_4$','Mean $x_4$/$u_4$','Ref $x_4$'}, ...
    'Orientation','horizontal');
% lgd.NumColumns = 6;

Layout;

%% ============================================================
%% (1,2) Control Inputs — Baseline
%% ============================================================
subplot(2,2,2); hold on;

for s = 1:4
    U = eval(uStates_b{s})';     % time × MC

    fill([t_c_base'; flipud(t_c_base')], ...
         [min(U,[],2); flipud(max(U,[],2))], ...
         cols(s,:), ...
         'FaceAlpha',alphaEnv,'EdgeColor','none');

    plot(t_c_base,mean(U,2),'Color',cols(s,:),'LineWidth',1.5);
end

% title('Control Inputs (Baseline)');
xlabel('Time [s]');
ylabel('$u_{1,2,3,4}$');
xlim([0 t_c_base(end)]);
yticklabels(strrep(yticklabels,'-','$-$'))

% lgd1 = legend({'Env $u_1$', 'Mean $u_1$', ...
%     'Env $u_2$', 'Mean $u_2$', ...
%     'Env $u_3$', 'Mean $u_3$', ...
%     'Env $u_4$', 'Mean $u_4$'}, ...
%              'Orientation','horizontal');
% lgd1.NumColumns = 4;

Layout;

%% ============================================================
%% (2,1) Gain k = 1 — Baseline
%% ============================================================
k1_BaseLine = ones(size(t));

subplot(2,2,3); hold on;
plot(t,k1_BaseLine,'c')
lgd = legend({'k'},'Orientation','horizontal');
lgd.NumColumns = 1;
xlim([0, t(end)]);
% ylim([3.5, 11]);
xlabel('Time [s]');
ylabel('$k$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;

%% ============================================================
%% (2,2) Disturbance Estimates = 0 — Baseline
%% ============================================================


dhx_BaseLine = zeros(size(t));
dhy_BaseLine = zeros(size(t));
dhz_BaseLine = zeros(size(t));
dhxz_BaseLine = zeros(size(t));
subplot(2,2,4); hold on;
plot(t,dhx_BaseLine);
plot(t,dhy_BaseLine);
plot(t,dhz_BaseLine);
plot(t,dhxz_BaseLine);
lgd = legend({'$\hat{d}_{1}$','$\hat{d}_{2}$','$\hat{d}_{3}$','$\hat{d}_{4}$'},'Orientation','horizontal');
lgd.NumColumns = 4;
xlim([0, t(end)]);
% ylim([3.5, 11]);
xlabel('Time [s]');
ylabel('$\hat{d}_{1,2,3,4}$');
% xticks([]);
yticklabels(strrep(yticklabels,'-','$-$'))
Layout;
