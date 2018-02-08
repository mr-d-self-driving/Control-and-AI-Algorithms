function y = berekenLidmaatschapsgraad(dat,par)
% y=berekenLidmaatschapsgraad(dat,par)
% berekenen van de lidmaatschapsgraden
% input: dat:            kolomvector, bevat waarden voor die variabele 
%                        waarvoor de lidmaatschapsgraad berekend wordt  
%        par:            n * 4 matrix, bevat de parameters van de N lidmaatschapsfuncties
%
% output: y:             matrix, bevat de lidmaatschapsgraden voor elk data punt
%                        dimensies: n * m


n = size(dat,1);
Z=zeros(n,1);
E=ones(n,1);
for i=1:size(par,1)
    parmat = E*par(i,:);
    vector1(:,1) = (dat - parmat(:,1))./(parmat(:,2)-parmat(:,1));
    vector1(:,2) = E;
    vector1(:,3) = (dat - parmat(:,4))./(parmat(:,3)-parmat(:,4));
    vector2 = min(vector1,[],2);
    y(:,i) = max(vector2,Z);
end    

