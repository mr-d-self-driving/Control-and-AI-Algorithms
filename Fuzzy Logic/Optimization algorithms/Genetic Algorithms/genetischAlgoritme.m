function [ParVM,iteratieRMSE]=genetischAlgoritme(xIn,yIn,ParVM,ParGA,D)
% functie die een genetisch algoritme uitvoert op het Mamdani-Assilian
% model
%input  xIn      matrix, datapunten voor ingangsvariabelen X1 en X2 
%       yIn      vector, datapunten voor de uitgangsvariabele Y
%       ParVM    structure, bevat de parameters van het Mamdani-Assilian
%       model:
%          ParVM.x1par      vector, parameters die de lidmaatschapsfuncties van de
%                           ingangsvariabele X1 karakteriseren
%          ParVM.x2par      vector,parameters die de lidmaatschapsfuncties van de
%                           ingangsvariabele X2 karakteriseren
%          ParVM.ypar       vector,parameters die de lidmaatschapsfuncties van
%                           de  uitgangsvariabele Y karakteriseren
%          ParVM.R          matrix, bevat de regelbank
%          ParVM.membersX1  integer, aantal lidmaatschapsfuncties van de
%                           eerste ingangsvariabele
%          ParVM.membersX2  integer, aantal lidmaatschapsfuncties van de
%                           tweede ingangsvariabele
%          ParVM.membersY   integer, aantal lidmaatschapsfuncties van de
%                           uitgangsvariabele
%      ParGA  structure, parameterinstellingen voor het genetisch algoritme:
%           ParGA.maxgen            maximum aantal generaties
%           ParGA.pop               populatiegrootte
%           ParGA.pcross            kruisingsprobabiliteit
%           ParGA.pmut              mutatieprobabiliteit
%	D	vector, bevat de parameters voor de decodering van het genotype naar fenotype
%Output:    
%           ParVM           structure, bevat de geoptimaliseerde parameters van het Mamdani-Assilian model
%           iteratieRMSE    vector van de beste RMSE-waarden per iteratiestap


% initialiseer variabelen
% minimale afstand tussen de top van twee aanpalende lidmaatschapsfuncties
% (epsilon >=1)
epsilon =1;
% supplied input: geeft mee welke parameters opgegeven werde, welke niet
suppliedinput = [size(ParVM.x1par,2)==(ParVM.membersX1+2) size(ParVM.x2par,2)==(ParVM.membersX2+2) ...
    size(ParVM.ypar,2)==(ParVM.membersY+2) ...
    and(size(ParVM.R,1)==ParVM.membersX1,size(ParVM.R,2)==ParVM.membersX2)];
%ga na of de regelbank werd meegegeven
test = suppliedinput(4);
if (test < 1) fprintf('Geen regelbank ingegeven.\n'); 
    return; 
end 
% initialiseer decoderingsstructure
decodering.FieldD1=repmat(D,1,ParVM.membersX1);
decodering.FieldD2=repmat(D,1,ParVM.membersX2);
decodering.FieldD3=repmat(D,1,ParVM.membersY);
% initialiseer populatie
fprintf('Initialiseren van populatie\n')
Population = initialiseerPop(ParGA.pop,ParVM.membersX1,ParVM.membersX2,ParVM.membersY,ParVM.R);

% evalueer de initiële populatie
fprintf('Evaluatie\n')
[Population] = evalueerPop(Population,xIn,yIn, decodering,epsilon,ParVM,suppliedinput);
[fBest,positieBest] = min([Population(:).fitness]);
iteratieRMSE(1) = fBest;
% selecteer het beste individue
bestPop = Population(positieBest);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Start Genetisch Algoritme                %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%main loop
for gen=1:ParGA.maxgen
    
    fprintf('\nGeneration no. : %d\n',gen);
    %selection based on stochastic universal sampling
    Selection = toernooiSelectie(Population);
    
    % recombination with probability pcross
    % mutation with probability pmut
    NewPopulation = recombineerPop(Population,Selection, ParGA);
    % elitisme: always keep the best individual of the previous population
    NewPopulation(1)=bestPop;
    Population = NewPopulation;
    
    %decoding the population   
    fprintf('Evaluatie\n')
    [Population] = evalueerPop(Population,xIn,yIn,decodering, epsilon,ParVM, suppliedinput);
    
    % Searching the best fitness value (minimalization of the fitness) 
    [fBest,positieBest] = min([Population(:).fitness]);
    iteratieRMSE(gen+1) = fBest;
    % selecteer het beste individue
    bestPop = Population(positieBest);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Writing results to the screen                 %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (membersX1 + 2) real values characterizing membershipfunctions 
% of inputvariable x1 (boundaries are also included in the vector)
if suppliedinput(1)==0
    realsX1 = sort(round(bs2rv(bestPop.genotype.x1,decodering.FieldD1)));
    ParVM.x1par=[0 realsX1 100];
end

% (membersX2 + 2) real values characterizing membershipfunctions 
% of inputvariable x2 (boundaries are also included in the vector)
if suppliedinput(2)==0
    realsX2 = sort(round(bs2rv(bestPop.genotype.x2,decodering.FieldD2)));
    ParVM.x2par=[0 realsX2 100];
end

% (membersY + 2) real values characterizing membershipfunctions 
% of inputvariable y (boundaries are also included in the vector)
if suppliedinput(3)==0
    realsY = sort(round(bs2rv(bestPop.genotype.y,decodering.FieldD3)));
    ParVM.ypar=[0 realsY 100];   
end
