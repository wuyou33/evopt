function optRes = PureCMAES(conFuncParams, optAlgoParams)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% (Pure) Evolution Strategy with Covariance Matrix Adaptation.
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
%
% ---------------
% || REFERENCE ||
% ---------------
%   1. http://cma.gforge.inria.fr/purecmaes.m
%
% ---------------
% || COPYRIGHT ||
% ---------------
%   * Nikolaus Hansen ( https://scholar.google.com/citations?user=Z8ISh-wAAAAJ&hl=en&oi=sra )
%
% ---------------
% ||   NOTE    ||
% ---------------
%   Refer to * http://cma.gforge.inria.fr/purecmaes.m * for the original MATLAB source code.
%   NOTE that here some slight changes are made for less bugs,
%   faster implementation, and better readability.
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
funcEvalMax = optAlgoParams.algoFuncEvalMax;
stopConditionOpty = 1e-10; % stop condition on y

funcEvalCurve = [];

% initialize initial upper and lower bounds for search
initUpperBound = conFuncParams.funcInitUpperBounds;
initLowerBound = conFuncParams.funcInitLowerBounds;

% initialize
xMean = initLowerBound + (initUpperBound - initLowerBound) .* ...
    rand(RandStream('mt19937ar', 'Seed', optAlgoParams.algoInitSeed), ...
    funcDim, 1)';
xMean = xMean';

stepSize = 0.5;

% strategy parameter setting for *selection*
lambda = 4 + floor(3 * log(funcDim)); % number of offsprings
mu = lambda / 2; % number of parents for recombination
weights = log(mu + 1 / 2) - log(1 : mu)'; % recombination weights
mu = floor(mu); % number of parents for recombination
weights = weights / sum(weights); % normalized recombination weights
muEff = sum(weights) ^ 2 / sum(weights .^ 2);

% strategy parameter setting for *adaptation*
cc = (4 + muEff / funcDim) / (funcDim + 4 + 2 * muEff / funcDim); % time constant for cumulation for C
cs = (muEff + 2) / (funcDim + muEff + 5);  % time constant for cumulation for stepSize control
c1 = 2 / ((funcDim + 1.3) ^ 2 + muEff); % learning rate for rank-one update of C
cmu = min(1 - c1, 2 * (muEff - 2 + 1 / muEff) / ((funcDim + 2) ^ 2 + muEff)); % for rank-mu update
damps = 1 + 2 * max(0, sqrt((muEff - 1) / (funcDim + 1)) - 1) + cs; % damping for stepSize

% initialize dynamic strategy parameters and constants
pc = zeros(funcDim, 1); % evolution paths for C
ps = zeros(funcDim, 1); % evolution paths for stepSize
B = eye(funcDim, funcDim); % coordinate system
D = ones(funcDim, 1); % scaling
C = B * diag(D .^ 2) * B'; % covariance matrix
invsqrtC = B * diag(D .^ -1) * B';
eigenEval = 0; % track update of B and D
chiFuncDim = funcDim ^ 0.5 * (1 - 1 / (4 * funcDim) + 1 / (21 * funcDim ^ 2));

funcEvalNum = 0;
funcEvalRuntime = 0;
opty = Inf;
optx = Inf * ones(1, funcDim);
X = Inf * ones(funcDim, lambda);
while funcEvalNum < funcEvalMax
    % generate and evaluate lambda X
    for k = 1 : lambda
        X(:, k) = xMean + stepSize * B * (D .* randn(funcDim, 1)); % m + sig * Normal(0, C)
    end
    funcEvalRuntimeStart = tic;
    y = feval(funcName, X');
    funcEvalCurve = cat(1, funcEvalCurve, y);
    funcEvalRuntime = funcEvalRuntime + toc(funcEvalRuntimeStart);
    funcEvalNum = funcEvalNum + lambda;
    
    % sort and compute weighted mean
    [y, yInd] = sort(y);
    if y(1) < opty
        opty = y(1);
        optx = X(:, yInd(1))';
    end
    
    xMeanOld = xMean;
    xMean = X(:, yInd(1 : mu)) * weights; % recombination
    
    % update evolution paths (cumulation)
    ps = (1 - cs) * ps + sqrt(cs * (2 - cs) * muEff) * invsqrtC * (xMean - xMeanOld) / stepSize;
    hsig = sum(ps .^ 2) / (1 - (1 - cs) ^ (2 * funcEvalNum / lambda)) / funcDim < 2 + 4 / (funcDim + 1);
    pc = (1 - cc) * pc + hsig * sqrt(cc * (2 - cc) * muEff) * (xMean - xMeanOld) / stepSize;
    
    % adapt covariance matrix
    muDiff = (1 / stepSize) * (X(:, yInd(1 : mu)) - repmat(xMeanOld, 1, mu)); % mu difference vectors
    C = (1 - c1 - cmu) * C ...
        + c1 * (pc * pc' + (1 - hsig) * cc * (2-cc) * C) ... % rank one update + minor correction if hsig == 0
        + cmu * muDiff * diag(weights) * muDiff'; % rank mu update
    
    % adapt step size
    stepSize = stepSize * exp((cs / damps) * (norm(ps) / chiFuncDim - 1));
    
    % update B and D from C
    if funcEvalNum - eigenEval > lambda / (c1 + cmu) / funcDim /10
        eigenEval = funcEvalNum;
        C = triu(C) + triu(C, 1)'; % enforce symmetry
        [B, D] = eig(C); % eigen decomposition (B == normalized eigenvectors)
        D = sqrt(diag(D)); % standard deviations
        invsqrtC = B * diag(D .^ -1) * B';
    end
    
    if y(1) <= stopConditionOpty || max(D) > 1e7 * min(D)
        break;
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
