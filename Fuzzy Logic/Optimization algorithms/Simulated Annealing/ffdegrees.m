function ffgrades = ffdegrees(msfunctionsx, nmembery, rulebase, inputdata, labeltnorm)
% This function returns the degrees of fulfilment of all membership
% functions of the outputvariable of a fuzzy model given the membership
% functions and values of the input variables and the rule base.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Input: msfunctionsx = cellarray with the vectors containing the values
%               characterizing membership functions of the input variables
%               (boundaries of the variables are also included in the
%               vectors)
%        nmembery = number of membership functions of the output variable
%        rulebase = matrix with rule base of the fuzzy model
%        inputdata = (sizedataset,*) matrix containing the input values
%               of a dataset
%        labeltnorm = 1|minimum / 2|product / 3|Lukasiewicz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Output: ffgrades = (sizedataset,nmembery) matrix containing the degrees
%               of fulfilment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% This functions calls the functions: msgrade and reshapemsf.

% if no t-norm is specified the minimum is used as t-norm
if nargin < 5
    labeltnorm = 1;
else
    labeltnorm = max(min(labeltnorm,3),1);
end

% number of input variables
ninputvar = length(msfunctionsx);
% number of data points
sizedataset = size(inputdata,1);
avoiddivbyzero = 5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate membership grades of the input values           %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% reshape the vectors with the parameters of the membershipfunctions before
% the calculation of the membership grades of the input values to the
% membership functions of the input variables
for i=1:ninputvar % for each input variable
    % assign the vector with the parameters characterizing the membership
    % functions of the ith input variable
    msfvector = msfunctionsx{i};
    % nmemberxs contains the number of membership functions of the input
    % variables
    nmemberxs(i) = length(msfvector)/2;
    % msfmatrix is a matrix of which each row contains the 4 parameters
    % describing the trapezoidal membership functions 
    msfmatrix = reshapemsf(msfvector);
    % the first parameter of the first membership function is decreased by
    % avoiddivbyzero to avoid division by zero when the slope of the left
    % line of the membership function is calculated
    msfmatrix(1,1) = msfmatrix(1,1) - avoiddivbyzero;
    % the last parameter of the last membership function is increased by
    % avoiddivbyzero to avoid division by zero when the slope of the right
    % line of the membership function is calculated
    msfmatrix(end,end) = msfmatrix(end,end) + avoiddivbyzero;
    % msgmatrix is a (sizedataset,nmemberxs(i)) matrix containing the
    % membership degrees of the input data values to the nmemberxs(i)
    % membership functions of the ith input variable
    msgmatrix = msgrade(inputdata(:,i),msfmatrix);
    % assign msgmatrix to the cell array msgmatrices
    msgmatrices(1,i) = {msgmatrix};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculation of the degree of fulfilment of the rules      %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% As the rule base is complete, the number of rules is equal to the product
% of the numbers of membership functions of input variables
nrules = prod(nmemberxs);

% The degree of fulfilment of a rule is computed as the minimum of the
% membership degrees of the input value to the different membership
% functions in the antecedent of the rule. 

% The implementation if the calculation of the degrees of fulfilment  is
% very compact and may look quite complex at first sight. Anyway, I will
% try to make everything clear to you. 

