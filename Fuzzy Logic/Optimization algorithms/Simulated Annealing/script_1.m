ParVM.x1par = [0 30 60 90 100];
ParVM.x2par = [0 20 45 70 90 100];
ParVM.ypar = [0 15 30 50 60 80 100];
% 
% ParVM.x1par = [0 25 50 75 100];
% ParVM.x2par = [0 20 40 60 80 100];
% ParVM.ypar = [0 17 33 50 67 83 100];

omgeving = [-1 1];

% data = load('refdata.txt');
% x = data(:,1:2);
% y = data(:,3);

% [ParVM,iteratieRMSE]=hillClimbing(x,y,ParVM,omgeving);

% uitkomst = zeros(1,10);
% for i=1:10
%     i
%     [ParVM,iteratieRMSE]=hillClimbing(x,y,ParVM,omgeving);
%     uitkomst(i) = length(iteratieRMSE);
% end
% mean(uitkomst)

% ParSA.Tmax = 1e5;      
% ParSA.Tmin = 1e-5;   
% ParSA.r = 0.5;        
% ParSA.kT = 5; 

ParSA.Tmax = 10;      
ParSA.Tmin = 0.01;   
ParSA.r = 0.7;        
ParSA.kT = 10;

[ParVM,iteratieRMSE]=simulatedAnnealing(x,y,ParVM,omgeving, ParSA)
ParVM.R
plot(iteratieRMSE)