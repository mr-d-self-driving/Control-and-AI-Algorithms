clear all
% parameters van de lidmaatschapsfuncties van de eerste ingangsvariabele
ParVM.x1par = [0 20 40 60 80 100];
% parameters van de lidmaatschapsfuncties van de tweede ingangsvariabele
ParVM.x2par = [0 15 40 65 90 100];
% parameters van de lidmaatschapsfuncties van de uitgangsvariabele
ParVM.ypar = [0 15 30 50 60 80 100];
% regelbank
% indices van de rijen komen overeen met het nummer van de lidmaatschapsfunctie van de ingangsvariabele x1
% indices van de kolommen komen overeen met het nummer van de lidmaatschapsfunctie van de ingangsvariabele x2
% waarden in de matrix R komen overeen met het nummer van de lidmaatschapsfunctie van de uitgangsvariabele y
ParVM.R = [5 5 4 3; 5 4 3 2; 4 3 3 2; 3 2 1 1];

x = dlmread('data_vraag2.txt');
y = vaagmodel(x, ParVM);
save('uitkomst_vraag2.txt', 'y', '-ASCII')