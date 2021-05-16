clear;              % clear all the workspace
clc;                % clear all the command window
addpath 'D:\Users\Y.H.Tian\Desktop\学习\UOG\Msc Project\code\Tian\SER_Library_Tian'

audio_data_path = '/Users/Y.H.Tian/Desktop/学习/UOG/Msc Project/code/database/RAVDESS_16000'; 
audio_ds =  audioDatastore(audio_data_path,'FileExtensions','.wav');      

audio_in = read(audio_ds);

time = 1:length(audio_in);
time = time./16000;
figure(1);
plot(time,audio_in,'r');
title('Original sound');
xlabel('Time (seconds)');
ylabel('Amplitude');

pwrThreshold = -50;                 % adjust that
freqThreshold = 1000;

fs = 16000;
frameTime = 25e-3;
framelength = floor(frameTime*fs);
increment = floor(0.25 *framelength);
start_position = 1;
stop_position = framelength;
numFrames = 1+floor((length(audio_in)-framelength)/increment);
voicing = zeros(numFrames,1);               % have voice 1, no voice 0

for i = 1: numFrames
    xFrame = audio_in(start_position:stop_position,1);
    voicing(i) = audiopluginexample.SpeechPitchDetector.isVoicedSpeech(xFrame,fs,pwrThreshold,freqThreshold);
    if i == 1
        if voicing(i) == 1
            audio_out(start_position:stop_position) = audio_in(start_position:stop_position);
            audio_deleted(start_position:stop_position) = 0;
        else
            audio_out(start_position:stop_position) = 0;
            audio_deleted(start_position:stop_position) = audio_in(start_position:stop_position);
        end
    else
        if voicing(i) == 1
            audio_out(stop_position-increment:stop_position) = audio_in(stop_position-increment:stop_position);
            audio_deleted(stop_position-increment:stop_position) = 0;
        else
            audio_out(stop_position-increment:stop_position) = 0;
            audio_deleted(stop_position-increment:stop_position) = audio_in(stop_position-increment:stop_position);
        end
    end            
    start_position = start_position + increment;
    stop_position = stop_position + increment;    
end

%sound(audio_in,fs); % original

figure(2);
plot(time(1:length(audio_out)),audio_out,'b');
title('Sound after VAD');
xlabel('Time (seconds)');
ylabel('Amplitude');

figure(3);
plot(time(1:length(audio_out)),audio_deleted,'g');
title('Sound deleted by VAD');
xlabel('Time (seconds)');
ylabel('Amplitude');

sound(audio_out,fs); % after voice detection

%sound(audio_deleted,fs) % deleted by voice detection

audiowrite('d:\Users\Y.H.Tian\Desktop\学习\UOG\Msc Project\code\Tian\voicing.wav',audio_out,fs);
audiowrite('d:\Users\Y.H.Tian\Desktop\学习\UOG\Msc Project\code\Tian\original.wav',audio_in,fs);
audiowrite('d:\Users\Y.H.Tian\Desktop\学习\UOG\Msc Project\code\Tian\deleted.wav',audio_deleted,fs);