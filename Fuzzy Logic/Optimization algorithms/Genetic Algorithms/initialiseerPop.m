function [Population] = initialiseerPop (popsize, membersX1, membersX2, membersY, suppliedRuleBase)
% Input : popsize   = grootte van de populatie 
%         membersX1 = aantal lidmaatschapsfuncties voor ingangsvariabele X1  
%         membersX2 = aantal lidmaatschapsfuncties voor ingangsvariabele X2
%         membersY  = aantal lidmaatschapsfuncties voor de uitgangsvariabele Y
%         suppliedRuleBase = door de gebruiker opgegeven regelbank
% Output: Populatie = gecodeerde random populatie (record met popgrootte voorkomens en velden: fitness,  genotype.x1, genotype.x2, genotype.y, fenotype.x1par, fenotype.x2par, fenotype.ypar en fenotype.R)

for m=1:popsize
    fprintf('.')
% assigning random value for the fitness
    Population(m).fitness=rand(1,1);
% assigning random strings for the membershipfunctions
% crtbp(number_of_strings,length_of_strings)
    Population(m).genotype.x1=floor(2*rand(1,membersX1*7));
    Population(m).genotype.x2=floor(2*rand(1,membersX2*7));
    Population(m).genotype.y=floor(2*rand(1,membersY*7));
% assigning (membersX1,membersX2) matrix containing 
% rule base supplied by user
    Population(m).fenotype.R=suppliedRuleBase;
end
