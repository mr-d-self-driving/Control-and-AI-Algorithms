% Transfer function system
num_system = [3.5];
denom_system = [7 1];

% Transfer function Feedforward Control
num_ff = [1];
denom_ff = [1 1];

% Transfer function measurement
num_measurement = [-6 -1];
denom_measurement = [3 3];

% Parameters Feedback Control
K_c = 1;

% Simulation parameter
duur = 60;

% Run simulation
sim('FeedforwardBackward_model')

t = simout(:,1);
y = simout(:,2);
z = simout(:,3);

plot(t,y,t,z)
title('Feedforward-feedbackward Control')
xlabel('Time')
ylabel('Output')
legend('System output', 'Perturbation')