function y = lmgraad(dat,par,activatiegraad)
% y=lmgraad(dat,par,activatiegraad)
% berekenen van de lidmaatschapsgraden
% input: dat:            kolomvector of getal, bevat waarden voor die variabele 
%                        waarvoor de lidmaatschapsgraad berekend wordt  
%        par:            matrix die de parameters van de lidmaatschapsfuncties bevat
%        activatiegraad: de de hoogte waarop de consequent lidmaatschapsfuncties afgeknot worden
%                        indien de lidmaatschapsgraden voor de ingangsvariabelen bepaald worden, 
%                        dient de activatiegraad niet meegegeven.
% output: y:             matrix of rijvector, bevat de lidmaatschapsgraden
%                        dimensies: size(dat,1) * size(par,1)
%                                   of: 1 * size(par,1)
n = size(dat,1);
Z=zeros(n,1);
E=ones(n,1);
if nargin > 2
    for i=1:size(par,1)
        parmat = E*par(i,:);
        activatiemat = E*activatiegraad(1,i);
        vector1(:,1) = (dat - parmat(:,1))./(parmat(:,2)-parmat(:,1));
        vector1(:,2) = activatiemat;
        vector1(:,3) = (dat - parmat(:,4))./(parmat(:,3)-parmat(:,4));
        vector2 = min(vector1,[],2);
        y(:,i) = max(vector2,Z);
    end    
    
else
    
    for i=1:size(par,1)
        parmat = E*par(i,:);
        vector1(:,1) = (dat - parmat(:,1))./(parmat(:,2)-parmat(:,1));
        vector1(:,2) = E;
        vector1(:,3) = (dat - parmat(:,4))./(parmat(:,3)-parmat(:,4));
        vector2 = min(vector1,[],2);
        y(:,i) = max(vector2,Z);
    end    
end
