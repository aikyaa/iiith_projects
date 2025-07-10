% List of training (bird) signals
trainingFiles = {'bird1.wav', 'bird2.wav', 'bird3.wav'}; % Replace with your bird file names

% List of test signals
testFiles = {'F1.wav', 'F2.wav', 'F3.wav', 'F4.wav', 'F5.wav', 'F6.wav', 'F7.wav', 'F8.wav'}; % Replace with test file names

% Initialize variables
trainingEnvelopes = cell(length(trainingFiles), 1); % To store envelopes of training signals
correlationTable = zeros(length(testFiles), length(trainingFiles)); % To store correlation values
results = zeros(length(testFiles), 1); % To store the predicted bird for each test signal

% Preprocess training signals
disp('Processing training signals...');
for i = 1:length(trainingFiles)
    [trainAudio, sampleRate] = audioread(trainingFiles{i});
    trainAudio = trainAudio / max(abs(trainAudio)); % Normalize amplitude
    trainingEnvelopes{i} = abs(hilbert(trainAudio)); % Compute envelope using Hilbert transform
    disp(['Processed: ', trainingFiles{i}]);
end

% Process and classify each test signal
disp('Classifying test signals...');
for j = 1:length(testFiles)
    [testAudio, sampleRate] = audioread(testFiles{j});
    testAudio = testAudio / max(abs(testAudio)); % Normalize amplitude
    testEnvelope = abs(hilbert(testAudio)); % Compute envelope using Hilbert transform

    % Initialize variables for correlation analysis
    maxSimilarity = -inf;
    predictedBird = 0;

    % Compare with each bird's signal
    for i = 1:length(trainingFiles)
        % Cross-correlation
        [corrVal, ~] = xcorr(testEnvelope, trainingEnvelopes{i}, 'normalized');
        [maxCorr, ~] = max(corrVal);

        % Store correlation value in the table
        correlationTable(j, i) = maxCorr;

        % Update prediction if similarity is higher
        if maxCorr > maxSimilarity
            maxSimilarity = maxCorr;
            predictedBird = i;
        end
    end

    % Store the predicted bird label
    results(j) = predictedBird;
    disp(['Test Signal ', testFiles{j}, ' classified as Bird ', num2str(predictedBird)]);
end

% Display the correlation table
disp('Correlation Table:');
disp('Rows -> Test Signals, Columns -> Birds');
disp(array2table(correlationTable, 'VariableNames', {'Bird1', 'Bird2', 'Bird3'}, ...
    'RowNames', testFiles));

% Display final classification results
disp('Final Classification Results:');
disp('Test Signal -> Predicted Bird');
for j = 1:length(testFiles)
    disp([testFiles{j}, ' -> Bird ', num2str(results(j))]);
end
