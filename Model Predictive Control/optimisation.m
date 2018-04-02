clear all
close all
clc

% Read data
data = xlsread('step.xlsx');
t = data(:,1);
h = data(:,2);

% Characterise system
step = find(t == 63.28125); 
h_step = h(step);
t_step = t(step);
h_end = h(end);
h_av = (h_end+h_step)/2;
t_av = t(506); 
tau = (t_av-t_step)/log(2);
Ts = round(1/7.5*tau);

% model parameters
staptijd=1000;
hvoor=3;
hna=8;
h0 = 0;
u0=0;
simulatietijd=5000;

% p, m and K optimalisation range
p_help = 5:1:15;
m_help = 2:1:14;
K_help = 0.5:0.1:0.8;
SSE_good = 10^100;

% Brute force search
for k = 1:length(p_help) 
    p = p_help(k);
    for l = 1:length(m_help)
        m = m_help(l);
        for j = 1:length(K_help)
            K = K_help(j);
            
            for i = 1:p
                C(i) = (h(step+i*Ts)-h(1))/2;
            end
            R = zeros(1,m);
            beta = toeplitz(C,R);

            if p>m
                sim('System')
                t = simout(:,1);
                hoogte=simout(:,2);
                hoogtewens=simout(:,3);
                ingang=simout(:,4);
                
                if max(ingang) < 15
                    sse = sum((hoogte-hoogtewens).^2);
                
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