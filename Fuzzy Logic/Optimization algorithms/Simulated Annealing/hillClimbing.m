function [ParVM,iteratieRMSE]=hillClimbing(xIn,yIn,ParVM,omgeving)
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
%Output:    
%      ParVM            structure, bevat de geoptimaliseerde regelbank parameters van het 
%                       Mamdani-Assilian model
%      iteratieRMSE     vector van RMSE-waarden per iteratiestap  

% preallocatie van variabelen
aantalx1=size(ParVM.x1par,2)-2; % aantal lidmaatschapsfuncties x1
aantalx2=size(ParVM.x2par,2)-2; % aantal lidmaatschapsfuncties x2
aantaly=size(ParVM.ypar,2)-2; % aantal lidmaatschapsfuncties y
aantalregels = aantalx1*aantalx2; % aantal regels
sizeDataset = size(xIn,1); % grootte van de dataset

% initialiseer randomRegelbank
randomRegelbank  = zeros(aantalx1,aantalx2);
for j=1:aantalregels
    randomRegelbank(j)=randi(aantaly);
end
besteRegelbank = randomRegelbank;
ParVM.R = besteRegelbank;
modelOutput=vaagmodel(xIn,ParVM);
bestRMSE = sqrt(sum((yIn-modelOutput).^2)/(sizeDataset)); % voorlopig beste RMSE
% initialiseer overige variabelen
iter =1;
lokaal = false; % optimum is nog niet gevonden
while lokaal == false % zolang het optimum nog niet gevonden is, zoek het optimum
    lokaal = true;
    for i = 1:aantalx1
        for j = 1:aantalx2
        % zoek de omgeving van RandomRegelbank af
        for k=omgeving
            nieuweRegelbank = randomRegelbank;
            nieuweRegelbank(i,j) = nieuweRegelbank(i,j)+k;
                if min(min(nieuweRegelbank <= aantaly)) == 1 &  min(min(nieuweRegelbank > 0))==1
                    ParVM.R=nieuweRegelbank;
                    modelOutput=vaagmodel(xIn,ParVM); % bereken de modeloutput
                    newRMSE = sqrt(sum((yIn-modelOutput).^2)/(sizeDataset));
                        % Vergelijk met de BesteRegelbank
                        if (newRMSE-bestRMSE < 0)
                            besteRegelbank = nieuweRegelbank;
                            bestRMSE = newRMSE;
                            lokaal = false;
                        end
                end
        end
    end
    randomRegelbank= besteRegelbank;
    iteratieRMSE(iter)=bestRMSE;
    iter = iter+1;
end
ParVM.R=besteRegelbank;
end
