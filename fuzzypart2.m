% Define benchmark functions
sphereFunc = @(x) sum(x.^2);
rastriginFunc = @(x) 10 * numel(x) + sum(x.^2 - 10 * cos(2 * pi * x));
griewankFunc = @(x) 1 + sum(x.^2 / 4000) - prod(cos(x ./ sqrt(1:numel(x))));

% Store benchmark functions and their names
benchmarkFuncs = {sphereFunc, rastriginFunc, griewankFunc};
funcNames = {'Sphere', 'Rastrigin', 'Griewank'};

% Define dimensions to test
testDimensions = [2, 10];

% Number of runs for averaging
numOfRuns = 15;

% Initialize structure to store results
results = struct();

% Loop over each benchmark function
for funcIdx = 1:numel(benchmarkFuncs)
    currentFunc = benchmarkFuncs{funcIdx};
    currentFuncName = funcNames{funcIdx};
    
    % Loop over each dimension
    for dimIdx = 1:numel(testDimensions)
        numDims = testDimensions(dimIdx);
        
        % Initialize performance data storage
        perfData = struct('GA', [], 'PSO', [], 'SA', []);
        
        % Perform optimization runs
        for runIdx = 1:numOfRuns
            % Genetic Algorithm (GA) optimization
            gaOptions = optimoptions('ga', 'Display', 'off');
            [~, gaVal] = ga(currentFunc, numDims, [], [], [], [], [], [], [], gaOptions);
            perfData.GA = [perfData.GA; gaVal];
            
            % Particle Swarm Optimization (PSO)
            psoOptions = optimoptions('particleswarm', 'Display', 'off');
            [~, psoVal] = particleswarm(currentFunc, numDims, [], [], psoOptions);
            perfData.PSO = [perfData.PSO; psoVal];
            
            % Simulated Annealing (SA) optimization
            saOptions = saoptimset('Display', 'off');
            [~, saVal] = simulannealbnd(currentFunc, rand(1, numDims), [], [], saOptions);
            perfData.SA = [perfData.SA; saVal];
        end
        
        % Store performance data
        results.(currentFuncName).(sprintf('Dim%d', numDims)).GA = perfData.GA;
        results.(currentFuncName).(sprintf('Dim%d', numDims)).PSO = perfData.PSO;
        results.(currentFuncName).(sprintf('Dim%d', numDims)).SA = perfData.SA;
        
        % Display results
        fprintf('Benchmark Function: %s, Dimensions: %d\n', currentFuncName, numDims);
        fprintf('GA - Mean: %.4f, Std: %.4f, Best: %.4f, Worst: %.4f\n', ...
            mean(perfData.GA), std(perfData.GA), min(perfData.GA), max(perfData.GA));
        fprintf('PSO - Mean: %.4f, Std: %.4f, Best: %.4f, Worst: %.4f\n', ...
            mean(perfData.PSO), std(perfData.PSO), min(perfData.PSO), max(perfData.PSO));
        fprintf('SA - Mean: %.4f, Std: %.4f, Best: %.4f, Worst: %.4f\n', ...
            mean(perfData.SA), std(perfData.SA), min(perfData.SA), max(perfData.SA));
        
        % Plot performance comparison
        figure;
        hold on;
        plot(perfData.GA, '-o', 'DisplayName', 'GA');
        plot(perfData.PSO, '-x', 'DisplayName', 'PSO');
        plot(perfData.SA, '-s', 'DisplayName', 'SA');
        xlabel('Run Number');
        ylabel('Objective Value');
        title(sprintf('Performance Comparison on %s Function (Dim=%d)', currentFuncName, numDims));
        legend show;
        hold off;
    end
end
