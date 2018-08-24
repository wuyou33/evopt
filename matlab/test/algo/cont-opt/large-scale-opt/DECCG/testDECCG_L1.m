clear; clc;

% NOTE that put this code in a folder named *deccg*, which could be
% downloaded from * http://staff.ustc.edu.cn/~ketang/codes/DECCG.zip *.

%%
rng('shuffle'); % for uncontrollable randomness

addpath('benchmark');

funcDim = 1000;
numSubDim = 100;
groupNum = 10;
popSize = 100;
testNum = 25;
funcEvalMax = 5000 * funcDim;
genMax = funcEvalMax / popSize;

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
        [opty, optx, funcEvalCurve, optxSeq, optxFlag] = ...
            lsoDECCG_L1(...
            'benchmark_func', f, funcDim, ...
            funcLowerBounds, funcUpperBounds, ...
            popSize, genMax, numSubDim);
        optys = cat(1, optys, opty);
        optxs = cat(1, optxs, optx);
        funcEvalCurves{t} = cat(1, funcEvalCurves{t}, funcEvalCurve);
        % --------------------------------------------------------------- %
        %         i = 1;
        %         dis = squareform(pdist(optxSeq, 'cityblock'));
        %         while i < length(optxFlag)
        %             if i + groupNum <= length(optxFlag) && ...
        %                     isequal(optxFlag(i + 1) : optxFlag(i + groupNum), 1 : groupNum)
        %                 tmp = 0;
        %                 for j = 0 : (groupNum - 1)
        %                     tmp = tmp + dis(i + j, i + j + 1);
        %                 end
        %                 if abs(tmp - dis(i, i + groupNum)) > 1e-6
        %                     fprintf('%20.15e vs. %20.15e\n', tmp, dis(i, i + groupNum));
        %                     error('ERROR!');
        %                 end
        %                 i = i + groupNum;
        %             else
        %                 i = i + 1;
        %             end
        %         end
        %         optxConv = [];
        %         for i = 1 : (length(optxFlag) - 1)
        %             optxConv = cat(1, optxConv, dis(i, i + 1));
        %         end
        %         figure(f);
        %         plot(optxConv);
        % --------------------------------------------------------------- %
    end
    save(sprintf(optResFilename, f), ...
        'optys', 'optxs', 'funcEvalCurves');
    fprintf(sprintf('f%02d: %7.5e (%7.5e)\n', ...
        f, mean(optys), std(optys)));
end
