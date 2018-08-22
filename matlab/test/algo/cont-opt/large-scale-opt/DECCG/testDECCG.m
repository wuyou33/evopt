clear; clc;

% NOTE that put this code in a folder named *deccg*, which could be
% downloaded from * http://staff.ustc.edu.cn/~ketang/codes/DECCG.zip *.

%%
rng('shuffle'); % for uncontrollable randomness

addpath('benchmark');

funcDim = 1000;
numSubDim = 100;
popSize = 100;
testNum = 25;
funcEvalMax = 5000 * funcDim;
genMax = funcEvalMax / popSize;
isAdaptiveWeight = true;
% isAdaptiveWeight = false;

optResFilename = 'result/testDECCG_f%02d.mat';

global initial_flag;
for f = 1 : 13
    optys = [];
    optxs = [];
    funcEvalCurves = cell(1, testNum);
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
        [opty, optx, funcEvalCurve] = lsoDECCG(...
            'benchmark_func', f, funcDim, ...
            funcLowerBounds, funcUpperBounds, ...
            popSize, genMax, numSubDim, isAdaptiveWeight);
        optys = cat(1, optys, opty);
        optxs = cat(1, optxs, optx);
        funcEvalCurves{t} = cat(1, funcEvalCurves{t}, funcEvalCurve);
    end
    save(sprintf(optResFilename, f), ...
        'optys', 'optxs', 'funcEvalCurves');
    fprintf(sprintf('f%02d: %7.5e (%7.5e)\n', ...
        f, mean(optys), std(optys)));
end
