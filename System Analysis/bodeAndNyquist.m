%% First-order transfer function system
sys = tf([10],[1 6 16]);

% Nyquist plot
figure()
nyquist(sys)

% Bode Plot
figure()
bode(sys)

%% Series transfer function system
sys1 = tf(1,[1 0 0]);
sys2 = tf(16,[1 4 16]);
sys3 = zpk(-1,[],10);

% Series of systems 1-3
sys12 = series(sys1, sys2);
sys123 = series(sys12,sys3);

% Nyquist and Bode plot
figure()
nyquist(sys123)
figure()
bode(sys123)


%% Define system with pole coordinates
sys4 = zpk([],[-1 -2 -3],1)

% Nyquist and Bode plot
figure()
nyquist(sys4)
figure()
bode(sys4)




