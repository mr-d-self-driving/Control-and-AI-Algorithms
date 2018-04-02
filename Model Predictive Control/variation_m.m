clear all
close all
clc

% Plot step response system
data = xlsread('step.xlsx');
t = data(:,1);
h = data(:,2);
figure(1)
plot(t,h)

% Characterise system
step = find(t == 63.28125); %plaats in excel waarbij stap plaatsvindt
h_step = h(step);
t_step = t(step);
h_end = h(end);
h_av = (h_end+h_step)/2;
t_av = t(506);
tau = (t_av-t_step)/log(2);
Ts = round(1/7.5*tau);

% Parameters
staptijd=1000;   
hvoor=3;      
hna=8;       
h0 = 0;
u0=0;
simulatietijd=3000;
stijl =['m', 'b', 'y','g', 'k'];
K=0.3;
p = 9;

% Run for different m and plot
m_help= [1 5 10 30 70];
for j= 1:length(m_help)
    m=m_help(j)
    for i = 1:p
    C(i) = (h(step+i*Ts)-h(1))/2;
    R = zeros(1,m);
    beta = toeplitz(C,R);
    end

    sim('System')
    tijd=simout(:,1);
    hoogte=simout(:,2);
    hoogtewens=simout(:,3);
    ingang=simout(:,4);
    hold on
    figure(2)
    plot(tijd,hoogte, stijl(j))
    
end

plot(tijd,hoogtewens,'r--')
axis([0 simulatietijd 0 12])
xlabel('Time')
ylabel('Height')
legend('m=1','m=5','m=10','m=30','m=70','Setpoint')
title('Variation of m-parameter (p = 9)')
hold off