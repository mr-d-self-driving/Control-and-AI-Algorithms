function y = vaagmodel(x,ParVM)
% Dit is een functie die een Mamdani-Assilian model opstelt.
% Input:  x = Nx2 ingangsdata
%         ParVM structure met volgende velden:
%           x1par = parameters lidmaatschapsfuncties eerste ingangsvariable x1
%           x2par = parameters lidmaatschapsfuncties tweede ingangsvariable x2
%           ypar = parameters lidmaatschapsfuncties uitgangsvariable y
%           R = regelbank
% Output: y = kolomvector, bevat de waarden van de outputvariabele

% breng de lidmaatschapsfuncties van de twee ingangsvariabelen in het
% juiste formaat
ntriangularmsf = size(ParVM.x1par,2) - 4;
newmsf = [ParVM.x1par(1:2) reshape(repmat(ParVM.x1par(3:(end-2)),2,1),1,2*ntriangularmsf) ParVM.x1par((end-1):end)];
msfunctionsx(1,1) = {newmsf};

ntriangularmsf = size(ParVM.x2par,2) - 4;
newmsf = [ParVM.x2par(1:2) reshape(repmat(ParVM.x2par(3:(end-2)),2,1),1,2*ntriangularmsf) ParVM.x2par((end-1):end)];
msfunctionsx(1,2) = {newmsf};

% breng de lidmaatschapsfuncties van de uitgangsvariabele in het juiste
% formaat
ntriangularmsf = size(ParVM.ypar,2) - 4;
newmsf = [ParVM.ypar(1:2) reshape(repmat(ParVM.ypar(3:(end-2)),2,1),1,2*ntriangularmsf) ParVM.ypar((end-1):end)];
msfunctionsy = newmsf;

% bepaal maximale activatiegraad voor elke lidmaatschapsfunctie van de
% outputvariabele
nmembery = size(msfunctionsy,2)/2;
ffgrades = ffdegrees(msfunctionsx, nmembery, ParVM.R, x);

% bereken scherpe uitgangsvariabele y*
y = defuzzmodtransf(ffgrades,msfunctionsy);
