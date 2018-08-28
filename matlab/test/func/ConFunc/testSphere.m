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
disp(cfSphere(zeros(1, 1))'); % 0
disp(cfSphere_(zeros(1, 1))); % 0
disp(cfSphere_(zeros(1, 1)')); % 0
disp(cfSphere(zeros(3, 7))'); % 0 0 0
disp(cfSphere_(zeros(1, 7))); % 0
disp(cfSphere_(zeros(1, 7)')); % 0
disp(cfSphere(ones(5, 3))'); % 3 3 3 3 3
disp(cfSphere_(ones(1, 3))); % 3
disp(cfSphere_(ones(1, 3)')); % 3
disp(cfSphere(-ones(7, 3))'); % 3 3 3 3 3 3 3
disp(cfSphere_(-ones(1, 3))); % 3
disp(cfSphere_(-ones(1, 3)')); % 3
disp(cfSphere(X)'); % 0 5 5 5 55 55 54 8.55
y = zeros(1, size(X, 1));
for k = 1 : size(X, 1)
    y(k) = cfSphere_(X(k, :));
end
disp(y); % 0 5 5 5 55 55 54 8.55
y = zeros(1, size(X, 1));
for k = 1 : size(X, 1)
    y(k) = cfSphere_(X(k, :)');
end
disp(y); % 0 5 5 5 55 55 54 8.55
