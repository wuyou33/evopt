function [opty, optx, funcEvalCurves] = lsoDECCG(funcName, f, funcDim, ...
    funcLowerBounds, funcUpperBounds, ...
    popSize, genMax, numSubDim, isAdaptiveWeight)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Large Scale Optimization Algorithm (lso): DECCG.
%
% ---------------
% || REFERENCE ||
% ---------------
%   1. Yang, Z., Tang, K. and Yao, X., 2008.
%       Large scale evolutionary optimization using cooperative coevolution.
%       Information Sciences, 178(15), pp.2985-2999.
%
% ---------------
% || COPYRIGHT ||
% ---------------
%   * Yang, Z. (for the original version)
%
% ---------------
% ||   NOTE    ||
% ---------------
%   Refer to * http://staff.ustc.edu.cn/~ketang/codes/DECCG.zip *
%   for the original MATLAB source code.
%
%   NOTE that here some slight changes are made for less bugs
%   and better readability.
%
%   Frankly speaking, here the MATLAB code was *not well-designed*. Hence,
%   it could be used only for test.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
paraSaNSDE = 0.5;
funcEvalCurves = [];

X = funcLowerBounds + ...
    rand(popSize, funcDim) .* (funcUpperBounds - funcLowerBounds);
y = feval(funcName, X, f);
[opty, optyInd] = min(y);
optx = X(optyInd, :);

genNum = 0;
while genNum < genMax
    group = grouping(funcDim, numSubDim);
    groupNum = size(group, 2);
    
    for g = 1 : groupNum
        iterMax = 200;
        if genNum + iterMax >= genMax
            iterMax = genMax - genNum;
        end
        if iterMax == 0
            break;
        end
        if iterMax < 0
            disp('*** DECCG Warning ***: an unexpected value of *iterMax*.');
        end
        
        subDimInd = group{g};
        subX = X(:, subDimInd);
        [subX, optx, opty, funcEvalCurve , paraSaNSDE] = ...
            sansde(funcName, f, subDimInd, ...
            subX, optx , opty, ...
            funcLowerBounds(:, subDimInd), funcUpperBounds(:, subDimInd), ...
            iterMax, paraSaNSDE);
        genNum = genNum + iterMax;
        funcEvalCurves = cat(1, funcEvalCurves, funcEvalCurve);
        X(:, subDimInd) = subX;
    end
    
    y = feval(funcName, X, f);
    [yMin, yMinInd] = min(y);
    if yMin < opty
        opty = yMin;
        optx = X(yMinInd, :);
    end
    
    if isAdaptiveWeight
        iterMax = 200;
        if genNum + iterMax >= genMax
            iterMax = genMax - genNum;
        end
        [xWeight, yWeight, funcEvalCurve, flag] = ...
            de_weight(funcName, f, optx, opty, ...
            funcLowerBounds, funcUpperBounds, popSize, iterMax, group);
        if flag == 0
            genNum = genNum + iterMax;
        end
        if ~isempty(funcEvalCurve)
            funcEvalCurves = cat(1, funcEvalCurves, funcEvalCurve);
        end
        if yWeight < opty
            opty = yWeight;
            optx = xWeight;
        end
        
        iterMax = 200;
        if genNum + iterMax >= genMax
            iterMax = genMax - genNum;
        end
        [yMax, yMaxInd] = max(y);
        xMax = X(yMaxInd, :);
        [xWeight, yWeight, funcEvalCurve , flag] = ...
            de_weight(funcName, f, xMax, opty, ...
            funcLowerBounds, funcUpperBounds, popSize, iterMax, group);
        if flag == 0
            genNum = genNum + iterMax;
        end
        if ~isempty(funcEvalCurve)
            funcEvalCurves = cat(1, funcEvalCurves, funcEvalCurve);
        end
        if yWeight < yMax
            y(yMaxInd) = yWeight;
            X(yMaxInd, :) = xWeight;
        end
        if yWeight < opty
            opty = yWeight;
            optx = xWeight;
        end
        
        iterMax = 200;
        if genNum + iterMax >= genMax
            iterMax = genMax - genNum;
        end
        yRandInd = randperm(popSize);
        yRandInd = yRandInd(1);
        yRand = y(yRandInd);
        xRand = X(yRandInd, :);
        [xWeight, yWeight, funcEvalCurve , flag] = ...
            de_weight(funcName, f, xRand, opty, ...
            funcLowerBounds, funcUpperBounds, popSize, iterMax, group);
        if flag == 0
            genNum = genNum + iterMax;
        end
        if ~isempty(funcEvalCurve)
            funcEvalCurves = cat(1, funcEvalCurves, funcEvalCurve);
        end
        if yWeight < yRand
            X(yRandInd, :) = xWeight;
        end
        if yWeight < opty
            opty = yWeight;
            optx = xWeight;
        end
    end
end
end
