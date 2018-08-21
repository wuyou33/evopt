clear; clc;

% test correction of the program *PureCMAES* on function *cfSphere*.

%%
conFuncParams = ConFuncParams('cfSphere', 100, 100);
optAlgoParams = OptAlgoParams('PureCMAES', 5e6, 1);
testParams = TestParams(25, true, 24);
RunAlgo(conFuncParams, testParams, optAlgoParams);

%%
conFuncParams = ConFuncParams('cfSphere', 1000, 100);
optAlgoParams = OptAlgoParams('PureCMAES', 5e6, 1);
testParams = TestParams(25, true, 52);
RunAlgo(conFuncParams, testParams, optAlgoParams);
