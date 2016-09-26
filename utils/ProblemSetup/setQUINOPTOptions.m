function options = setQUINOPTOptions(userOpts)

%% SETQUINOPTOPTIONS.m Set user options for QUINOPT
%
% options = SETQUADINTINEQOPTIONS(userOpts) takes the user input structure 
%       options and overrides the default options.

% ----------------------------------------------------------------------- %
%        Author:    Giovanni Fantuzzi
%                   Department of Aeronautics
%                   Imperial College London
%       Created:    27/04/2015
% Last Modified:    05/05/2016
% ----------------------------------------------------------------------- %

% Default options
options.YALMIP           = sdpsettings; % YALMIP options
options.solve            = true;        % Solve the optimization problem?
options.rigorous         = true;        % Rigorous relaxation (with tail term) or simple approximation
options.BCprojectorBasis = 'rref';      % set to 'orth' for orthonormal, 'rref' for rational
options.sosdeg           = 6;           % degree of polynomials for S procedure
options.psdtol           = -1e-8;       % tolerance for small negative eigenvalues

% Assign user
if isempty(userOpts)
    return
elseif ~isstruct(userOpts)
    error('Input OPTIONS must be a structure.');
else
    fnames = fieldnames(userOpts);
    allowedNames = {'YALMIP'; ...
                    'rigorous'; ...
                    'BCprojectorBasis'; ...
                    'sosdeg'; ...
                    'solve';...
                    'psdtol'};
    for n=1:length(fnames)
        if any(strcmpi(fnames{n},allowedNames))
            boo = userOpts.(fnames{n});
            mustbe = class(options.(fnames{n}));
            if isa(boo,mustbe)
                options.(fnames{n}) = boo;
            else
                error('Wrong class for field %s in OPTIONS.',fnames{n})
            end
        else
            error('Unknown field %s in input OPTIONS.',fnames{n})
        end
    end
end