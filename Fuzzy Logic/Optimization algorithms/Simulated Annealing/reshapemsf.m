function msfmatrix = reshapemsf(msfvector)
% This function returns a matrix of which each row contains the 4
% parameters describing a trapezoidal membership functions given a vector
% with the parameters of all linguistic values of a variable. In the matrix
% msfmatrix the first resp. fourth column contains the left resp. right
% edge of the base of the trapezoidal membership function (with membership
% degrees of 0). The second resp. third column contains the left resp.
% right edge of the top line of the trapezoidal membershipfunction.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Input: msfvector = 2n vector containing the parameters of the n
%           trapezoidal membership functions of a variable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Output: msfmatrix = (n,4) matrix containing the parameters of the n
%           trapezoidal membership functions of a variable
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% This function calls no user defined functions.

% number of membership functions of the variable
nmsf = length(msfvector)/2;

% the first membership function has a vertical line at the left side,
% therefore the first and second parameter value are equal
msfmatrix(1,1) = msfvector(1);
msfmatrix(1,2:4) = msfvector(1:3);
% second to second-last membership function
for i=2:(nmsf-1)
        msfmatrix(i,1:4)=msfvector((2*i-2):(2*i+1));
end
% last membership function has a vertical line at the right side, therefore
% the third and fourth parameter value are equal
msfmatrix(nmsf,1:3) = msfvector(end-2:end);
msfmatrix(nmsf,4) = msfvector(end);