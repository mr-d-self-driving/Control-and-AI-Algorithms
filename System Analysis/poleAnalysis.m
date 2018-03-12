%% Transfer-function model first-order system

% Parameters transfer function
tau = 300;
K = 1.5;

% Initialize sytem
vat = tf([K], [tau,1])

% Plot root locations
figure()
rlocus(vat)

% Calculate root location gains
[K,poles] = rlocfind(vat)

%% Transfer-function model second-order system

% Parameters transfer-function
K = 1;
zeta = 0.5;
omega = 1;

% Initialize system
figure()
systeem = tf([K*omega^2], [1, 2*zeta*omega, omega^2])

% Plot root locations
rlocus(systeem)

% Calculate root locations
[K,poles] = rlocfind(systeem)


%% ZPK-model
% Parameters zpk-model
z = [-1.58 -0.42];
p = [0 -1/6 -1/2 -1/0.2 -1/3];
k = [1.5*0.05/6/2/0.02];

% Initialize system
systeem = zpk(z, p, k)

% Plot rootlocus
figure()
rlocus(systeem)

% Calculate root location gains
[K,poles] = rlocfind(systeem)