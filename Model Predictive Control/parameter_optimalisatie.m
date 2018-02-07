clear all
close all
clc

data = xlsread('Torricelli_staprespons_data.xlsx');
t = data(:,1);
h = data(:,2);

step = find(t == 63.28125); %plaats in excel waarbij stap plaatsvindt
h_step = h(step);
t_step = t(step);
h_end = h(end);
h_av = (h_end+h_step)/2;
t_av = t(506); % plaats in excel op h_av
tau = (t_av-t_step)/log(2);
Ts = round(1/7.5*tau);

% model parameters
staptijd=1000;
hvoor=3;
hna=8;
h0 = 0;
u0=0;
simulatietijd=5000;

% p, m en K optimalisatie
% eerst werd hier een screening gedaan van het volledige bereik van p en m ...
%(1 tot ongeveer 160). Op basis van deze resultaten werd vervolgen meer ...
%specifiek en nauwkeurig naar de best verkregen waarden gekeken.
p_help = 5:1:15;
m_help = 2:1:14;
K_help = 0.5:0.1:0.8;
SSE_good = 10^100;

for k = 1:length(p_help) % waarden van p
    p = p_help(k);
    for l = 1:length(m_help) % waarden van m
        m = m_help(l);
        for j = 1:length(K_help)
            K = K_help(j);
            
            % BEPALEN VAN BETA
            for i = 1:p
                C(i) = (h(step+i*Ts)-h(1))/2;
            end
            R = zeros(1,m);
            beta = toeplitz(C,R);
            
            % MODEL RUNNEN
            if p>m
                sim('TorricelliDMC_3stp')
                t = simout(:,1);
                hoogte=simout(:,2);
                hoogtewens=simout(:,3);
                ingang=simout(:,4);
                
                % CONSTRICTIE, INGANG MAG NIET GROTER ZIJN DAN 15
                if max(ingang) < 15
                    sse = sum((hoogte-hoogtewens).^2);
                % IS SSE BETER DAN SSE_GOOD?
                % ZO JA, WAARDEN OPSLAAN VOOR p, m en K
                
                if sse < SSE_good
                    SSE_good = sse;
                    p_good = p;
                    m_good = m;
                    K_good = K;
                end
                 end
            end
        end
    end
end

p =p_good
m =m_good
K = K_good
for i = 1:p
    C(i) = (h(step+i*Ts)-h(1))/2;
end
R = zeros(1,m);
beta = toeplitz(C,R);

sim('TorricelliDMC_3stp')
                t = simout(:,1);
                hoogte=simout(:,2);
                hoogtewens=simout(:,3);
                ingang=simout(:,4);



figure()
plot(t,hoogte,'g',t,hoogtewens,'r--')
axis([0 simulatietijd 0 15])
legend('hoogte','gewenste hoogte')
xlabel('Tijd (sec)')
ylabel('Hoogte (cm)')

figure()
plot(t,ingang)

legend('ingang')
xlabel('Tijd (sec)')
ylabel('Debiet (cm^3/sec)')


