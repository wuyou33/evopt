%%
clear; clc;

%% test data
X = [0.0 0.0 0.0 0.0 0.0; ...
    1.0 1.0 1.0 1.0 1.0; ...
    -1.0 -1.0 -1.0 -1.0 -1.0; ...
    1.0 -1.0 1.0 -1.0 1.0; ...
    1.0 2.0 3.0 4.0 5.0; ...
    1.0 -2.0 3.0 -4.0 5.0; ...
    5.0 4.0 3.0 2.0 0.0; ...
    1.1 1.2 1.3 1.4 -1.5];

%% test correction

funcHandler = @(X) (cfNashEq(X, 1));
funcHandler_ = @(x) (cfNashEq_(x, 1));

disp(funcHandler(zeros(3, 7))'); % 0 0 0
disp(funcHandler_(zeros(1, 7))); % 0
disp(funcHandler_(zeros(1, 7)')); % 0
disp(funcHandler(ones(5, 3))'); % 4 4 4 4  4
disp(funcHandler_(ones(1, 3))); % 4
disp(funcHandler_(ones(1, 3)')); % 4
disp(funcHandler(-ones(7, 3))'); % 4 4 4 4 4 4 4
disp(funcHandler_(-ones(1, 3))); % 4
disp(funcHandler_(-ones(1, 3)')); % 4
disp(funcHandler(X)'); % 0 8 8 8 28 28 40 10.8
y = zeros(1, size(X, 1));
for k = 1 : size(X, 1)
    y(k) = funcHandler_(X(k, :));
end
disp(y); % 0 8 8 8 28 28 40 10.8
y = zeros(1, size(X, 1));
for k = 1 : size(X, 1)
    y(k) = funcHandler_(X(k, :)');
end
disp(y); % 0 8 8 8 28 28 40 10.8
