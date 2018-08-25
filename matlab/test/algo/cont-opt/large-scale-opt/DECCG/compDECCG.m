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
%   better results in most cases, except f03 (due to unknown reasons).
% optResFolder = 'testDECCG_CentOS7'; % run on CentOS 7
% for f = 1 : length(funcInds)
%     optResFilename = sprintf('%s/testDECCG_f%02d.mat', optResFolder, f);
%     load(optResFilename);
%     funcEvalAvg = zeros(5000000, 1);
%     curveLength = Inf * ones(1, testMax);
%     for t = 1 : testMax
%         funcEvalCurve = funcEvalCurves{t};
%         curveLength(t) = length(funcEvalCurve);
%         for c = 2 : length(funcEvalCurve)
%             if funcEvalCurve(c - 1) < funcEvalCurve(c)
%                 funcEvalCurve(c) = funcEvalCurve(c - 1);
%             end
%         end
%         if curveLength(t) >= size(funcEvalAvg, 1) % unexpected length
%             funcEvalCurve = funcEvalCurve(1 : size(funcEvalAvg, 1));
%         else
%             error('ERROR!');
%         end
%         funcEvalAvg = funcEvalAvg + funcEvalCurve;
%     end
%     funcEvalAvg = funcEvalAvg / testMax;
%     save(optResFilename, 'optys', 'optxs', 'funcEvalAvg');
% end

%%
% NOTE that here only the cooperative co-evolution part is run (i.e.,
%   without adaptive weights -> waw).
% optResFolder = 'testDECCG_CentOS7_waw'; % run on CentOS 7
% for f = 1 : length(funcInds)
%     optResFilename = sprintf('%s/testDECCG_f%02d.mat', optResFolder, f);
%     load(optResFilename);
%     funcEvalAvg_ = zeros(5000000, 1);
%     curveLength = Inf * ones(1, testMax);
%     for t = 1 : testMax
%         funcEvalCurve = funcEvalCurves{t};
%         curveLength(t) = length(funcEvalCurve);
%         for c = 2 : length(funcEvalCurve)
%             if funcEvalCurve(c - 1) < funcEvalCurve(c)
%                 funcEvalCurve(c) = funcEvalCurve(c - 1);
%             end
%         end
%         if curveLength(t) >= size(funcEvalAvg_, 1) % unexpected length
%             funcEvalCurve = funcEvalCurve(1 : size(funcEvalAvg_, 1));
%         else
%             error('ERROR!');
%         end
%         funcEvalAvg_ = funcEvalAvg_ + funcEvalCurve;
%     end
%     funcEvalAvg_ = funcEvalAvg_ / testMax;
%     save(optResFilename, 'optys', 'optxs', 'funcEvalAvg_');
% end

%%
% L1 metric.
% optResFolder = 'testDECCG_L1_CentOS7'; % run on CentOS 7
% for f = 1 : length(funcInds)
%     optResFilename = sprintf('%s/testDECCG_f%02d.mat', optResFolder, f);
%     load(optResFilename);
%     funcEvalAvg = zeros(5000000, 1);
%     curveLength = Inf * ones(1, testMax);
%     for t = 1 : testMax
%         funcEvalCurve = funcEvalCurves{t};
%         curveLength(t) = length(funcEvalCurve);
%         for c = 2 : length(funcEvalCurve)
%             if funcEvalCurve(c - 1) < funcEvalCurve(c)
%                 funcEvalCurve(c) = funcEvalCurve(c - 1);
%             end
%         end
%         if curveLength(t) >= size(funcEvalAvg, 1) % unexpected length
%             funcEvalCurve = funcEvalCurve(1 : size(funcEvalAvg, 1));
%         else
%             error('ERROR!');
%         end
%         funcEvalAvg = funcEvalAvg + funcEvalCurve;
%     end
%     funcEvalAvg = funcEvalAvg / testMax;
%     save(optResFilename, 'optys', 'optxs', 'funcEvalAvg');
% end

%%
% L1 metric (without adaptive weights -> waw).
% optResFolder = 'testDECCG_L1_CentOS7_waw'; % run on CentOS 7
% for f = 1 : length(funcInds)
%     optResFilename = sprintf('%s/testDECCG_f%02d.mat', optResFolder, f);
%     load(optResFilename);
%     funcEvalAvg_ = zeros(5000000, 1);
%     curveLength = Inf * ones(1, testMax);
%     for t = 1 : testMax
%         funcEvalCurve = funcEvalCurves{t};
%         curveLength(t) = length(funcEvalCurve);
%         for c = 2 : length(funcEvalCurve)
%             if funcEvalCurve(c - 1) < funcEvalCurve(c)
%                 funcEvalCurve(c) = funcEvalCurve(c - 1);
%             end
%         end
%         if curveLength(t) >= size(funcEvalAvg_, 1) % unexpected length
%             funcEvalCurve = funcEvalCurve(1 : size(funcEvalAvg_, 1));
%         else
%             error('ERROR!');
%         end
%         funcEvalAvg_ = funcEvalAvg_ + funcEvalCurve;
%     end
%     funcEvalAvg_ = funcEvalAvg_ / testMax;
%     save(optResFilename, 'optys', 'optxs', 'funcEvalAvg_');
% end

