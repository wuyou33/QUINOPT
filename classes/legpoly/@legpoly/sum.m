function s = sum(X,dim)

% OVERLOADED: legpoly/sum

% ----------------------------------------------------------------------- %
%        Author:    Giovanni Fantuzzi
%                   Department of Aeronautics
%                   Imperial College London
%       Created:    07/10/2015
% Last Modified:    08/04/2016
% ----------------------------------------------------------------------- %

if nargin<1
    error('Not enough input arguments.')
elseif nargin==1
    dim = 1;
elseif nargin>2
    error('Too many input arguments.')
end

% vector case
if isvector(X)
    s = 0;
    for i=1:length(X)
        s = s + X(i);
    end
     
% matrix case, dim==1
elseif dim==1
    s = zeros(size(X),2);
    for i=1:size(X,1)
        s = s + X(i,:);
    end
    
% matrix case, dim==2
elseif dim==2
    s = zeros(size(X),1);
    for i=1:size(X,2)
        s = s + X(:,i);
    end
    
% otherwise
else
    error('Only two-dimensional legpoly objects can be summed.')
end
