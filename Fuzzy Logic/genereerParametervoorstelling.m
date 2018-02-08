function par = genereerParametervoorstelling(x)
% xn=genereerParametervoorstelling(x)
% Input:        parametervector x met dimensies 1x(n+2) (n: aantal
%                   lidmaatschapsfuncties)
% Output:       parametermatrix par met dimensies nx4 
% Met deze functie wordt de korte vector met de n+2 parameters van de trapezoidale/triangulaire
% lidmaatschapsfuncties van een variabele, omgezet in een nx4 matrix.  Hierbij 
% is n het aantal lidmaatschapsfuncties van de variabele

a=2;
par(1,1)=x(1)-a;
par(1,2:4)=x(1:3); 
par(length(x)-2,1:3)=x(end-2:end);
par(length(x)-2,4)=x(end)+a;   
for i=2:length(x)-3
        par(i,1:2)=x(i:i+1);
        par(i,3:4)=x(i+1:i+2);
end,


