audioFolder = 'audios';

audioFiles = dir(fullfile(audioFolder, '*.*'));  
audioFiles = audioFiles(~cellfun('isempty', regexpi({audioFiles.name}, '\.(wav|mp3)$'))); 

%sliding window parameters
window_duration = 0.3;
hop_duration = 0.15;

for i = 1:length(audioFiles)
    audioFileName = fullfile(audioFolder, audioFiles(i).name);
    [audio, fs] = audioread(audioFileName);
    
    window_size = round(window_duration * fs);
    hop_size = round(hop_duration * fs);
    
    num_samples = length(audio);
    
    rms_values = [];
    window_start = 1;
    while window_start + window_size - 1 <= num_samples
        window_end = window_start + window_size - 1;
        segment = audio(window_start:window_end);
        
        rms = sqrt(mean(segment.^2));
        rms_values = [rms_values; rms];
        
        window_start = window_start + hop_size;
    end
    
    rms_threshold = prctile(rms_values, 75);
    
    loud_indices = find(rms_values > rms_threshold);
    loud_times = [(loud_indices - 1) * hop_duration, ...
                  (loud_indices - 1) * hop_duration + window_duration];
    
    fprintf('RMS Threshold for %s: %.4f\n', audioFiles(i).name, rms_threshold);
    fprintf('Loud segments in %s:\n', audioFiles(i).name);
    for j = 1:size(loud_times, 1)
        fprintf('Loud segment: %.2f - %.2f seconds\n', loud_times(j, 1), loud_times(j, 2));
    end
    
    %plots
    t = (0:length(audio)-1) / fs;
    figure;
    plot(t, audio, 'b');
    hold on;

    for j = 1:length(loud_indices)
        start_sample = round(loud_times(j, 1) * fs);
        end_sample = round(loud_times(j, 2) * fs);
        plot(t(start_sample:end_sample), audio(start_sample:end_sample), 'r');
    end

    yline(rms_threshold, 'g--', 'Threshold');
    
    title(['Waveform with RMS Threshold for ', audioFiles(i).name]);
    xlabel('Time (seconds)');
    ylabel('Amplitude');
    legend('Waveform', 'Louder Segments', 'Threshold');
    hold off;
    
    figure;
    time_axis = (0:length(rms_values)-1) * hop_duration + window_duration / 2;
    plot(time_axis, rms_values, '-o');
    hold on;
    yline(rms_threshold, 'g--', 'Threshold');
    hold off;
    title(['RMS Analysis for ', audioFiles(i).name]);
    xlabel('Time (seconds)');
    ylabel('RMS Value');
end
