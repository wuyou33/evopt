clear; clc;

% NOTE that put this code in a folder named *deccg*, which could be
% downloaded from * http://staff.ustc.edu.cn/~ketang/codes/DECCG.zip *.

%%
runtimeStart = tic;

rng('shuffle'); % for uncontrollable randomness

addpath('benchmark');

funcDim = 1000;
popSize = 1;
testNum = 25;
funcEvalMax = 5000 * funcDim;

optResFilename = 'result/compCMAES_f%02d.mat';

global initial_flag;
for f = 1 : 13
    optRes = cell(1, testNum);
    if f == 1 || f == 3 || f == 4 || f == 6
        funcLowerBounds = -100 * ones(popSize, funcDim);
        funcUpperBounds = 100 * ones(popSize, funcDim);
    elseif f == 2
        funcLowerBounds = -10 * ones(popSize, funcDim);
        funcUpperBounds = 10 * ones(popSize, funcDim);
    elseif f == 5
        funcLowerBounds = -30 * ones(popSize, funcDim);
        funcUpperBounds = 30 * ones(popSize, funcDim);
    elseif f == 7
        funcLowerBounds = -1.28 * ones(popSize, funcDim);
        funcUpperBounds = 1.28 * ones(popSize, funcDim);
    elseif f == 8
        funcLowerBounds = -500 * ones(popSize, funcDim);
        funcUpperBounds = 500 * ones(popSize, funcDim);
    elseif f == 9
        funcLowerBounds = -5.12 * ones(popSize, funcDim);
        funcUpperBounds = 5.12 * ones(popSize, funcDim);
    elseif f == 10
        funcLowerBounds = -32 * ones(popSize, funcDim);
        funcUpperBounds = 32 * ones(popSize, funcDim);
    elseif f == 11
        funcLowerBounds = -600 * ones(popSize, funcDim);
        funcUpperBounds = 600 * ones(popSize, funcDim);
    elseif f == 12 || f == 13
        funcLowerBounds = -50 * ones(popSize, funcDim);
        funcUpperBounds = 50 * ones(popSize, funcDim);
    end
    for t = 1 : testNum
        initial_flag = 0;
        conFuncParams = ConFuncParams(...
            @(X) (feval('benchmark_func', X, f)), funcDim, ...
            funcUpperBounds(1, :), funcLowerBounds(1, :));
        optAlgoParams = OptAlgoParams('PureCMAES', funcEvalMax, popSize);
        testParams = TestParams(1, true, 27 + t);
        optRes{t} = RunAlgo(conFuncParams, testParams, optAlgoParams);
    end
    save(sprintf(optResFilename, f), 'optRes');
end
runtime = toc(runtimeStart);
fprintf(sprintf('Total runtime: %7.5e\n', runtime));
