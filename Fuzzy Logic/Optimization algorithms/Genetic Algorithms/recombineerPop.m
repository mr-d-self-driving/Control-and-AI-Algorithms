function [newPop] = recombineerPop(Populatie, Selectie, ParGA)
% Input: Populatie	populatie van generatie t(record met popgrootte voorkomens en velden: fitness, genotype.x1, genotype.x2, genotype.y, fenotype.x1par, fenotype.x2par, fenotype.ypar en fenotype.R)
%	 Selectie 	vector met de indices van de geselecteerde individuen 
%	 ParGA  	structure, bevat de parameters van het genetisch algoritme 
% Output newPop & nieuwe populatie voor generatie t+1 (record met popgrootte voorkomens en velden:  fitness, genotype.x1, genotype.x2, genotype.y, fenotype.x1par, fenotype.x2par, fenotype.ypar en fenotype.R)

newPop= struct('fitness',[],'genotype',struct('x1',[],'x2',[],'y',[]'),...
    'fenotype',struct('x1par',[],'x2par',[],'ypar',[],'R',[]));
%recombination procedure
for m=1:2:ParGA.pop
    if (rand(1,1)<ParGA.pcross)
        children=kruis(Populatie(Selectie(m)),Populatie(Selectie(m+1)));
        A = muteer(children(1),ParGA.pmut);
        newPop(m).fitness = A.fitness;
        newPop(m).genotype.x1 = A.genotype.x1;
        newPop(m).genotype.x2 = A.genotype.x2;
        newPop(m).genotype.y=A.genotype.y;
        newPop(m).fenotype.R=A.fenotype.R;
        A = muteer(children(2),ParGA.pmut);
        newPop(m+1).fitness = A.fitness;
        newPop(m+1).genotype.x1 = A.genotype.x1;
        newPop(m+1).genotype.x2 = A.genotype.x2;
        newPop(m+1).genotype.y=A.genotype.y;
        newPop(m+1).fenotype.R=A.fenotype.R;
    else
        A = muteer(Populatie(Selectie(m)),ParGA.pmut);
        newPop(m).fitness = A.fitness;
        newPop(m).genotype.x1 = A.genotype.x1;
        newPop(m).genotype.x2 = A.genotype.x2;
        newPop(m).genotype.y=A.genotype.y;
        newPop(m).fenotype.R=A.fenotype.R;
        A = muteer(Populatie(Selectie(m+1)),ParGA.pmut);
        newPop(m+1).fitness = A.fitness;
        newPop(m+1).genotype.x1 = A.genotype.x1;
        newPop(m+1).genotype.x2 = A.genotype.x2;
        newPop(m+1).genotype.y=A.genotype.y;
        newPop(m+1).fenotype.R=A.fenotype.R;
    end
end
