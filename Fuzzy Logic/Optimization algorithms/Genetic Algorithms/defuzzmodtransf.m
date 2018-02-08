function crispoutput = defuzzmodtransf(ffgrades,msfunctionsy, labeltnorm)
% This function returns the defuzzified model output given the membership
% functions and the degrees of fulfilment of the output variable of a
% Mamdani-Assilian model (the COG defuzzification is carried out according
% to the modified transformation function method).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Input: ffgrades = (sizedataset,nmembery) matrix containing the degrees
%               of fulfilment
%        msfunctionsy = (1,2*nmembery) vector containing the values
%               characterizing membership functions of the output variable
%               (boundaries of the variable are also included in the
%               vectors)
%        labeltnorm = 1|minimum / 2|product / 3|Lukasiewicz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Output: crispoutput = (sizedataset,1) matrix containing crisp model
%               output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% This functions calls the functions reshapemsf

% if no t-norm is specified the minimum is used as t-norm
if nargin < 3
    labeltnorm = 1;
else
    labeltnorm = max(min(labeltnorm,3),1);
end

% number of data points
sizedataset = size(ffgrades,1);
% number of membership functions
nmsf = size(msfunctionsy,2)/2;

% reshape the vector with the parameters of the membership functions of the
% output variable y
msfunctionsyreshaped = reshapemsf(msfunctionsy);

% Transformation of own parameters used to characterize the membership
% functions into those used by the transformation function method. The
% matrix msfunctionsytransf is a (nmsf,4) matrix. Its four columns contain
% respectively ai, bi, ci and hi.
msfunctionsytransf = zeros(nmsf,4);
tempvector = [msfunctionsyreshaped(:,1) .* msfunctionsyreshaped(:,3) ...
        - msfunctionsyreshaped(:,2) .* msfunctionsyreshaped(:,4)] ...
    ./ [msfunctionsyreshaped(:,1) - msfunctionsyreshaped(:,2) ...
        + msfunctionsyreshaped(:,3) - msfunctionsyreshaped(:,4)];
msfunctionsytransf(:,3) = tempvector;
msfunctionsytransf(:,1) = msfunctionsyreshaped(:,4) - tempvector;
msfunctionsytransf(:,2) = tempvector - msfunctionsyreshaped(:,1);
msfunctionsytransf(1,4) = [tempvector(1,1) - msfunctionsyreshaped(1,4)] ...
    / [msfunctionsyreshaped(1,3) - msfunctionsyreshaped(1,4)];
msfunctionsytransf(2:end,4) = [tempvector(2:end,1) - msfunctionsyreshaped(2:end,1)] ...
    ./ [msfunctionsyreshaped(2:end,2) - msfunctionsyreshaped(2:end,1)];

