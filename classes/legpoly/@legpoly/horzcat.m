function q = horzcat(varargin)

%% OVERLOADED: horzcat
% Concatenate objects of type legpoly, sdpvar and numeric into a matrix
% (horizontal concatenation)
% VERY UGLY CODE!

% ----------------------------------------------------------------------- %
%        Author:    Giovanni Fantuzzi
%                   Department of Aeronautics
%                   Imperial College London
%       Created:    07/10/2015
% Last Modified:    08/04/2016
% ----------------------------------------------------------------------- %

% ----------------------------------------------------------------------- %
% INITIALISE OUTPUT
% ----------------------------------------------------------------------- %
q = struct([]);

% ----------------------------------------------------------------------- %
% CHECK INPUTS
% ----------------------------------------------------------------------- %
% Find class & size of each input
ClassType = cellfun(@class,varargin(:),'uniformoutput',0);
rowSize = cellfun(@(x)size(x,1),varargin(:));
colSize = cellfun(@(x)size(x,2),varargin(:));

if any(rowSize==0)
   % remove empties and call again
    q = horzcat(varargin{rowSize~=0});
    return
end
if any(rowSize~=rowSize(1)) 
    % any rows mismatch
    error('Dimension mismatch in horizontal concatenation')
end
rowSize = rowSize(1);

% Find partition of output with respect to input size
partU = cumsum(colSize(:));         % upper limit
partL = [1; partU(1:end-1)+1];      % lower limit

% Find the legpoly objects & check they have the same independent variable
% and domain - cannot concatenate polys with different domain.
theLegPolys = find(strcmpi(ClassType,'legpoly'));
theOthers = find(~strcmpi(ClassType,'legpoly'));

ivar0id = [];
domn0 = [0,0];
for n = 1:length(theLegPolys)
    
    position = theLegPolys(n);
    ivar = getivar(varargin{position});
    domn = getDomain(varargin{position});
    
    % Set reference ivar and domn if not 0
    if ~isempty(depends(ivar)) && isempty(ivar0id)
        idx = find(any(ivar),1,'first');
        ivar0 = ivar(idx);
        ivar0id = depends(ivar);
    end
    if ~any(domn0) && any(domn)
        domn0 = domn;
    end
    
    % Compare with reference
    if depends(ivar)~=ivar0id
        error('Cannot concatenate Legendre polynomials with different independent variable.')
    elseif any(domn0-domn) && any(domn)
        error('Cannot concatenate Legendre polynomials defined over different domains.')
    else
        % all fine - assign to output
        [q(1:rowSize,partL(position):partU(position)).coef] = deal(varargin{position}.coef);
        [q(1:rowSize,partL(position):partU(position)).ivar] = deal(varargin{position}.ivar);
        [q(1:rowSize,partL(position):partU(position)).domn] = deal(varargin{position}.domn);
    end
end

% Transform other inputs in legpoly objects
for n = 1:length(theOthers)
    position = theOthers(n);
    if isa(varargin{position},'sdpvar')
        varargin{position} = legpoly(domn0,ivar0,varargin{position});
    else
        % a number (or an unknown class object, but shoud throw error)
        varargin{position} = legpoly(varargin{position});
    end
    [q(1:rowSize,partL(position):partU(position)).coef] = deal(varargin{position}.coef);
    [q(1:rowSize,partL(position):partU(position)).ivar] = deal(varargin{position}.ivar);
    [q(1:rowSize,partL(position):partU(position)).domn] = deal(varargin{position}.domn);
end

% ----------------------------------------------------------------------- %
% SET OUTPUT
% ----------------------------------------------------------------------- %
q = legpoly(q);

% END CODE
end