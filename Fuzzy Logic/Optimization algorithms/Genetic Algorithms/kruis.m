function [Children]= kruis(A,B)
%Input 	A 	gegevens van de eerste ouder (record met 1 voorkomen en velden: fitness, genotype.x1, genotype.x2, genotype.y, fenotype.x1par, fenotype.x2par, fenotype.ypar en fenotype.R) 
% 	B 	gegevens van de tweede ouder (record met 1 voorkomen en velden: fitness, genotype.x1, genotype.x2, genotype.y, fenotype.x1par, fenotype.x2par, fenotype.ypar en fenotype.R) 
%Output Children 	gegevens van de kinderen bekomen na kruising (record met 2 voorkomens en velden: fitness, genotype.x1, genotype.x2, genotype.y, fenotype.x1par, fenotype.x2par, fenotype.ypar en fenotype.R) 

Children(1).fitness=0;
Children(2).fitness=0;
%determining the size of the parents
sizeX1 = size(A.genotype.x1);
sizeX2 = size(A.genotype.x2);
sizeY = size(A.genotype.y);

%creating the mask for uniform crossover
Mask.x1 = floor(2*rand(sizeX1(1),sizeX1(2)));
Mask.x2 = floor(2*rand(sizeX2(1),sizeX2(2)));
Mask.y = floor(2*rand(sizeY(1),sizeY(2)));

%performing crossover for first offspring;
Children(1).genotype.x1=(A.genotype.x1).*Mask.x1+(B.genotype.x1).*(1-Mask.x1);
Children(1).genotype.x2=(A.genotype.x2).*Mask.x2+(B.genotype.x2).*(1-Mask.x2);
Children(1).genotype.y=(A.genotype.y).*Mask.y+(B.genotype.y).*(1-Mask.y);
%Children(1).x1 = XOR(B.x1, Mask.x1);
%Children(1).x2 = XOR(B.x2, Mask.x2);
%Children(1).y  = XOR(B.y, Mask.y);

%performing crossover for second offspring;
Children(2).genotype.x1=(B.genotype.x1).*Mask.x1+(A.genotype.x1).*(1-Mask.x1);
Children(2).genotype.x2=(B.genotype.x2).*Mask.x2+(A.genotype.x2).*(1-Mask.x2);
Children(2).genotype.y=(B.genotype.y).*Mask.y+(A.genotype.y).*(1-Mask.y);
%Children(2).x1 = XOR(A.x1, Mask.x1);
%Children(2).x2 = XOR(A.x2, Mask.x2);
%Children(2).y  = XOR(A.y, Mask.y);

% assigning rulebase and fitness to the children
Children(1).fenotype.R=A.fenotype.R;

Children(2).fenotype.R=B.fenotype.R;
