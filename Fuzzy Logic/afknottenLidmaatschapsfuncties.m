function y = afknottenLidmaatschapsfuncties(dat,par,activatiegraad)
% y=afknottenLidmaatschapsfuncties(dat,par,activatiegraad)
% berekent voor een reeks van waarden van een variablele de activiteit van elke lidmaatschapgraad
% deze lidmaatschapsgraad wordt afgeknot volgens activatiegraad, meegegeven voor elk data punt
% input: dat:            kolomvector, bevat waarden voor die variabele 
%                        waarvoor de lidmaatschapsgraad afgeknot wordt  
%        par:            n * 4 matrix, bevat de parameters van de N lidmaatschapsfuncties
%        activatiegraad: 1 * n vector, de hoogte waarop de consequent lidmaatschapsfuncties afgeknot worden, voor elke lidmaatschapfunctie

% output: y:             matrix, bevat de afgeknotte lidmaatschapsgraden
%                        dimensie: m * n
                                 


n = size(dat,1);
Z=zeros(n,1);
E=ones(n,1);
for i=1:size(par,1)
    parmat = E*par(i,:);
    vector1(:,1) = (dat - parmat(:,1))./(parmat(:,2)-parmat(:,1));
    vector1(:,2) = E;
    vector1(:,3) = (dat - parmat(:,4))./(parmat(:,3)-parmat(:,4));
    vector2 = min(vector1,[],2);
    y(:,i) = min(max(vector2,Z), activatiegraad(1,i));
end    

