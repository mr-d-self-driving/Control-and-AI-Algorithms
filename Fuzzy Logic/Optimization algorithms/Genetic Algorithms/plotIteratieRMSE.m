function plotIteratieRMSE(iteratieRMSE)
% Deze functie plot het verloop van de RMSE per iteratiestap.  
% Input: iteratieRMSE   Een vector die de waarden van de RMSE bevat


figure(1);
plot(iteratieRMSE,'k.');
hold on;
xlabel('iteratiestap')
ylabel('RMSE')