%%
meanDECCGRepeat = Inf * ones(1, length(funcInds));
meanDECCGRepeat_ = Inf * ones(1, length(funcInds));
meanDECC_L1 = Inf * ones(1, length(funcInds));
meanDECC_L1_ = Inf * ones(1, length(funcInds));
for f = 1 : length(funcInds)
    optResFilename = sprintf('testDECCG_CentOS7/testDECCG_f%02d.mat', f);
    load(optResFilename);
    meanDECCGRepeat(f) = mean(optys);
    optResFilename = sprintf('testDECCG_CentOS7_waw/testDECCG_f%02d.mat', f);
    load(optResFilename);
    meanDECCGRepeat_(f) = mean(optys);
    optResFilename = sprintf('testDECCG_L1_CentOS7/testDECCG_f%02d.mat', f);
    load(optResFilename);
    meanDECC_L1(f) = mean(optys);
    optResFilename = sprintf('testDECCG_L1_CentOS7_waw/testDECCG_f%02d.mat', f);
    load(optResFilename);
    meanDECC_L1_(f) = mean(optys);
end

meanComp = [meanDECCG; ...
    meanDECCGRepeat; meanDECCGRepeat_; ...
    meanDECC_L1; meanDECC_L1_];

%%
% xFolder = 'testDECCG_CentOS7/testDECCG_f%02d.mat';
% yFolder = 'testDECCG_CentOS7_waw/testDECCG_f%02d.mat';

% xFolder = 'testDECCG_CentOS7/testDECCG_f%02d.mat';
% yFolder = 'testDECCG_L1_CentOS7/testDECCG_f%02d.mat';

% xFolder = 'testDECCG_CentOS7_waw/testDECCG_f%02d.mat';
% yFolder = 'testDECCG_L1_CentOS7_waw/testDECCG_f%02d.mat';
%  4: 8.27275261708908e-56 (70.3994008303297    [waw] vs. 8.94175059259894e-05 [L1waw])
%  5: 9.04340984391320e-45 (2792.15221403624    [waw] vs. 985.730207896399     [L1waw])
% 10: 2.35654077923863e-40 (1.19771387034034    [waw] vs. 1.03420727022296e-07 [L1waw])
% 11: 0.0198498501077987   (0.00482572095032130 [waw] vs. 1.33795197143627e-13 [L1waw])

% xFolder = 'testDECCG_L1_CentOS7/testDECCG_f%02d.mat';
% yFolder = 'testDECCG_L1_CentOS7_waw/testDECCG_f%02d.mat';

% xFolder = 'testDECCG_L1_CentOS7/testDECCG_f%02d.mat';
% yFolder = 'testDECCG_CentOS7_waw/testDECCG_f%02d.mat';

ttestComp = Inf * ones(2, length(funcInds));
ttest2Comp = Inf * ones(2, length(funcInds));
for f = 1 : length(funcInds)
    optResFilename = sprintf(xFolder, f);
    load(optResFilename);
    x = optys;
    optResFilename = sprintf(yFolder, f);
    load(optResFilename);
    y = optys;
    [ttestComp(1, f), ttestComp(2, f)] = ttest(x, y);
    [ttest2Comp(1, f), ttest2Comp(2, f)] = ttest2(x, y);
end

%%
for f = 1 : length(funcInds)
    figure(f);
    optResFilename = sprintf('testDECCG_CentOS7/testDECCG_f%02d.mat', f);
    load(optResFilename);
    plot(funcEvalAvg); hold on;
    optResFilename = sprintf('testDECCG_CentOS7_waw/testDECCG_f%02d.mat', f);
    load(optResFilename);
    plot(funcEvalAvg_); hold on;
    optResFilename = sprintf('testDECCG_L1_CentOS7/testDECCG_f%02d.mat', f);
    load(optResFilename);
    plot(funcEvalAvg); hold on;
    optResFilename = sprintf('testDECCG_L1_CentOS7_waw/testDECCG_f%02d.mat', f);
    load(optResFilename);
    plot(funcEvalAvg_); hold on;
    legend('DECCG', 'DECCGwaw', 'DECCG-L1', 'DECCG-L1waw');
end

%%
for f = 1 : length(funcInds)
    figure(100 + f);
    optResFilename = sprintf('testDECCG_CentOS7/testDECCG_f%02d.mat', f);
    load(optResFilename);
    semilogy(funcEvalAvg); hold on;
    optResFilename = sprintf('testDECCG_CentOS7_waw/testDECCG_f%02d.mat', f);
    load(optResFilename);
    semilogy(funcEvalAvg_);
    optResFilename = sprintf('testDECCG_L1_CentOS7/testDECCG_f%02d.mat', f);
    load(optResFilename);
    semilogy(funcEvalAvg); hold on;
    optResFilename = sprintf('testDECCG_L1_CentOS7_waw/testDECCG_f%02d.mat', f);
    load(optResFilename);
    semilogy(funcEvalAvg_); hold on;
    legend('DECCG', 'DECCGwaw', 'DECCG-L1', 'DECCG-L1waw');
end
