%% Read the first sample from RAVDESS
clear;              % clear all the workspace
clc;                % clear all the command window
addpath 'D:\Users\Y.H.Tian\Desktop\学习\UOG\Msc Project\code\Tian\SER_Library_Tian'
audio_data_path = '/Users/Y.H.Tian/Desktop/学习/UOG/Msc Project/code/database/RAVDESS_16000'; 
audio_ds =  audioDatastore(audio_data_path,'FileExtensions','.wav');      
audio_in = read(audio_ds);
%% Time domian, original data
time = 1:length(audio_in);
time = time./16000;
figure(1);
plot(time,audio_in,'b');
title('Original sound');
xlabel('Time (seconds)');
ylabel('Amplitude');
%% Time domain, filtered data
%------------
fc = 500; % cut off frequency, can be adjusted
%------------
fs = 16000;
[b,a] = butter(6,fc/(fs/2));
audio_filtered = filter(b,a,audio_in);
figure(2);
plot(time,audio_filtered,'b');
title('filtered sound');
xlabel('Time (seconds)');
ylabel('Amplitude');
%% listen difference
sound(audio_in,fs)
sound(audio_filtered,fs)
%% Frequency domian, original data
audio_in_fft_all = abs(fft(audio_in)); 
audio_in_fft = audio_in_fft_all(1:length(audio_in_fft_all)/2+1);
f_axis_all = (0:length(audio_in)-1)*fs/length(audio_in);
f_axis = f_axis_all(1:length(audio_in_fft_all)/2+1);
figure(3)
plot(f_axis,audio_in_fft);
title('orginal sound');
xlabel('Frequency'); 
ylabel('Amplitude');
%% Frequency domian, filtered data
audio_filtered_fft_all = abs(fft(audio_filtered)); 
audio_filtered_fft = audio_filtered_fft_all(1:length(audio_filtered_fft_all)/2+1);
f_axis_all = (0:length(audio_filtered)-1)*fs/length(audio_filtered);
f_axis = f_axis_all(1:length(audio_filtered_fft_all)/2+1);
figure(4)
plot(f_axis,audio_filtered_fft);
title('filtered sound');
xlabel('Frequency'); 
ylabel('Amplitude');
%% Save the audio
audiowrite('d:\Users\Y.H.Tian\Desktop\学习\UOG\Msc Project\code\Tian\After_Butter.wav',audio_filtered,fs);
audiowrite('d:\Users\Y.H.Tian\Desktop\学习\UOG\Msc Project\code\Tian\Before_Butter.wav',audio_in,fs);