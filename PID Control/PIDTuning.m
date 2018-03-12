% Parameters system
K1 = 1;
K2 = 3;
Km = 1;
tau1 = 2;
tau2 = 6;
taum = 0.2;

% Parameters simulation
duur = 60;

% Run open loop system
sim('PIDTuningOpenLoop')

t = simout(:,1);
u = simout(:,2);
ym = simout(:,3);

plot(t,u,t,ym)
title('PID Tuning - Open loop')
xlabel('Time')
ylabel('Output')
legend('Setpoint', 'System output')

% Fit transfer function
data = iddata(ym,u,1);
td = 1.5;
sys = tfest(data,1,0,td);
K = sys.num/sys.den(2);
tau = 1/sys.den(2);

sim('PIDTuningNoControl')
t2 = simout(:,1);
u2 = simout(:,2);
ym2 = simout(:,3);

figure()
plot(t,u,t,ym)

% Calculate optimal parameters
Kc1 = 1/K*tau/td*(1+td/3/tau);
Kc2 = 1/K*tau/td*(0.9+td/12/tau);
Kc3 =  1/K*tau/td*(4/3+td/4/tau);
taui2 = td*(30+3*td/tau)/(9+20*td/tau);
taui3 =  td*(32+6*td/tau)/(13+8*td/tau);
taud3 = td*4/(11+2*td/tau);
Kc_help = [Kc1; Kc2 ;Kc3];
taui_help = [taui2; taui2 ;taui3] ;
taud_help = [0; 0; taud3];

hold on
for i = 1:3
    Kc = Kc_help(i);
    taui = taui_help(i);
    taud = taud_help(i);
    sim('PIDTuningControl')
    plot(simout(:,1), simout(:,3))
end
title('PID Tuning - Control')
xlabel('Time')
ylabel('Output')
legend('Setpoint', 'No Control', 'Optimal P control', 'Optimal PI control', 'Optimal PID control')