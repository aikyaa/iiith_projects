fs=128;
signal_data=load('E3.mat');
signal = signal_data.E3;

figure;
t = linspace(0,length(signal)/fs,length(signal));
plot(t,signal);
title("signal E3");
xlabel("Time (s)");
ylabel("Amplitude");

figure(2);
f = linspace(- fs/2, fs/2, length(signal));
plot(f,fftshift(abs(fft(signal))));
title("spectrum of E3");
xlabel("Hz");
ylabel("Amplitude");

%preprocessing
signal_noDC = signal - mean(signal);

%filtering out noise due to interference from power grid
f_notch1 = 22;  
Q=40;
wo1 = f_notch1 / (fs / 2);
bw1 = wo1 / Q;
[b_notch1, a_notch1] = iirnotch(wo1, bw1);

f_notch2 = 50;
wo2 = f_notch2 / (fs / 2); 
bw2 = wo2 / Q;
[b_notch2, a_notch2] = iirnotch(wo2, bw2);

signal_filtered1 = filter(b_notch1, a_notch1, signal);
signal_filtered3 = filter(b_notch2, a_notch2, signal_filtered1);
signal_filtered3=signal_filtered3(:);
diff_signal = diff(signal_filtered3);
diff_signal = [diff_signal; 0]; 
squared_signal = diff_signal .^ 2;
window_size = round(0.15 * fs);
signal_filtered2 = movmean(squared_signal, window_size);
adaptive_threshold = 0.5 * max(signal_filtered2);

figure(3);
t = linspace(0,length(signal_filtered2)/fs,length(signal_filtered2));
plot(t,signal_filtered2);
title("filtered signal E3");
xlabel("Time (s)");
ylabel("Amplitude");

figure(4);
f = linspace(- fs/2, fs/2, length(signal_filtered2));
plot(f,fftshift(abs(fft(signal_filtered2))));
title("spectrum of filtered signal");
xlabel("Hz");
ylabel("Amplitude");

[~, R_locs] = findpeaks(signal_noDC, 'MinPeakHeight', adaptive_threshold, 'MinPeakDistance', fs * 0.6, MinPeakProminence=0.2); 
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
title('Heart Rate Estimation for E3');
