function y = msgrade(dat,par,degreeff)
% This function returns the membership degrees of a set of crisp numbers to
% a set of trapezoidal fuzzy sets. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Input: dat = (sizedataset,1) matrix containing the values of the data for
%               which the membership grades are calculated
%        par = (*,4) matrix containing the values
%               characterizing membership functions of fuzzy sets
%        degreeff = (*,1) vector containing the degrees of fulfilment of
%              the * linguistic values / membership functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Output: y =  (sizedataset,*) matrix containing the membership grades
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% This functions calls no user defined functions.

% number of data points
sizedataset = size(dat,1);
% temporary matrices Z and E
Z=zeros(sizedataset,1);
E=ones(sizedataset,1);

if nargin > 2
    for i=1:size(par,1) % for each membership function
        % copy the vector parset sizedataset times
        parmat = E*par(i,:);
        
        % dff is a (sizedataset,1) vector containing one and the same value:
        % the degree of fulfilment of the current linguistic value / membership
        % function
        dffmat = E*degreeff(1,i);
        
        % Calculate the degrees of membership with the formula
        % max(min((x-a)/(b-a),1,(x-d)/(c-d)),0). With a resp. d being the left
        % resp. right edge of the base of the trapezoidal membership function
        % (with membership degrees of 0) and b resp. c being the left resp.
        % right edge of the top line of the trapezoidal membershipfunction.
        
        % vector1 contains the values of (x-a)/(b-a); 1 and (x-d)/(c-d) for
        % each data point
        vector1(:,1) = (dat - parmat(:,1))./(parmat(:,2)-parmat(:,1));
        vector1(:,2) = dffmat;
        vector1(:,3) = (dat - parmat(:,4))./(parmat(:,3)-parmat(:,4));
        % vector2 contains the minimum of (x-a)/(b-a); 1 and (x-d)/(c-d) for
        % each data point
        vector2 = min(vector1,[],2);
        % y contains the degrees of membership of each data point
        y(:,i) = max(vector2,Z);
    end    
    
else
    for i=1:size(par,1) % for each membership function
        % copy the vector parset sizedataset times
        parmat = E*par(i,:);
        
        % Calculate the degrees of membership with the formula
        % max(min((x-a)/(b-a),1,(x-d)/(c-d)),0). With a resp. d being the left
        % resp. right edge of the base of the trapezoidal membership function
        % (with membership degrees of 0) and b resp. c being the left resp.
        % right edge of the top line of the trapezoidal membershipfunction.
        
        % vector1 contains the values of (x-a)/(b-a); 1 and (x-d)/(c-d) for
        % each data point
        vector1(:,1) = (dat - parmat(:,1))./(parmat(:,2)-parmat(:,1));
        vector1(:,2) = E;
        vector1(:,3) = (dat - parmat(:,4))./(parmat(:,3)-parmat(:,4));
        % vector2 contains the minimum of (x-a)/(b-a); 1 and (x-d)/(c-d) for
        % each data point
        vector2 = min(vector1,[],2);
        % y contains the degrees of membership of each data point
        y(:,i) = max(vector2,Z);
    end    
end