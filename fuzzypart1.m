% Define the FIS
fis = mamfis('Name', 'BlowerSpeedControl');

% Define the input and output variables
inputVars = { 'RoomTemp', [0 40];  % Temperature input range
              'AirHumidity', [0 100] };  % Humidity input range
outputVars = { 'BlowerSpeed', [0 100] };  % Fan speed output range

% inlcude input variables
for i = 1:size(inputVars, 1)
    fis = addInput(fis, inputVars{i, 2}, 'Name', inputVars{i, 1});
end

% include output variable
fis = addOutput(fis, outputVars{1, 2}, 'Name', outputVars{1, 1});

% Define membership functions for RoomTemp
tempMFs = { 'Low', [-10 0 20];
            'Medium', [10 20 30];
            'High', [20 40 50] };

% include membership functions for RoomTemp
for i = 1:size(tempMFs, 1)
    fis = addMF(fis, 'RoomTemp', 'trimf', tempMFs{i, 2}, 'Name', tempMFs{i, 1});
end

% Define membership functions for AirHumidity
humidityMFs = { 'Low', [0 20 40];
                'Medium', [30 50 70];
                'High', [60 80 100] };

% include membership functions for AirHumidity
for i = 1:size(humidityMFs, 1)
    fis = addMF(fis, 'AirHumidity', 'trimf', humidityMFs{i, 2}, 'Name', humidityMFs{i, 1});
end

% Define membership functions for BlowerSpeed
blowerSpeedMFs = { 'Low', [0 25 50];
                   'Medium', [25 50 75];
                   'High', [50 75 100] };

% include membership functions for BlowerSpeed
for i = 1:size(blowerSpeedMFs, 1)
    fis = addMF(fis, 'BlowerSpeed', 'trimf', blowerSpeedMFs{i, 2}, 'Name', blowerSpeedMFs{i, 1});
end

% Define the rule matrix
rules = [1 1 1 1 1;
         1 2 2 1 1;
         1 3 3 1 1;
         2 1 1 1 1;
         2 2 2 1 1;
         2 3 3 1 1;
         3 1 2 1 1;
         3 2 3 1 1;
         3 3 3 1 1];

% inlcude rules to the FIS
fis = addRule(fis, rules);

% Save the FIS to a file
writeFIS(fis, 'BlowerSpeedControl');

% Plot membership functions
figure;
subplot(2,2,1);
plotmf(fis, 'input', 1);  % Plot RoomTemp membership functions
title('Membership Functions for RoomTemp');

subplot(2,2,2);
plotmf(fis, 'input', 2);  % Plot AirHumidity membership functions
title('Membership Functions for AirHumidity');

subplot(2,2,3);
plotmf(fis, 'output', 1);  % Plot BlowerSpeed membership functions
title('Membership Functions for BlowerSpeed');

% Generate the Control Surface plot
figure;
gensurf(fis);
title('Control Surface Plot');
xlabel('RoomTemp');
ylabel('AirHumidity');
zlabel('BlowerSpeed');

% Open the Rule Viewer
figure;
ruleview(fis);
title('Rule Viewer');
