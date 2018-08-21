function testParams = TestParams(testNum, testPrintLog, testSeeds)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
% Test Parameters.
%
% ---------------
% INPUT       <<<
% ---------------
%   testNum     : int scalar, the number of tests (default: 30)
%   testPrintLog: boolean scalar, print the verbose log information on the console (default: true)
%   testSeeds   : vector of length *testNum*, the random seeds to initialize the population
%
% ---------------
% OUTPUT      >>>
% ---------------
%   testParams  : struct, test parameters
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
switch nargin % syntactic sugar
    case 3
        if testSeeds < 0
            error('all random seeds should be larger than or equal to 0.');
        end
        if isscalar(testSeeds) && isnumeric(testSeeds) && numel(testSeeds) == 1
            testSeeds = randi(RandStream('mt19937ar', 'Seed', testSeeds), intmax, 1, testNum);
        end
    case 2
        testSeed = str2double(datestr(now, 'yyyymmdd'));
        testSeeds = randi(RandStream('mt19937ar', 'Seed', testSeed), intmax, 1, testNum);
    case 1
        testPrintLog = true;
        testSeed = str2double(datestr(now, 'yyyymmdd'));
        testSeeds = randi(RandStream('mt19937ar', 'Seed', testSeed), intmax, 1, testNum);
    otherwise
        testNum = 30;
        testPrintLog = true;
        testSeed = str2double(datestr(now, 'yyyymmdd'));
        testSeeds = randi(RandStream('mt19937ar', 'Seed', testSeed), intmax, 1, testNum);
end

if ~isscalar(testNum) || ~isnumeric(testNum) || testNum <= 0
    error('the total number of tests should be larger than 0.');
end
if ~isscalar(testPrintLog) || ~islogical(testPrintLog)
    error('*testPrintLog* should be a logical-type value (true or false).');
end
if ~isnumeric(testSeeds) || any(testSeeds < 0)
    error('all random seeds should be larger than or equal to 0.');
end
if numel(testSeeds) ~= testNum
    error('the total number of rand seeds should be equal to the total number of tests.');
end

% For the reproducibility of numerical experiments, it's necessary to set a
% different random seed to initialize the population for each test.
% It means that when plotting the convergence curve figure, at least the
% same starting point could be obtained even for different optimization
% algorithms on each test. NOTE that set different random seeds to
% initialize the population for different tests.

testParams = struct(...
    'testNum', testNum, ...
    'testPrintLog', testPrintLog, ...
    'testSeeds', testSeeds);
end
