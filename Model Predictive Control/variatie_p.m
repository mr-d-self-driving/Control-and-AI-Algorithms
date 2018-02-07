clear all
close all
clc

data = xlsread('Torricelli_staprespons_data.xlsx');
t = data(:,1);
h = data(:,2);
figure(1)
plot(t,h)

step = find(t == 63.28125); %plaats in excel waarbij stap plaatsvindt
h_step = h(step);
t_step = t(step);
h_end = h(end);
h_av = (h_end+h_step)/2;
t_av = t(506); % plaats in excel op h_av
tau = (t_av-t_step)/log(2);
Ts = round(1/7.5*tau);

staptijd=1000;        %                               (s)
hvoor=3;              %                               (cm)
hna=8;                %                               (cm)
h0 = 0;
u0=0;
simulatietijd=3000;
stijl =['m', 'b', 'g', 'k'];


K=0.3;
m = 5;
p_help = [5 10 50 100];

for j= 1:length(p_help)
    p=p_help(j)
    for i = 1:p
    C(i) = (h(step+i*Ts)-h(1))/2;
    R = zeros(1,m);
    beta = toeplitz(C,R);
    end
    %for k=1:length(p_help)
    %p= p_help(k)

    sim('TorricelliDMC')
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
xlabel('tijd (sec)')
ylabel('hoogte (cm)')
legend('h p=5','h p=10','h p=50','h p=100','h wens')
hold off

figure(3)
plot(tijd,ingang)


