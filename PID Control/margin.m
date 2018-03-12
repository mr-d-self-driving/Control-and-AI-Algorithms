%% Gain and phase margin first-order transfer function system

% Initialization system
Kp = 10^-5*1000*10*15*2;
tau = 20*15;
sys= tf(Kp,[tau 1])

% Bode plot with gain and phase margin
figure()
margin(sys)


%% Gain and phase margin second-order zpk-system

% Initialization system
K2 = 3;
tau1 = 2;
tau2 = 6;
sys = zpk([],[-1/tau1 -1/tau2],K2/tau1/tau2)

% Bode plot with gain and phase margin
figure()
margin(sys)


%% Gain and phase margin third-order tf-system

% Initialization system
K2 = 3;
tau1 = 2;
tau2 = 6;
taum = 0.2;
Km = 1;
sys = zpk([],[-1/tau1 -1/tau2 -1/taum],K2*Km/tau1/tau2/taum)

% Bode plot with gain and phase margin
figure()
margin(sys)

% Root analysis
figure()
rlocus(sys)
[K poles]= rlocfind(sys)