% To calculate the degree of fulfilment of the nrules rules at a low
% computational cost a (sizedataset,nrules) matrix, called gradesexpanded,
% is used. The i th row of gradesexpanded corresponds to the ith data point
% in the data set. The jth column of gradesexpanded corresponds to the rule
% with the jth index in the matrix rulebase. There are two ways to refer to
% cells in N-dimensional matrices: by one index or by a set of N indices.
% Matlab assigns 1-dimensional indices to the cells of N-dim-matrices by
% assigning index 1 to the cell A(1,1,1, ...,1) and then continuing running
% through each dimension (= column by column for a 2-dimensional matrix).
% The way to assign indices is illustrated by an example of a 3-dim matrix
% A (size A = [2 4 3]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A(1) = A(1,1,1)
% A(2) = A(2,1,1)
% A(3) = A(1,2,1)
% A(4) = A(2,2,1)
% A(5) = A(1,3,1)
% A(6) = A(2,3,1)
% A(7) = A(1,4,1)
% A(8) = A(2,4,1)
% A(9) = A(1,1,2)
% A(10) = A(2,1,2)
% A(11) = A(1,2,2)
% A(12) = A(2,2,2)
% A(13) = A(1,3,2)
% A(14) = A(2,3,2)
% A(15) = A(1,4,2)
% A(16) = A(2,4,2)
% A(17) = A(1,1,3)
% A(18) = A(2,1,3)
% A(19) = A(1,2,3)
% A(20) = A(2,2,3)
% A(21) = A(1,3,3)
% A(22) = A(2,3,3)
% A(23) = A(1,4,3)
% A(24) = A(2,4,3)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For the 3-dim matrix A in the example above a (3,24) matrix, called B,
% can be formed. The values B(:,i) are the values of the 3-dim indices that
% correspond to the 1-dim index with value i. One can see that the first
% row of B consists of 12 (= 4*3, the product of the maximum index of the
% higher dimensions) copies of the vector [1 2]. The second row consists of
% 3 (maximum index of the third dimension) copies of the vector [1 1 2 2 3
% 3 4 4]. The vector [1 1 2 2 3 3 4 4] originates for the vector [1 2 3 4]
% by duplicating each element of the original vector twice (maximum index
% of the first dimension). The third row consists of one vector originating
% form the vector [1 2 3] of which each element is duplicated 8 (= 2*4,
% product of the maximum index of the lower dimensions) times.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% B = [ 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2;
%       1 1 2 2 3 3 4 4 1 1 2 2 3 3 4 4 1 1 2 2 3 3 4 4;
%       1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Lets consider a fuzzy model with three input variables, with
% respectively 2, 4 and 3 linguistic values. The cell array msgmatrices
% contains 3 matrices with the membership functions of the sizedataset
% input values to the membership functions of the three input variables:
% msgmatrices{1,1} is a (sizedataset,2) matrix, msgmatrices{1,2} is a
% (sizedataset,4) matrix and msgmatrices{1,3} is a (sizedataset,3) matrix.
% At the end of the computations the first column of gradesexpanded should
% contain the degree of fulfilment of the first rule (= rulebase(1) =
% rulebase(1,1,1) for all data points which is the minimum of the first
% columns of the matrices msgmatrices{1,1}, msgmatrices{1,2} and
% msgmatrices{1,3}. The fourteenth column for example should at the end
% contain the degree of fulfilment of the fourteenth rule (= rulebase(14) =
% rulebase(2,3,2) for all data points which is the minimum of the second
% columns of the matrix msgmatrices{1,1}, the third column of the matrix
% msgmatrices{1,2} and the second column of the matrix msgmatrices{1,3}. In
% case of a fuzzy model with 3 input variables, gradesexpanded is
% calculated in 3 steps. In the first step, the matrix gradesexpanded
% consists of 12 (=4*3) copies of the vector msgmatrices{1,1}. In the
% second step a temporary (sizedataset,24) matrix is made containing 3
% copies of a vector originating from msgmatrices{1,2} (see explanation
% above matrix B). The matrix gradesexpanded is replaced by the minimum of
% the actual gradesexpanded and the temporary matrix. In the third step a
% temporary (sizedataset,24) matrix is made originating from
% msgmatrices{1,3}. The final matrix gradesexpanded is the minimum of the
% matrix gradesexpanded obtained in step two and the temporary matrix
% constructed in step three.


% for the first variable assign membership: degrees to the membership
% functions of the variable to grades ((sizedataset,nmemberxs(1)) matrix)
grades = msgmatrices{1,1};
% the matrix grades will be copied nafter times
nafter = prod(nmemberxs(2:end));
% gradesexpanded is a (sizedataset,nrules) matrix
gradesexpanded = repmat(grades,1,nafter);

% for the second to the second last variable
for i=2:(ninputvar-1)
    % assign membership degrees to the membership functions of the variable
    % to grades ((sizedataset,nmemberxs(i)) matrix)
    grades = msgmatrices{1,i};
    % the columns in grades will be duplicated nbefore times
    nbefore = prod(nmemberxs(1:(i-1)));
    % n is the number of membership functions of the variable
    n = nmemberxs(i);
    % the matrix with duplicated columns will be copied nafter times
    nafter = prod(nmemberxs((i+1):end));
    % vector needed to carry out the duplication of the columns
    vector = reshape([repmat([ones(1,nbefore) zeros(1,n*nbefore)],1,(n - 1)) ones(1,nbefore)],(n*nbefore),n);
    vector = vector';
    % grades*vector is the matrix with duplicated columns, matrix is a
    % (sizedataset,nrules) matrix
    matrix = repmat(grades * vector,1,nafter);
    % gradesexpanded is a (sizedataset,nrules) matrix
    if labeltnorm < 1.5 % t-norm is minimum
        gradesexpanded = min(gradesexpanded,matrix);
    elseif labeltnorm < 2.5 % t-norm is product
        gradesexpanded = gradesexpanded .* matrix ;
    else % t-norm is Lukasiewicz t-norm
        gradesexpanded = max(gradesexpanded + matrix - ones(sizedataset,nrules),0);
    end
end

% for the last variable if there is more than one input variable
if ninputvar > 1
    % assign membership degrees to the membership functions of the variable
    % to grades ((sizedataset,nmemberxs(end)) matrix)
    grades = msgmatrices{1,ninputvar};
    % the columns in grades will be duplicated nbefore times
    nbefore = prod(nmemberxs(1:(end-1)));
    % n is the number of membership functions of the variable
    n = nmemberxs(end);
    % vector needed to carry out the duplication of the columns
    vector = reshape([repmat([ones(1,nbefore) zeros(1,n*nbefore)],1,(n - 1)) ones(1,nbefore)],(n*nbefore),n);
    vector = vector';
    % grades*vector is the matrix with duplicated columns, matrix is a
    % (sizedataset,nrules) matrix
    matrix = grades * vector;
    % gradesexpanded is a (sizedataset,nrules) matrix
    if labeltnorm < 1.5 % t-norm is minimum
        gradesexpanded = min(gradesexpanded,matrix);
    elseif labeltnorm < 2.5 % t-norm is product
        gradesexpanded = gradesexpanded .* matrix ;
    else % t-norm is Lukasiewicz t-norm
        gradesexpanded = max(gradesexpanded + matrix - ones(sizedataset,nrules),0);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculation of the degree of fulfilment of the            %%% 
%%% linguistic values of the output variable                  %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ffgrades contains the degrees of fulfilment of the linguistic values of
% the output variable   
ffgrades = zeros(sizedataset,nmembery);
% initialize tempmatrix
tempmatrix = zeros(sizedataset,1);
for i=1:nmembery % for each linguistic value of the output variable
    % k contains the columns in gradesexpanded that correspond to rules
    % with the ith linguistic value of the output variable in their
    % consequent
    k=find(rulebase==i);
    if (size(k,1) > 0)
        for j=1:size(k,1) % for each rule
            % add column of gradesexpanded to tempmatrix
            tempmatrix = [tempmatrix gradesexpanded(:,k(j))];
        end
        % the degree of fulfilment of a linguistic value is the maximum
        % degree of fulfilment of all the rules with this linguistic value
        % in their consequent
        ffgrades(:,i)= max(tempmatrix,[],2);
        % reset tempmatrix
        tempmatrix = zeros(sizedataset,1);
    end
end