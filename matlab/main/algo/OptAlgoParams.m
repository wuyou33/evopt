function optAlgoParams = OptAlgoParams(algoName, algoFuncEvalMax, algoPopSize)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Optimization Algorithm Parameters.
%
% ---------------
% INPUT       <<<
% ---------------
%   algoName       : string scalar, algorithm name
%   algoFuncEvalMax: int scalar, function evaluation maximum
%   algoPopSize    : int scalar, population size
%
% ---------------
% OUTPUT      >>>
% ---------------
%   optAlgoParams: struct, algorithm parameters
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
if ~ischar(algoName)
    error('algorithm name should be char.');
end
if ~isscalar(algoFuncEvalMax) || ~isnumeric(algoFuncEvalMax) || numel(algoFuncEvalMax) ~= 1 || algoFuncEvalMax <= 0
    error('function evaluation maximum should be larger than 0.');
end
if ~isscalar(algoPopSize) || ~isnumeric(algoPopSize) || numel(algoPopSize) ~= 1 || algoPopSize <= 0
    error('population size should be larger than 0.');
end

algoIterMax = ceil(algoFuncEvalMax / algoPopSize); % iteration maximum
algoInitSeed = [];  % random seed to initialize the population

optAlgoParams = struct(...
    'algoName', algoName, ...
    'algoFuncEvalMax', algoFuncEvalMax, ...
    'algoPopSize', algoPopSize, ...
    'algoIterMax', algoIterMax, ...
    'algoInitSeed', algoInitSeed);
end
