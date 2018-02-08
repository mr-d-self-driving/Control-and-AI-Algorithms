function [selectie] = toernooiSelectie(Populatie)
%This function performs tournament selectie
% Input:   Populatie = 	populatie van generatie t met alle uitgerekende fitnesswaarden (record met popgrootte voorkomens en velden: fitness,  genotype.x1, genotype.x2, genotype.y, fenotype.x1par, fenotype.x2par, fenotype.ypar en fenotype.R)
% Output:  selectie = vector met de indices van de geselecteerde individuen, deze vector kan dienen als ingang voor de recombinatie

sizePop = size(Populatie);
for m=1:sizePop(2)
    % suffle indices of the population
    X=randperm(sizePop(2));
    % compare first two individuals of the shuffled population
    % fitness functions should be minimalized
    % select individual with smallest fitness
    % if the fitnesses are equal select one ad random
    if (Populatie(X(1)).fitness < Populatie(X(2)).fitness)
        selectie(1,m)=X(1);
    elseif (Populatie(X(1)).fitness > Populatie(X(2)).fitness)
        selectie(1,m)=X(2);
    elseif (rand(1,1)<0.5)
        selectie(1,m)=X(1);
    else
        selectie(1,m)=X(2);
    end
end
