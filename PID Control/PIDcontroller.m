% System parameters
K_2 = 3;
K_m = 1;
tau1 = 2;
tau2 = 6;
tau_m = 0.2;

% Step parameters
t_step = 5;
y_sp_voor = 0;
y_sp_na = 1;

% Simulation parameters
simulatietijd = 30;

%% Influence K_c of P-step
K_c_help = [0.05 1 5 7 8];

figure()
hold on
for i = 1:length(K_c_help)
    Kc = K_c_help(i);
    tau_i = 1/3*Kc;
    tau_d = 1;
    sim('PIDcontroller_model')

    t = simout(:,1);
    u = simout(:,2);
    y = simout(:,3);
    y_sp = simout(:,4);

    plot(t,y)
    title('PID controller - Influence K_c of P step')
    xlabel('Time')
    ylabel('Output')
    
end
plot(t,y_sp)
legend('K_c = 0.05', 'K_c = 1',  'K_c = 5',  'K_c = 7', 'K_c = 8', 'Setpoint')

%% Influence Tau_i of I-step
figure()
hold on
tau_i_help = [3 6 12];
for i = 1:length(tau_i_help)
    Kc = 5;
    tau_i = 1/tau_i_help(i)*Kc;
    tau_d = 1;
    sim('PIDcontroller_model')

    t = simout(:,1);
    u = simout(:,2);
    y = simout(:,3);
    y_sp = simout(:,4);

    plot(t,y)
    title('PID controller - Influence Tau_i of I step')
    xlabel('Time')
    ylabel('Output')
    
end
plot(t,y_sp)
legend('Tau_i = 3','Tau_i = 6','Tau_i = 12', 'Setpoint')

%% Influence Tau_d of D-step
figure()
hold on
tau_d_help = [.2 1 2];
for i = 1:length(tau_i_help)
    Kc = 5;
    tau_i = 1/3*Kc;
    tau_d = tau_d_help(i);
    sim('PIDcontroller_model')

    t = simout(:,1);
    u = simout(:,2);
    y = simout(:,3);
    y_sp = simout(:,4);

    plot(t,y)
    title('PID controller - Influence Tau_d of D step')
    xlabel('Time')
    ylabel('Output')
end
plot(t,y_sp)
legend('Tau_d = 0.2','Tau_d = 1','Tau_d = 2', 'Setpoint')