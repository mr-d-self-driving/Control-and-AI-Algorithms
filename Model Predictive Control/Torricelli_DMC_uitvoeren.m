clear all
close all
clc

data = xlsread('Torricelli_staprespons_data.xlsx');
t = data(:,1);
h = data(:,2);
figure(1)
plot(t,h)
xlabel('Tijd (sec)')
ylabel('Hoogte (cm)')

step = find(t == 63.28125); %plaats in excel waarbij stap plaatsvindt
h_step = h(step);
t_step = t(step);
h_end = h(end);
h_av = (h_end+h_step)/2;
t_av = t(506); % plaats in excel op h_av
tau = (t_av-t_step)/log(2);
Ts = round(1/7.5*tau)

p = 9;
m = 2;
for i = 1:p
    C(i) = (h(step+i*Ts)-h(1))/2;
end
R = zeros(1,m);
beta = toeplitz(C,R);

staptijd=1000;        %                               (s)
hvoor=3;              %                               (cm)
hna=8;                %                               (cm)
h0 = 0;
u0=0;

K =0.3;

simulatietijd=3000;

sim('TorricelliDMC')
tijd=simout(:,1);
hoogte=simout(:,2);
hoogtewens=simout(:,3);
ingang=simout(:,4);

figure()
plot(tijd,hoogte,'g',tijd,hoogtewens,'r--')
axis([0 simulatietijd 0 12])
legend('hoogte','gewenste hoogte')

figure()
plot(tijd,ingang)
