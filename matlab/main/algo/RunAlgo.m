function optRes = RunAlgo(conFuncParams, testParams, optAlgoParams)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% An Unified Interface to Run the Optimization Algorithm for a Continuous Function.
%
% ---------------
% INPUT       <<<
% ---------------
%   conFuncParams: struct, parameters for the continuous functon optimized
%   testParams   : struct, parameters for all the independent tests designed
%   optAlgoParams: struct, parameters for the optmizaton algorithm selected
%
% ---------------
% OUTPUT      >>>
% ---------------
%   optRes      : cell, final optmizaton results
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% simplify the naming of local variables
funcName = conFuncParams.funcName;
funcDim = conFuncParams.funcDim;
testNum = testParams.testNum;
algoName = optAlgoParams.algoName;
algoFuncEvalMax = optAlgoParams.algoFuncEvalMax;
algoPopSize = optAlgoParams.algoPopSize;

if isa(funcName, 'function_handle')
    fprintf(sprintf('* funcName: %s + funcDim: %d + testNum: %d\n', ...
        func2str(funcName), funcDim, testNum));
else
    fprintf(sprintf('* funcName: %s + funcDim: %d + testNum: %d\n', ...
        funcName, funcDim, testNum));
end
fprintf(sprintf('* algoName: %s + algoFuncEvalMax: %d + algoPopSize: %d\n', ...
    algoName, algoFuncEvalMax, algoPopSize));

%
optRes = cell(1, testNum);
optys = zeros(1, testNum);
runtimes = zeros(1, testNum);
funcEvalRuntimes = zeros(1, testNum);
funcEvalNums = zeros(1, testNum);

logInfo = ['test %2d: opty = %+7.4e || runTime = %7.2e ' ...
    '|| funcEvalRuntime = %7.2e || funcEvalNum = %d || <- '...
    'optx [%+7.2e ... %+7.2e]\n'];

for t = 1 : testNum
    optAlgoParams.algoInitSeed = testParams.testSeeds(t);
    optRes{t} = feval(str2func(algoName), conFuncParams, optAlgoParams);
    optys(t) = optRes{t}.opty;
    runtimes(t) = optRes{t}.runtime;
    funcEvalRuntimes(t) = optRes{t}.funcEvalRuntime;
    funcEvalNums(t) = optRes{t}.funcEvalNum;
    if testParams.testPrintLog
        fprintf(logInfo, t, ...
            optRes{t}.opty, optRes{t}.runtime, ...
            optRes{t}.funcEvalRuntime, optRes{t}.funcEvalNum, ...
            optRes{t}.optx(1), optRes{t}.optx(end));
    end
end

fprintf('$ ------- >>> Summary <<< ------- $:\n');
funcEvalRatios = 100.0 * (funcEvalRuntimes ./ runtimes); % percentage
if isa(funcName, 'function_handle')
    fprintf(sprintf('* funcName: %s + funcDim: %d + testNum: %d\n', ...
        func2str(funcName), funcDim, testNum));
else
    fprintf(sprintf('* funcName: %s + funcDim: %d + testNum: %d\n', ...
        funcName, funcDim, testNum));
end
fprintf(sprintf('* algoName: %s + algoFuncEvalMax: %d + algoPopSize: %d\n', ...
    algoName, algoFuncEvalMax, algoPopSize));
fprintf('opty            --- Mean & Std: %7.2e & %7.2e\n', mean(optys), std(optys));
fprintf('runtime         --- Mean & Std: %7.2e & %7.2e\n', mean(runtimes), std(runtimes));
fprintf('funcEvalRuntime --- Mean & Std: %7.2e & %7.2e\n', mean(funcEvalRuntimes), std(funcEvalRuntimes));
fprintf('funcEvalRatio   --- Mean & Std: %7.2f%% & %7.2f%%\n', mean(funcEvalRatios), std(funcEvalRatios));
fprintf('funcEvalNum     --- Mean & Std: %7.2e & %7.2e\n', mean(funcEvalNums), std(funcEvalNums));
end
