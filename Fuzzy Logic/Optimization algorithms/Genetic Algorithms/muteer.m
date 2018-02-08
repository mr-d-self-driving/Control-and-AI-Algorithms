function [A] = muteer (A, pmut)
% Input:   A   	gegevens van het te muteren individu (record met 1 voorkomen en velden: genotype.x1, genotype.x2, genotype.y, fenotype.x1par, fenotype.x2par, fenotype.ypar en fenotype.R)
%          pmut mutatieprobabiliteit
% Output:  A    gegevens van het gemuteerde individu  (record met 1 voorkomen en velden: genotype.x1, genotype.x2, genotype.y, fenotype.x1par, fenotype.x2par, fenotype.ypar en fenotype.R)

% determining the size of the chromosome A
sizeX1 = length(A.genotype.x1);
sizeX2 = length(A.genotype.x2);
sizeY = length(A.genotype.y);

% mutating x1
for m=1:sizeX1
    if (rand(1,1)<pmut)
        if (A.genotype.x1(m)==1)
            A.genotype.x1(m)=0;
        else
            A.genotype.x1(m)=1;
        end
    end
end

% mutating x2
for m=1:sizeX2
    if (rand(1,1)<pmut)
        if (A.genotype.x2(m)==1)
            A.genotype.x2(m)=0;
        else
            A.genotype.x2(m)=1;
        end
    end
end

% mutating y
for m=1:sizeY
    if (rand(1,1)<pmut)
        if (A.genotype.y(m)==1)
            A.genotype.y(m)=0;
        else
            A.genotype.y(m)=1;
        end
    end
end

% assigning the fitness
A.fitness=0;
