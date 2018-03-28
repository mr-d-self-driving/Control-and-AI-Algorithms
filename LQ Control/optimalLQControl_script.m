%% Optimal LQ Control

% Initialization
clc
clear all

% Parameters
beta1 = 10;
beta2 = 100;
c = 19;
n0 = 10;
U0 = 0;
b = 0;
tijd = 10;

% State-space system
A = [-(beta1+c) 3*beta2;
    beta1 -beta2];
B = [-1;0];
C = [1 0;
    0 1];
D = [0;0];

% Optimal control weights
Q = [10 0;
    0 10];
R = [1];
N = [0;0];

% Setpoint
X_sp = [10^4 10^3];

% Optimal control
[k,M,E] = lqr(A,B,Q,R,N);
K1 = -k;
K2 = inv(R)*B'*(M+inv(A'-M*B*inv(R)*B')*M);

% Simulation
sim('optimalLQControl')
t = simout(:,1);
n = simout(:,2);
U = simout(:,3);

% Plot results
plot(t,n,t,U)
legend('n','U')