% Parameters system
rho = 1000;
g = 10;
A = 20;
R = 15;
tau = A*R;
K_p = 10^(-5)*rho*g*R;

% Parameters step
t_step = 30*60;
p_voor = 2;
p_na = 3;

% P-control parameter
Kc = 2;

% Simulation parameters
simulatietijd = 3500;

% Measurement delay
td = 120;

% Run simulation and save output
sim('controlWithMeasurementDelay_model')
t = simout(:,1);
u = simout(:,2);
y = simout(:,3);
y_m = simout(:,4);

% Plot output
plot(t,u,t,y,t,y_m)
title('Control with Measurement Delay, Step at t = 1800')
xlabel('Time')
ylabel('Output')
legend('Controlled Input', 'Output','Measurement')