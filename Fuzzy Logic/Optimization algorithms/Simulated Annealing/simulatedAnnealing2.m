function [ParVM,iteratieRMSE]=simulatedAnnealing(xIn,yIn,ParVM,omgeving,ParSA)
% input:    
%      xIn     matrix, datapunten voor ingangsvariabelen X1 en X2 
%      yIn     vector, datapunten voor de uitgangsvariabele Y
%      ParVM   structure, bevat de parameters van het Mamdani-Assilian
%      model:
%          ParVM.x1par      vector, parameters die de lidmaatschapsfuncties van de
%                           ingangsvariabele X1 karakteriseren
%          ParVM.x2par      vector,parameters die de lidmaatschapsfuncties van de
%                           ingangsvariabele X2 karakteriseren
%          ParVM.ypar       vector,parameters die de lidmaatschapsfuncties van
%                           de  uitgangsvariabele Y karakteriseren
%          ParVM.R          matrix, bevat de regelbank
%     omgeving  vector van integers, beschrijft de grootte van de omgeving
%               (bv. [ -2 -1 1 2])
%      ParSA   structure, parameterinstellingen voor simulated
%              annealing
%          ParSA.Tmax      integer, maximumtemperatuur
%          ParSA.Tmin      real, minimumtemperatuur
%          ParSA.r         real, koelsnelheid
%          ParSA.kT        integer, aantal iteraties
%Output:    
%      ParVM            structure, bevat de geoptimaliseerde regelbank parameters van het 
%                       Mamdani-Assilian model
%      iteratieRMSE     vector van RMSE-waarden per iteratiestap  

% omgeving     vector die de omgeving beschrijft (bv. [ -2 -1 1 2]
% preallocatie van variabelen
aantalx1=size(ParVM.x1par,2)-2; % aantal lidmaatschapsfuncties x1
aantalx2=size(ParVM.x2par,2)-2; % aantal lidmaatschapsfuncties x2
aantaly=size(ParVM.ypar,2)-2; % aantal lidmaatschapsfuncties y
aantalregels = aantalx1*aantalx2; % aantal regels
sizeDataset = size(xIn,1); % grootte van de dataset

% initialiseer besteRegelbank
besteRegelbank  = zeros(aantalx1,aantalx2);
for k=1:aantalregels
    besteRegelbank(k)=randi(aantaly);
end %Random rule base created
ParVM.R = besteRegelbank;
modelOutput=vaagmodel(xIn,ParVM);
bestRMSE = sqrt(sum((yIn-modelOutput).^2)/(sizeDataset)); % for now this is the best RMSE
% initialiseer overige variabelen 
T = ParSA.Tmax;
t=1;

%%%%%%%%%%%%%%%%%%%%%%%%
% Simulated Annealing  %
%%%%%%%%%%%%%%%%%%%%%%%%
while T > ParSA.Tmin
    for i=1:ParSA.kT
	% implementeer hier de keuze van een punt uit de omgeving van de regelbank
        for i = 1:aantalx1
            for j = 1:aantalx2
            % zoek de omgeving van RandomRegelbank af
                for k=omgeving
                    nieuweRegelbank = randomRegelbank;
                    nieuweRegelbank(i,j) = nieuweRegelbank(i,j)+k;
                        if min(min(nieuweRegelbank <= aantaly)) == 1 &  min(min(nieuweRegelbank > 0))==1
                            ParVM.R=nieuweRegelbank;
                            modelOutput=vaagmodel(xIn,ParVM);
                            newRMSE = sqrt(sum((yIn-modelOutput).^2)/(sizeDataset));
                            % comparing NewRuleBase with BestRuleBase
                            if (newRMSE-bestRMSE <= 0)
                                besteRegelbank = nieuweRegelbank;
                                bestRMSE = newRMSE;
                            elseif (exp(-(newRMSE-bestRMSE)/T)>rand(1))
                                besteRegelbank = nieuweRegelbank;
                                bestRMSE=newRMSE;
                            end
                        end
                end
            end
        end
    iteratieRMSE(t) = bestRMSE;
    t = t+1;
    end
T = T*ParSA.r;
end
ParVM.R=besteRegelbank;
