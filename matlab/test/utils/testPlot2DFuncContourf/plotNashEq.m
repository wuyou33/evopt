clear; clc;

%%
figure(1);
conFuncParams = ConFuncParams(@(X) (cfNashEq(X, 0.5)), 2, 100);
colorSet = cool;
plot2DFuncContourf(conFuncParams, 0 : 2.5 : 20, false, colorSet, 600);
% plot([-100 100], [-100 100], 'k', 'LineWidth', 5); hold on;
% plot([-100 100], [100 -100], 'k', 'LineWidth', 5); hold on;
colorbar; axis equal; hold off;
% set(gca, 'xticklabel', {[]});
% set(gca, 'yticklabel', {[]});
xlabel('X');
ylabel('Y');

%%
figure(2);
conFuncParams = ConFuncParams(@(X) (cfNashEq(X, 1.0)), 2, 100);
colorSet = cool;
plot2DFuncContourf(conFuncParams, 0 : 25 : 200, false, colorSet, 600);
colorbar; axis equal; hold off;
% set(gca, 'xticklabel', {[]});
% set(gca, 'yticklabel', {[]});
xlabel('X');
ylabel('Y');

%%
figure(3);
conFuncParams = ConFuncParams(@(X) (cfNashEq(X, 2.0)), 2, 100);
colorSet = cool;
plot2DFuncContourf(conFuncParams, 0 : 4e3 : 3e4, false, colorSet, 600);
% plot(0, 0, 'ok', 'MarkerFaceColor', 'k', 'LineWidth', 5); hold on;
colorbar; axis equal; hold off;
% set(gca, 'xticklabel', {[]});
% set(gca, 'yticklabel', {[]});
xlabel('X');
ylabel('Y');
