clc;

data = load('refdataGA.txt');
ParGA.pop=30;
ParGA.pmut=0.1;
ParGA.pcross=0.8;
ParGA.maxgen=50;

ParVM.x1par=[];
ParVM.x2par=[];
ParVM.ypar=[];
ParVM.R=[5 5 4 3;4 4 3 2;4 3 2 1];
ParVM.membersX1=3;
ParVM.membersX2=4;
ParVM.membersY=5;
decodering = [7;0;100;1;0;0;0];
[ParVM,iteratieRMSE]=genetischAlgoritme(data(:,1:2),data(:,3),ParVM,ParGA,decodering);