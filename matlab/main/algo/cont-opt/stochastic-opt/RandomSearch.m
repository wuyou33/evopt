function optRes = RandomSearch(conFuncParams, optAlgoParams)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Random Search.
%
% ---------------
% INPUT       <<<
% ---------------
%   conFuncParams: struct, parameters for the continuous function optimized
%   optAlgoParams: struct, parameters for the optimization algorithm selected
%
% ---------------
% OUTPUT      >>>
% ---------------
%   optRes      : struct, optimization results
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
runtimeStart = tic;

% generate uncontrollable randomness
RandStream.setGlobalStream(RandStream('mt19937ar', 'Seed', 'shuffle'));

% simplify the naming of local variables
funcDim = conFuncParams.funcDim;
funcName = conFuncParams.funcName;
if ischar(funcName)
    funcName = str2func(funcName);
end
popSize = optAlgoParams.algoPopSize;
funcEvalMax = optAlgoParams.algoFuncEvalMax;

funcEvalCurve = [];

% initialize upper and lower bounds during search
upperBound = repmat(conFuncParams.funcUpperBounds, popSize, 1);
lowerBound = repmat(conFuncParams.funcLowerBounds, popSize, 1);

% initialize initial upper and lower bounds for search
initUpperBound = repmat(conFuncParams.funcInitUpperBounds, popSize, 1);
initLowerBound = repmat(conFuncParams.funcInitLowerBounds, popSize, 1);

% initialize the population (i.e., X)
X = initLowerBound + (initUpperBound - initLowerBound) .* ...
    rand(RandStream('mt19937ar', 'Seed', optAlgoParams.algoInitSeed), ...
    funcDim, popSize)';

% initialize function values (i.e., y)
funcEvalRuntimeStart = tic;
y = feval(funcName, X);
funcEvalRuntime = toc(funcEvalRuntimeStart);
funcEvalCurve = cat(1, funcEvalCurve, y);
funcEvalNum = popSize;

% initialize globally best X and y
[opty, optyInd] = min(y);
optx = X(optyInd, :);

% iteratively update the population in a synchronous way
while funcEvalNum < funcEvalMax
    % update, limit, and evaluate X
    X = unifrnd(lowerBound, upperBound);
    
    funcEvalRuntimeStart = tic;
    y = feval(funcName, X);
    funcEvalRuntime = funcEvalRuntime + toc(funcEvalRuntimeStart);
    funcEvalCurve = cat(1, funcEvalCurve, y);
    funcEvalNum = funcEvalNum + popSize;
    
    % update globally best X and y
    [yMin, yMinInd] = min(y);
    if yMin < opty
        opty = yMin;
        optx = X(yMinInd, :);
    end
end

% return final optimization results
optRes.opty = opty;
optRes.optx = optx;
optRes.funcEvalRuntime = funcEvalRuntime;
optRes.funcEvalNum = funcEvalNum;
optRes.funcEvalCurve = funcEvalCurve;
optRes.runtime = toc(runtimeStart);
end
