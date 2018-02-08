clear all
data = load('refdataGA.txt');
x = data(:,1:2);
y = data(:,3);
D = [7 0 100 1 0 0 0]';

ParVM.R =  [5 5 4 3;
            4 4 3 2;
            4 3 2 1];
ParVM.membersX1 = 3;
ParVM.membersX2 = 4;
ParVM.membersY = 5;
ParVM.x1par = [];
ParVM.x2par = [];
ParVM.ypar = [];
        
ParGA.maxgen = 50;        
ParGA.pop = 30;  
ParGA.pcross = 0.99;
ParGA.pmut = 0.01;


% uitkomst = [];
% x1 = [];
% x2 = [];
% y_uit = [];
% finaal = zeros(1,5);
% for i =1:5
%     [ParVM_uit,iteratieRMSE]=genetischAlgoritme(x,y,ParVM,ParGA,D);
%     uitkomst = [uitkomst; iteratieRMSE];
%     x1 = [x1; ParVM_uit.x1par];
%     x2 = [x2; ParVM_uit.x2par];
%     y_uit = [y_uit; ParVM_uit.ypar];
%     finaal(i) = iteratieRMSE(end);
%     subplot(3,2,i)
%     plot(uitkomst(i,:))
% end
% mean(finaal)

ParVM.x1par = [];
ParVM.x2par = [0 20 40 60 80 100];
[ParVM_uit,iteratieRMSE]=genetischAlgoritme(x,y,ParVM,ParGA,D)
ParVM_uit.x1par
ParVM_uit.x2par