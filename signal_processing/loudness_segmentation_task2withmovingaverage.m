audioFolder = 'audios';
textFolder = 'text';

audioFiles = dir(fullfile(audioFolder, '*.*'));  
audioFiles = audioFiles(~cellfun('isempty', regexpi({audioFiles.name}, '\.(wav|mp3)$'))); 
textFiles = dir(fullfile(textFolder, '*.txt'));

%parameters for moving average
moving_avg_window =0.3;

for i = 1:length(audioFiles)
    audioFileName = fullfile(audioFolder, audioFiles(i).name);
    [audio, fs] = audioread(audioFileName);
    
    textFileName = fullfile(textFolder, textFiles(i).name);
    fileID = fopen(textFileName, 'r');
    data = textscan(fileID, '%s %f %f %d');
    fclose(fileID);

    words = data{1};
    start_times = data{2};
    end_times = data{3};
    loudness_indicator = data{4};

    absolute_mean = sum(abs(audio)) / length(audio);

    %calculating RMS for each segment
    rms_values = zeros(length(words), 1);
    for j = 1:length(words)
        start_sample = round(start_times(j) * fs);
        end_sample = round(end_times(j) * fs);
        segment = audio(start_sample:end_sample);
        
        rms_values(j) = sqrt(mean(segment.^2));
    end

    rms_smoothed = movmean(rms_values, moving_avg_window);
    
    rms_threshold = mean(rms_smoothed) + 0.3 * std(rms_smoothed);
    
    louder_indices = find(loudness_indicator == 1 & rms_smoothed > rms_threshold);
    
    louder_times = [start_times(louder_indices), end_times(louder_indices)];
    
    %plots
    t = (0:length(audio)-1) / fs;
    figure;
    plot(t, audio, 'b');
    hold on;

    for j = 1:length(louder_indices)
        start_sample = round(louder_times(j, 1) * fs);
        end_sample = round(louder_times(j, 2) * fs);
        plot(t(start_sample:end_sample), audio(start_sample:end_sample), 'r');
    end

    yline(rms_threshold, 'g--', 'Threshold');
    
    title(['Waveform with RMS Threshold for ', audioFiles(i).name]);
    xlabel('Time (seconds)');
    ylabel('Amplitude');
    legend('Waveform', 'Louder Segments', 'Threshold');
    hold off;

    fprintf('Absolute Mean for file %s: %.4f\n', textFiles(i).name, absolute_mean);
    fprintf('Avg RMS for file %s (smoothed): %.4f\n', textFiles(i).name, mean(rms_smoothed));
    fprintf('Louder words in %s:\n', textFiles(i).name);
    for k = 1:length(louder_indices)
        fprintf('%s (%.2f - %.2f seconds)\n', words{louder_indices(k)}, louder_times(k, 1), louder_times(k, 2));
    end
end
