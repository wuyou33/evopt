clear; clc;

funcInds = 1 : 13;
testMax = 25;

%%
% NOTE that the below data is directly obtained from the paper:
%   Yang, Z., Tang, K. and Yao, X., 2008.
%   Large scale evolutionary optimization using cooperative coevolution.
%   Information Sciences, 178(15), pp.2985-2999.
meanDECCG = [2.17e-25 5.37e-14 3.71e-23 1.01e-01 9.87e+02 0.00e+00 8.40e-03 ...
    -418983 3.55e-16 2.22e-13 1.01e-15 6.89e-25 2.55e-21];

%%
% NOTE that we repeated the experiments of the above paper, and could
%   obtain the below data. Luckly, we obtained the same or slightly
%   better results in most cases, except f03 (due to unknown reasons)
%   and f13 (perhaps due to randomness).
meanDECCGRepeat = Inf * ones(1, length(funcInds));
curves = zeros(50000, length(funcInds));
optResFolder = 'CentOS7'; % run on CentOS 7
for f = 1 : length(funcInds)
    optResFilename = sprintf('%s/testDECCG_f%02d.mat', optResFolder, f);
    load(optResFilename);
    meanDECCGRepeat(f) = mean(optys);
    curveLength = Inf * ones(1, testMax);
    for t = 1 : testMax
        curveLength(t) = length(funcEvalCurves{t});
        if curveLength(t) > size(curves, 1) % unexpected length
            fprintf(sprintf('*** Warning ***: %02d - %02d.', f, t));
        end
        curves(1 : curveLength(t), f) = ...
            curves(1 : curveLength(t), f) + funcEvalCurves{t};
    end
    minCurveLength = min(curveLength);
    curves(1 : minCurveLength, f) = curves(1 : minCurveLength, f) / testMax;
    curves((minCurveLength + 1) : end, f) = Inf;
end

%%
meanComp = [meanDECCG; meanDECCGRepeat];

%%
for f = 1 : length(funcInds)
    figure(f);
    plot(curves(:, f));
end

%%
subFuncInds = [1 3];
for f = 1 : length(subFuncInds)
    figure(100 + f);
    semilogy(curves(:, f));
end
