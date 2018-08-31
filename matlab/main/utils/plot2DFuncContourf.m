function [] = plot2DFuncContourf(conFuncParams, contourLine, ...
    isLabel, colorMap, sampleNum)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Plot the 2-Dimensional Function Contour for the Continuous Function.
%
% ---------------
% INPUT       <<<
% ---------------
%   conFuncParams: struct, parameters for the continuous function optimized
%   contourLine  : vector, monotonically increasing contour lines specified
%   isLabel      : logical scalar, whether to show the contour label (default: false)
%   colorMap     : *colormap*
%   sampleNum    : int scalar, number of samples
%
% ---------------
% OUTPUT      >>>
% ---------------
%   a 2-d function contour (*hold on*)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
funcName = conFuncParams.funcName;
if ischar(funcName)
    funcName = str2func(funcName);
end

if nargin ~= 5
    sampleNum = 100;
end

if nargin >= 4
    if ~isempty(colorMap)
        colormap(colorMap);
    end
elseif nargin < 4
    colorSet = cool; % a preferred colormap
    colormap(colorSet);
end

if nargin < 3
    isLabel = false;
end
if ~isscalar(isLabel) || ~islogical(isLabel)
    error('*isLabel* should be a logical value.');
end

x = linspace(conFuncParams.funcLowerBounds(1), ...
    conFuncParams.funcUpperBounds(1), sampleNum);
y = linspace(conFuncParams.funcLowerBounds(2), ...
    conFuncParams.funcUpperBounds(2), sampleNum);
[X, Y] = meshgrid(x, y);
Z = Inf * ones(size(X));
for r = 1 : size(X, 1)
    for c = 1 : size(X, 2)
        Z(r, c) = feval(funcName, [X(r, c), Y(r, c)]);
    end
end

if nargin < 2
    contourf(X, Y, Z, 'EdgeColor', 'white', 'LineWidth', 1.5); hold on;
else
    if any(diff(contourLine) <= 0)
        error('contour lines specified should be monotonically increasing');
    end
    
    if isLabel
        [C, h] = contourf(X, Y, Z, contourLine, ...
            'ShowText', 'on', 'EdgeColor', 'white', 'LineWidth', 1.5); hold on;
        clabel(C, h, 'FontSize', 12, 'Color', 'white');
    else
        contourf(X, Y, Z, contourLine, ...
            'EdgeColor', 'white', 'LineWidth', 1.5); hold on;
    end
end
end