% Creating matrices containing the values of ai, ci, hi and the
% 'alfa'i-independent factors in the formula of all t-norms of the center
% of gravity and surface of the adapted membership functions. The values in
% the matrices correspond to the degrees of fulfilment in the matrix
% ffgrades.
matrixfactorcog = repmat(([msfunctionsytransf(:,1) - msfunctionsytransf(:,2)]/3)',sizedataset,1);
matrixfactorsrf = repmat(([msfunctionsytransf(:,1) + msfunctionsytransf(:,2)] ... 
    ./ [2 * msfunctionsytransf(:,4)])',sizedataset,1);
matrixai = repmat(msfunctionsytransf(:,1)',sizedataset,1);
matrixci = repmat(msfunctionsytransf(:,3)',sizedataset,1);
matrixhi = repmat(msfunctionsytransf(:,4)',sizedataset,1);

if labeltnorm < 1.5 % t-norm is minimum
    % Creating matrices containing the values of the center of gravity of
    % the overlapping regions and the 'alfa'i-independent factors in the
    % formula of the surface of the overlapping regions. vectorcogo and
    % matrixfactorsrfo are (sizedataset,(nmsf-1)) matrices.
    matrixcogo =  repmat((msfunctionsytransf(1:(end-1),1) + msfunctionsytransf(1:(end-1),3)...
        - (msfunctionsytransf(1:(end-1),1) ./ (2 * msfunctionsytransf(1:(end-1),4))))'...
        ,sizedataset,1);
    matrixfactorsrfo = repmat(-(msfunctionsytransf(1:(end-1),1) ./ ...
        msfunctionsytransf(1:(end-1),4))',sizedataset,1);  
    % Calculating center of gravity and surface of the adapted membership
    % functions. The values in the matrices correspond to the degrees of
    % fulfilment in the matrix ffgrades.
    matrixcog = matrixci + matrixfactorcog .* ...
        [(3 * matrixhi .^2 - 3 * ffgrades .* matrixhi + ffgrades .^2) ./ ...
            (2 * matrixhi .^2 - ffgrades .* matrixhi)];
    matrixsrf = matrixfactorsrf .* ...
        [ffgrades .* (2 *  matrixhi - ffgrades)];
    % Calculating surface of the overlapping regions. matrixhoi is a
    % (sizedataset,(nmsf-1)) matrix containing the heights over the
    % overlapping trapezoidal regions. matrixsrfo is a
    % (sizedataset,(nmsf-1)) matrix containing the surfaces of the
    % overlapping regions
    matrixhoi = min(min(ffgrades(:,1:(end-1)),ffgrades(:,2:end)),0.5);
    matrixsrfo = matrixfactorsrfo .* matrixhoi .* ...
        (ones(sizedataset,(nmsf-1)) - matrixhoi);
elseif labeltnorm < 2.5 %t-norm is product
    % Adapting matrices containing the values of the 'alfa'i-independent
    % factors in the formula of the t-norm product of the center of gravity
    % and surface of the adapted membership functions. The values in the
    % matrices correspond to the degrees of fulfilment in the matrix
    % ffgrades.
    matrixtermcog = repmat([(msfunctionsytransf(:,1) - msfunctionsytransf(:,2)) .* ...
            (3 * msfunctionsytransf(:,4) .^2 - 3 * msfunctionsytransf(:,4) + ones(nmsf,1)) ./...
            (6 * msfunctionsytransf(:,4) .^2 - 3 * msfunctionsytransf(:,4))]',sizedataset,1);
    matrixfactorsrf = repmat(([msfunctionsytransf(:,1) + msfunctionsytransf(:,2)] .* ... 
        [2 * msfunctionsytransf(:,4) - ones(nmsf,1)] ./ [2 * msfunctionsytransf(:,4)])',sizedataset,1);
    % Creating matrixcontaining the 'alfa'i-independent factor in the
    % formula of the surface of the overlapping regions. matrixfactorsrfo
    % is a (sizedataset,(nmsf-1)) matrix.
    matrixfactorsrfo = repmat(-(msfunctionsytransf(1:(end-1),1) ./ ...
        (2 * msfunctionsytransf(1:(end-1),4)))',sizedataset,1);
    % Calculating center of gravity and surface of the adapted membership
    % functions. The values in the matrices correspond to the degrees of
    % fulfilment in the matrix ffgrades.
    matrixcog = matrixci + matrixtermcog;
    matrixsrf = matrixfactorsrf .* ffgrades;
    % Calculating cog and surface of the overlapping regions. matrixcogo
    % and matrixsrfo  are (sizedataset,(nmsf-1)) matrices containing the
    % center of gravities and  surfaces of the overlapping regions
    matrixcogo = matrixci(:,1:(end-1)) + matrixai(:,1:(end-1)) - ...
        (matrixai(:,1:(end-1)) .* (ffgrades(:,1:(end-1)) + 2 * ffgrades(:,2:end))) ./ ...
        (3 * matrixhi(:,1:(end-1)) .* max(ffgrades(:,1:(end-1)) + ffgrades(:,2:end),1e-30));
    matrixsrfo = matrixfactorsrfo .* ffgrades(:,1:(end-1)) .* ffgrades(:,2:end) ./ ...
        max(ffgrades(:,1:(end-1)) + ffgrades(:,2:end),1e-30);
else %t-norm is Lukasiewicz t-norm
    % Creating matrixcontaining the 'alfa'i-independent factor in the
    % formula of the surface of the overlapping regions. matrixfactorsrfo
    % is a (sizedataset,(nmsf-1)) matrix.
    matrixfactorsrfo = repmat(-(msfunctionsytransf(1:(end-1),1) ./ ...
        (4 * msfunctionsytransf(1:(end-1),4)))',sizedataset,1);
    % Calculating center of gravity and surface of the adapted membership
    % functions. The values in the matrices correspond to the degrees of
    % fulfilment in the matrix ffgrades.
    matrixcog = matrixci + matrixfactorcog .* ...
        [(3 * matrixhi .^2 - 6 * matrixhi + 3 * ffgrades .* (matrixhi - ones(sizedataset,nmsf)) + ...
            ffgrades .^2 + 3 * ones(sizedataset,nmsf)) ./ ...
        (matrixhi .* max(2 * matrixhi + ffgrades - 2 * ones(sizedataset,nmsf),1e-30))];
    matrixsrf = matrixfactorsrf .* ...
        [ffgrades .* (2 *  matrixhi + ffgrades - 2 * ones(sizedataset,nmsf))];
    % Calculating cog and surface of the overlapping regions. matrixcogo
    % and matrixsrfo  are (sizedataset,(nmsf-1)) matrices containing the
    % center of gravities and  surfaces of the overlapping regions
    matrixcogo = matrixci(:,1:(end-1)) + matrixai(:,1:(end-1)) - ...
        matrixai(:,1:(end-1)) .* (ones(sizedataset,(nmsf-1)) - ffgrades(:,1:(end-1)) + ffgrades(:,2:end)) ./ ...
        (2 * matrixhi(:,1:(end-1)));
    matrixsrfo = matrixfactorsrfo .* ...
        [max(ffgrades(:,1:(end-1)) + ffgrades(:,2:end) - ones(sizedataset,(nmsf-1)),0)].^2;
end

% compute crisp output y*
crispoutput = zeros(sizedataset,1);
for i=1:sizedataset
    nom = sum(matrixsrf(i,:),2) + sum(matrixsrfo(i,:),2);
    if nom == 0 % if the fuzzy output is the empty set, the average
        % value of the output range is returned
        crispoutput(i) = (msfunctionsy(1) + msfunctionsy(end))/2;
    else
        crispoutput(i) = (matrixcog(i,:) * matrixsrf(i,:)' + matrixcogo(i,:) * matrixsrfo(i,:)') /...
            (sum(matrixsrf(i,:),2) + sum(matrixsrfo(i,:),2));
    end
end
