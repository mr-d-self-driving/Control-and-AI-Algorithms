function y = vaagmodel(x,ParVM)
% Implementatie van een Mamdani-Assilian model
% Input:  x     ingangsdata
%	  ParVM     structure, bevat de parameters van het Mamdani-Assilian model
%         	    ParVM.x1par     vector, parameters van de lidmaatschapsfuncties van de eerste ingangsvariable x1
%         	    ParVM.x2par     vector, parameters van de lidmaatschapsfuncties van de tweede ingangsvariable x2
%         	    ParVM.ypar      vector, parameters van de lidmaatschapsfuncties van de uitgangsvariable y
%         	    ParVM.R         matrix die de regelbank voorstelt
% Output: y     vector, bevat de waarden van de outputvariabele

% Preallocatie van de activatiematrix
activatiematrix = zeros(size(ParVM.R,1),size(ParVM.R,2));
% Zet de vectoren x1par, x2par en ypar om in een werkbare vorm 
parameterx1=genereerParametervoorstelling(ParVM.x1par);
parameterx2=genereerParametervoorstelling(ParVM.x2par);
parametery=genereerParametervoorstelling(ParVM.ypar);
discrety= linspace(ParVM.ypar(1),ParVM.ypar(end),101);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hier komt de implementatie van het Mamdani-Assilian model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%bepaal de lidmaatschapsgraden van de ingangsdata
lid_x1 = berekenLidmaatschapsgraad(x(:,1), parameterx1);
lid_x2 = berekenLidmaatschapsgraad(x(:,2), parameterx2);

% voor elk datapunt
for i = 1:size(x,1)
    % Bepaal de activatiegraad voor elke individuele regel
    for j=1:size(ParVM.R,1)
        for k = 1:size(ParVM.R,2)
            activatiematrix(j,k) =  min(lid_x1(i,j), lid_x2(i,k));
        end
    end    
    
    % Bepaal de maximale activatiegraad voor elke lidmaatschapsfunctie van
    % de outputvariabele
   for l = 1:length(ParVM.ypar)-2
       activatiegraad(l) = max(max(activatiematrix(ParVM.R==l)));
   end     
    
    % Bepaal de vage uitgang
    uitgangsverloop = afknottenLidmaatschapsfuncties(discrety, parametery, activatiegraad);
    conclusie = max(uitgangsverloop')';
    
    
    % Bereken het zwaartepunt van de vage uitgang
    y(i) = sum(discrety*conclusie)/sum(conclusie);
    
end
y = y';
