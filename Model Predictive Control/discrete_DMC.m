function [sys,x0,str,Ts] = discrete_pid(t,x,in,flag,beta,K,Ts,u0)
% Discrete DCM functie
global previous;

u0=0;
switch flag,
  case 0,                                                
    [sys,x0,str,Ts] = mdlInitializeSizes(Ts,beta,u0);    
  case 2,                                               
    sys = mdlUpdate(t,x,in);
  case 3,                                               
    sys = mdlOutputs(t,x,in,beta,K);    
  case 9,                                               
    sys = [];
  otherwise
    error(['unhandled flag = ',num2str(flag)]);
end

%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
function [sys,x0,str,Ts]=mdlInitializeSizes(Ts,beta,u0)

global previous;

sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1; % de regelactie u
sizes.NumInputs      = 2; % gewenste waarde, meting
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;

sys = simsizes(sizes);

x0  = [];
str = [];
ts  = [Ts 0]; % Sample period

m = size(beta,2);
p = size(beta,1);

previous.u = u0;
previous.Du = zeros(m,1);
previous.y_hat_0 = zeros(p,1);

%=======================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=======================================================================
function sys = mdlUpdate(t,x,in)
sys = [];

%=======================================================================
% mdlOutputs
% Return the output vector for the S-function
%=======================================================================
function sys = mdlOutputs(t,x,in,beta,K)

global previous;

ysp     = in(1);
y       = in(2);

m = size(beta,2);
p = size(beta,1);

y_star(1:p,1) = ysp;

y_hat_0(1:p-1,1)= previous.y_hat_0(2:end,1) + beta(2:end,1)*previous.Du(1,1);
y_hat_0(p,1) = y_hat_0(p-1,1);

w_hat(1:p,1) = y - previous.y_hat_0(1,1)+beta(1,1)*previous.Du(1,1);
e = y_star - (y_hat_0 + w_hat);

Du = [inv(beta'*beta + K^2*eye(m))*beta'*e];

sys     = previous.u + Du(1);

previous.Du = Du;
previous.y_hat_0 = y_hat_0;
previous.u = sys;