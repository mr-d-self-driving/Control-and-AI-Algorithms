%% Initialization

% Parameters
kin = 0;
b1 = 0.02;
d2 = 0.02;
b2 = 0.01;
d1 = 0.01;
d3 = 0.01;
a = 0.001;
kV = 2000;
Y = 100;
k0 = -1.22*10^3;
s0 = 500;
v0 = -2.22;
tijd = 100;

% State-space system
A = [b1-d1-Y*a 0 0;
    0 b2-d2 0;
    a 0 -d3];
B = [1;0;0];
C = [1 0 0;
    0 1 0;
    0 0 1];
D = [0;0;0];

% Equilibrium points
kev = (Y*a*kV)/(d1 - b1 + Y*a);
vev = (a*kV*(b1 - d1))/(d3*(d1 - b1 + Y*a));


%% Plot simulation results
% Run this segment after the chosen simulation
t = simout(:,1);
k = simout(:,2);
s = simout(:,3);
v = simout(:,4);
subplot(3,1,1)
hold on
plot(t,k+kev,'o')
subplot(3,1,2)
hold on
plot(t,s,'o')
subplot(3,1,3)
hold on
plot(t,v+vev,'o')


%% Uncontrolled state-space system
sim('noControl')


%% LQ Controlled state-space system

% Transformation and control matrix (see calculation1.nb)
T = [1 0 0;
    0 0 1;
    0 1 0];
K = [-1.9 -980.1 0]*inv(T);

sim('LQControl')


%% Uncontrolled state-space system with state observer

% State-space system, the output matrices are other than in the system
% without observer (otherwise, no observer would be needed)
A2 = A;
B2 = B;
C2 = [0.5 0.4 0;
    0 0 2];
D2 = [0;0];

% Observer matrix (see calculations1.nb)
H = [1 1;
    1 1;
    0 1];
AS = A2-H*C2;
BS = [H B2-H*D2];
CS = [1 0 0;
    0 1 0;
    0 0 1];
DS = [0 0 0;
    0 0 0;
    0 0 0];

sim('noControlObserver')


%% LQ Controlled state-space system with state observer
% The same weights vector K for the LQ controller is used as in the system
% without observer

sim('LQControlObserver')


%% LQ Controlled state-space system with reduced order state observer

% Transformation matrices
TR = [1 0 0;C2];
HR = [-22.75 0];

% Transformed matrices
AT2 = TR*A2*inv(TR);
BT2 = TR*B2;
CT2 = C2*inv(TR);

% Reduced order observer
AR = AT2(1,1) - HR*AT2(2:3,1);
BR = [(AT2(1,1)-HR*AT2(2:3,1))*HR + AT2(1,2:3)-HR*AT2(2:3,2:3) BT2(1)-HR*BT2(2:3) - (AT2(1,1)-HR*AT2(2:3,1))*HR*D2];
CR = 1;
DR = [0 0 0];
init = 0 - HR*C2*[k0-kev;s0;v0-vev] + HR * D2 * kin;

sim('LQControlReducedOrderObserver')
