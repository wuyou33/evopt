clear; clc;

% test correction of the program *lsoDG*

%%
funcDim = 2;
conFuncParams = ConFuncParams(@(X)(feval('cfNashEq', X, 0.5)), funcDim, 100, -100);
[nonSepDims, sepDims, funcEvalNum] = lsoDG(conFuncParams, 1e-3);
disp(length(nonSepDims)); % 0
disp(length(sepDims)); % 2
disp(all(sepDims == 1 : funcDim)); % 1
disp(funcEvalNum); % 6

%%
funcDim = 100;
conFuncParams = ConFuncParams(@(X)(feval('cfNashEq', X, 0.5)), funcDim, 10, -10);
[nonSepDims, sepDims, funcEvalNum] = lsoDG(conFuncParams, 1e-3);
disp(length(nonSepDims)); % 0
disp(length(sepDims)); % 100
disp(all(sepDims == 1 : funcDim)); % 1
disp(funcEvalNum); % 10100

%%
funcDim = 1000;
conFuncParams = ConFuncParams(@(X)(feval('cfNashEq', X, 0.5)), funcDim, 100, -100);
[nonSepDims, sepDims, funcEvalNum] = lsoDG(conFuncParams, 1e-3);
disp(length(nonSepDims)); % 0
disp(length(sepDims)); % 1000
disp(all(sepDims == 1 : funcDim)); % 1
disp(funcEvalNum); % 1001000
