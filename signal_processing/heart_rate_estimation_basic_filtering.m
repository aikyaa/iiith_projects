fs=128;
signal_data=load('E2.mat');
signal = signal_data.E2;

figure;
t = linspace(0,length(signal)/fs,length(signal));
plot(t,signal);
title("signal E2");
xlabel("Time (s)");
ylabel("Amplitude");

figure(2);
f = linspace(- fs/2, fs/2, length(signal));
plot(f,fftshift(abs(fft(signal))));
title("spectrum of E2");
xlabel("Hz");
ylabel("Amplitude");

%preprocessing
signal_noDC = signal - mean(signal);

%filtering out noise

f_cutoff = 20; 
w_cutoff = f_cutoff / (fs / 2);
[b, a] = butter(2, w_cutoff, "low");
signal_filtered2 = filtfilt(b, a, signal_noDC);

figure(3);
t = linspace(0,length(signal_filtered2)/fs,length(signal_filtered2));
plot(t,signal_filtered2);
title("filtered signal E2");
xlabel("Time (s)");
ylabel("Amplitude");

figure(4);
f = linspace(- fs/2, fs/2, length(signal_filtered2));
plot(f,fftshift(abs(fft(signal_filtered2))));
title("spectrum of filtered signal");
xlabel("Hz");
ylabel("Amplitude");

[~, R_locs] = findpeaks(signal_noDC, 'MinPeakHeight', 0.5, 'MinPeakDistance', fs * 0.6, MinPeakProminence=0.15); 
%we choose 0.6 because the normal range for heart rate is between 60 and
%100 which corresponds to 1s to 0.6s

R_intervals = diff(R_locs) / fs; %converting to seconds
%Rlocs contain the indices of R peaks detected

HR = 60 ./ R_intervals; %number of beats per minute

time_HR = (R_locs(2:end) / fs)/60; % Time points representing the occurances of R-peaks, in minutes


% Smoothen out HR curve using a moving average filter 
HR_smoothed = movmean(HR, 10);

figure(5);
plot(time_HR, HR_smoothed);
xlabel('Time (s)');
ylabel('Heart Rate (BPM)');
title('Heart Rate Estimation for E2');
