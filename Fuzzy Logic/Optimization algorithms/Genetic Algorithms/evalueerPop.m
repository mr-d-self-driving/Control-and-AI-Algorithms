function [Populatie] = evalueerPop(Populatie,xIn,yIn, decodering,epsilon,ParVM, suppliedinput)
% Input:   Populatie	populatie van generatie t waarvan de fitnesswaarden worden uitgerekend (record met popgrootte voorkomens en velden: fitness,  genotype.x1, genotype.x2, genotype.y, fenotype.x1par, fenotype.x2par, fenotype.ypar en fenotype.R)
%          xIn     	datapunten voor ingangsvariabelen X1 en X2
%          yIn     	datapunten voor de uitgangsvariabele Y
%	   decodering 	structure, bevat de parameters voor het encoderen van de lidmaatschapsfuncties, bevat de volgende elementen:
%          FieldD1  	coderingsmatrix voor ingangsvariabele X1
%          FieldD2  	coderingsmatrix voor ingangsvariabele X2
%          FieldD3  	coderingsmatrix voor uitgangsvariabele Y
%          epsilon  	gewenste minimum afstand tussen de toppen van twee naburige lidmaatschapsfuncties
%          ParVM   	structure bevat de parameters voor het Mamdani-Assilian model
%          suppliedinput  vector die aangeeft welke parameters van het vaag model opgegeven werden door de gebruiker
% Output: Populatie  	populatie van generatie t waarvan de fitnesswaarden werden toegekend (record met popgrootte voorkomens en velden: fitness,  genotype.x1, genotype.x2, genotype.y, fenotype.x1par, fenotype.x2par, fenotype.ypar en fenotype.R)

popsize = size(Populatie);

for m=1:popsize(2)
    SSE(m) = 0;
    rmse(m) =0;
    fprintf('.')
    % Decoding of the chromosoms from binary to real values
    % If real values are supplied by the user, the
    % user supplied values are assigned.
    % Followed by a sort of the real values from
    % small to large so they can be used as input
    % of the function vaagmodel. 
    % Finally it is checked if the values differ
    % enough (more than epsilon) from each other
    % if this is not the case a very high fitness
    % is assigned to this fuzzy model.
    
    % Membershipfunctions of the input variable x1
    if suppliedinput(1)==1
        Populatie(m).fenotype.x1par=ParVM.x1par;
    else
        realsX1 = sort(round(bs2rv(Populatie(m).genotype.x1,decodering.FieldD1)));
        Populatie(m).fenotype.x1par=[0 realsX1 100];
        for i=1:size(realsX1,2)-1
            if (realsX1(i+1)-realsX1(i)<epsilon)
                Populatie(m).fitness=1e20;     
                break
            end
        end
    end
    
    % Membershipfunctions of the input variable x2
    if suppliedinput(2)==1
        Populatie(m).fenotype.x2par=ParVM.x2par;
    else
        realsX2 = sort(round(bs2rv(Populatie(m).genotype.x2,decodering.FieldD2)));
        Populatie(m).fenotype.x2par=[0 realsX2 100];
        for i=1:size(realsX2,2)-1
            if (realsX2(i+1)-realsX2(i)<epsilon)
                Populatie(m).fitness=1e20;     
                break
            end
        end
    end
    
    % Membershipfunctions of the output variable y 
    if suppliedinput(3)==1
        Populatie(m).fenotype.ypar=ParVM.ypar;
    else
        realsY = sort(round(bs2rv(Populatie(m).genotype.y,decodering.FieldD3)));
        Populatie(m).fenotype.ypar=[0 realsY 100];
        for i=1:size(realsY,2)-1
            if (realsY(i+1)-realsY(i)<epsilon)
                Populatie(m).fitness=1e20;       
                break
            end
        end    
    end


    % Evaluation of the fuzzy model (= assigning fitness)    
    if (Populatie(m).fitness<1e19)
        vaagResult = vaagmodel(xIn,Populatie(m).fenotype);
        SSE(m) = sum((yIn-vaagResult).^2);   
        rmse(m) = sqrt(SSE(m)/size(xIn,1));
        Populatie(m).fitness=rmse(m);
    end
    
end
