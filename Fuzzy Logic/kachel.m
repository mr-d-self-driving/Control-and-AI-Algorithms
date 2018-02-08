input = dlmread('refdata.txt');
x = input(:,1:2);
y = input(:,3);

ParVM.x1par = [0 30 60 90 100];
ParVM.x2par = [0 20 45 70 90 100];
ParVM.ypar = [0 15 30 50 60 80 100];
ParVM.R = [5 4 3 2;
            4 3 2 1;
            3 3 2 1];
  
y_model = vaagmodel(x,ParVM);

RMSE = sum((y-y_model).^2)/length(y_model);