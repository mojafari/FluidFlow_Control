function ds = f_FluidFlow_SMC_Base(t,s)
%% ============================================================
%  Sliding Mode Control for 4-State Nonlinear Fluid Flow System
%  Robust baseline controller (no model cancellation)
%% ============================================================

%% ----------------- Extract states -----------------
x = s(1:4);

x1 = x(1); x2 = x(2); x3 = x(3); x4 = x(4);

%% ----------------- Reference -----------------
r = [5; 4; 10; 9];
%% disturbance
d_1 = 5;    % actual disturbance
d_2 = 4;    % actual disturbance
d_3 = 3;    % actual disturbance
d_4 = 2;    % actual disturbance
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

%% Definition of Fluid Flow parameters

dx1 = L1 + M11*x1 + N111*x1^2 + N121*x1*x2 + N131*x1*x3 + N141*x1*x4;
dx2 = L2 + M22*x2 + M23*x3 + N212*x1*x2 + O2222*x2^3 + O2233*x2*x3^2;
dx3 = L3 + M32*x2 + M33*x3 + N313*x1*x3 + N314*x1*x4 + O3223*x3*x2^2 + O3333*x3^3;
dx4 = L4 + M41*x1 + M44*x4 + N414*x1*x4 + N424*x2*x4 + N434*x3*x4 + N444*x4^2;


F = [dx1;dx2;dx3;dx4];

d = d1;

% %% ----------------- Sliding Mode Control -----------------

lambda = 0.8.*[1; 1; 1; 1];     % sliding slope
phi    = 1.0.*[1; 1; 1; 1];     % boundary layer


% Gains must dominate nonlinearities
K = [2500; 2500; 1300; 2000];

% Sliding surface
e = (r - x);

s = lambda.*e;

% Saturation function
sat_s = max(min(s ./ phi, 1), -1);

% Control law
u = K .* sat_s;

%% ----------------- Control saturation (safety) -----------------
u_max = 5000;
u = max(min(u, u_max), -u_max);

%% ----------------- Plant dynamics -----------------
x_dot = F + u +d;

%% ----------------- Log control input -----------------
fileID = fopen('exp_const_4X_SMC_Base.txt','a');
fprintf(fileID,'%f %f %f %f %f\n',[t; u(1); u(2); u(3); u(4)]);
fclose(fileID);
%% ----------------- Pack derivatives -----------------
ds = zeros(4,1);
ds(1:4) = x_dot;

end
