clear; clc;

% NOTE that put this code in the folder which contains the file *dg.m*.
% Refer to * https://bitbucket.org/mno/differential-grouping *
% for the original MATLAB source code.

%%
fun = @(X, y)(feval('cfNashEq', X, 0.5));
options.ubound = 100;
options.lbound = -100;
options.dim = 2;
options.epsilon = 1e-3;
[seps, allgroups, FEs] = dg(fun, 1, options);
disp(length(allgroups)); % 0
disp(length(seps)); % 2
disp(all(seps' == 1 : options.dim)); % 1
disp(FEs); % 6

%%
fun = @(X, y)(feval('cfNashEq', X, 0.5));
options.ubound = 10;
options.lbound = -10;
options.dim = 100;
options.epsilon = 1e-3;
[seps, allgroups, FEs] = dg(fun, 1, options);
disp(length(allgroups)); % 0
disp(length(seps)); % 100
disp(all(seps' == 1 : options.dim)); % 1
disp(FEs); % 10100

%%
fun = @(X, y)(feval('cfNashEq', X, 0.5));
options.ubound = 100;
options.lbound = -100;
options.dim = 1000;
options.epsilon = 1e-3;
[seps, allgroups, FEs] = dg(fun, 1, options);
disp(length(allgroups)); % 0
disp(length(seps)); % 1000
disp(all(seps' == 1 : options.dim)); % 1
disp(FEs); % 1001000
