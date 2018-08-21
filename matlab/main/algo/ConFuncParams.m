function conFuncParams = ConFuncParams(funcName, funcDim, ...
    funcUpperBounds, funcLowerBounds, ...
    funcInitUpperBounds, funcInitLowerBounds, ...
    funcOptx, funcOpty)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Continuous Function Parameters (for Minimization).
%
% ---------------
% INPUT       <<<
% ---------------
%   funcName           : string scalar, function name
%   funcDim            : int scalar, function dimension
%   funcUpperBounds    : vector of length *funcDim*, upper bounds during search
%   funcLowerBounds    : vector of length *funcDim*, lower bounds during search
%   funcInitUpperBounds: vector of length *funcDim*, initial upper bounds for search
%   funcInitLowerBounds: vector of length *funcDim*, initial lower bounds for search
%   funcOptx           : vector of length *funcDim*, optimal value (i.e., x)
%   funcOpty           : scalar, optimal function value (i.e., y)
%
% ---------------
% OUTPUT      >>>
% ---------------
%   conFuncParams: struct, continuous function parameters
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
switch nargin % syntactic sugar
    case 8
    case 7
        funcOpty = Inf;
    case 6
        funcOptx = Inf * ones(1, funcDim);
        funcOpty = Inf;
    case 5
        funcInitLowerBounds = -funcInitUpperBounds;
        funcOptx = Inf * ones(1, funcDim);
        funcOpty = Inf;
    case 4
        funcInitUpperBounds = funcUpperBounds;
        funcInitLowerBounds = funcLowerBounds;
        funcOptx = Inf * ones(1, funcDim);
        funcOpty = Inf;
    case 3
        funcLowerBounds = -funcUpperBounds;
        funcInitUpperBounds = funcUpperBounds;
        funcInitLowerBounds = -funcUpperBounds;
        funcOptx = Inf * ones(1, funcDim);
        funcOpty = Inf;
    otherwise
        error('set at least three parameters: *funcName*, *funcDim*, and *funcUpperBounds*.');
end

if ~isscalar(funcDim) || ~isnumeric(funcDim) || funcDim <= 0
    error('function dimension should be larger than 0.');
end

funcUpperBounds = scalar2vector(funcUpperBounds, funcDim);
funcLowerBounds = scalar2vector(funcLowerBounds, funcDim);
funcInitUpperBounds = scalar2vector(funcInitUpperBounds, funcDim);
funcInitLowerBounds = scalar2vector(funcInitLowerBounds, funcDim);

funcUpperBounds = transposeSize(funcUpperBounds);
funcLowerBounds = transposeSize(funcLowerBounds);
funcInitUpperBounds = transposeSize(funcInitUpperBounds);
funcInitLowerBounds = transposeSize(funcInitLowerBounds);

if ~checkSize(funcUpperBounds) || ...
        ~checkSize(funcLowerBounds) || ...
        ~checkSize(funcInitUpperBounds) || ...
        ~checkSize(funcInitLowerBounds)
    error('all search bounds should be a double vector.');
end

if funcDim ~= numel(funcUpperBounds) || ...
        funcDim ~= numel(funcLowerBounds) || ...
        funcDim ~= numel(funcInitUpperBounds) || ...
        funcDim ~= numel(funcInitLowerBounds)
    error('dimension of all search bounds should be equal to function dimension.');
end
if any(funcUpperBounds <= funcLowerBounds)
    error('upper bounds should be larger than lower bounds.');
end
if any(funcInitUpperBounds <= funcInitLowerBounds)
    error('initial upper bounds should be larger than initial lower bounds.');
end

conFuncParams = struct(...
    'funcName', funcName, ...
    'funcDim', funcDim, ...
    'funcUpperBounds', funcUpperBounds, ...
    'funcLowerBounds', funcLowerBounds, ...
    'funcInitUpperBounds', funcInitUpperBounds, ...
    'funcInitLowerBounds', funcInitLowerBounds, ...
    'funcOptx', funcOptx, ...
    'funcOpty', funcOpty);
end

% -------------------------------------------------------------------------
% helper functions
% -------------------------------------------------------------------------
function vector = scalar2vector(scalar, funcDim)
if isscalar(scalar) && isnumeric(scalar)
    vector = scalar * ones(1, funcDim);
else
    vector = scalar;
end
end

function vector = transposeSize(vector)
if size(vector, 1) > 1 && size(vector, 2) == 1
    vector = vector';
end
end

function isVector = checkSize(vector)
if size(vector, 1) ~= 1
    isVector = false;
else
    isVector = true;
end
end
