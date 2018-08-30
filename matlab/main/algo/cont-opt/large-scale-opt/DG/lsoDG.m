function [nonSepDims, sepDims, funcEvalNum] = lsoDG(conFuncParams, epsilon)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Differential Grouping (i.e., DG) for Large Scale Optimization.
%
% ---------------
% INPUT       <<<
% ---------------
%   conFuncParams: struct, parameters for the continuous functon optimized
%   epsilon      : scalar, sensitivity in detecting variables interactions
%
% ---------------
% OUTPUT      >>>
% ---------------
%   nonSepDims  : cell, all non-separable dimensions
%   sepDims     : int vector, all separable dimensions
%   funcEvalNum : int scalar, number of function evaluations spent
%
% ---------------
% || REFERENCE ||
% ---------------
%   1. Omidvar, M.N., Li, X., Mei, Y. and Yao, X., 2014.
%       Cooperative co-evolution with differential grouping for large scale optimization.
%       IEEE Transactions on Evolutionary Computation, 18(3), pp.378-393.
%
% ---------------
% || COPYRIGHT ||
% ---------------
%   * Mohammad Nabi Omidvar
%
% ---------------
% ||   NOTE    ||
% ---------------
%   Refer to * https://bitbucket.org/mno/differential-grouping *
%   for the original MATLAB source code.
%   NOTE that here some slight changes are made for less bugs
%   and better readability.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
funcDims = 1 : conFuncParams.funcDim;
funcUpperBounds = conFuncParams.funcUpperBounds;
funcLowerBounds = conFuncParams.funcLowerBounds;
funcName = conFuncParams.funcName;
if ischar(funcName)
    funcName = str2func(funcName);
end

nonSepDims = cell(1, conFuncParams.funcDim);
nonSepDimNum = 0;
sepDims = [];
funcEvalNum = 0;

while ~isempty(funcDims)
    group = funcDims(1);
    p1 = funcLowerBounds;
    p2 = p1;
    p2(funcDims(1)) = funcUpperBounds(funcDims(1));
    delta1 = feval(funcName, p1) - feval(funcName, p2);
    funcEvalNum = funcEvalNum + 2;
    for d = 2 : length(funcDims)
        p3 = p1;
        p4 = p2;
        p3(funcDims(d)) = (funcUpperBounds(funcDims(d)) + ...
            funcLowerBounds(funcDims(d))) / 2;
        p4(funcDims(d)) = (funcUpperBounds(funcDims(d)) + ...
            funcLowerBounds(funcDims(d))) / 2;
        delta2 = feval(funcName, p3) - feval(funcName, p4);
        funcEvalNum = funcEvalNum + 2;
        if abs(delta1 - delta2) > epsilon
            group = union(group, funcDims(d));
        end
    end
    if length(group) == 1
        sepDims = union(sepDims, group);
    else
        nonSepDimNum = nonSepDimNum + 1;
        nonSepDims{nonSepDimNum} = group;
    end
    funcDims = setdiff(funcDims, group);
end
nonSepDims = nonSepDims(1 : nonSepDimNum);
end
