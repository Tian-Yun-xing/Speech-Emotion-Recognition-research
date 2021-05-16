clear;              % clear all the workspace
clc;                % clear all the command window
addpath 'D:\Users\Y.H.Tian\Desktop\学习\UOG\Msc Project\code\Tian\SER_Library_Tian'
audio_data_path = '/Users/Y.H.Tian/Desktop/学习/UOG/Msc Project/code/database/RAVDESS_16000'; 
%audio_data_path = '/Users/Y.H.Tian/Desktop/学习/UOG/Msc Project/code/database/EMODB/wav'; 
audio_ds =  audioDatastore(audio_data_path,'FileExtensions','.wav');      

audio_in = read(audio_ds);

time = 1:length(audio_in);
time = time./16000;
%{
figure(1);
plot(time,audio_in,'r');
title('Original sound');
xlabel('Time (seconds)');
ylabel('Amplitude');
%}
fs = 16000;
audio_in_fft_all = abs(fft(audio_in)); 
audio_in_fft = audio_in_fft_all(1:length(audio_in_fft_all)/2+1);
f_axis_all = (0:length(audio_in)-1)*fs/length(audio_in);
f_axis = f_axis_all(1:length(audio_in_fft_all)/2+1);
figure(1)
plot(f_axis,audio_in_fft);
title('Frequecy domain of the RAVDESS utterance');
xlabel('Frequency'); 
ylabel('Amplitude');

pwrThreshold = -80;                 % adjust that
freqThreshold = 4000;

fs = 16000;
frameTime = 25e-3;
framelength = floor(frameTime*fs);
increment = floor(0.25 *framelength);
start_position = 1;
stop_position = framelength;
numFrames = 1+floor((length(audio_in)-framelength)/increment);
voicing = zeros(numFrames,1);               % have voice 1, no voice 0

%added
is_VAD_frame = zeros(1,numFrames);
is_VAD = zeros(1,length(audio_in));
%

energy_frame = zeros(1,length(time));

for i = 1: numFrames
    xFrame = audio_in(start_position:stop_position,1);
    voicing(i) = audiopluginexample.SpeechPitchDetector.isVoicedSpeech(xFrame,fs,pwrThreshold,freqThreshold);
    energy_frame(start_position:(start_position+increment+1)) = 10*log10(var(xFrame));
    for k = 1:length(energy_frame)
        if energy_frame(k) == -inf
            energy_frame(k) = -120;
        end
        if energy_frame(k) == 0
            energy_frame(k) = -120;
        end
    end
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
            is_VAD_frame(i) = 1;
        else
            audio_out(stop_position-increment:stop_position) = 0;
            audio_deleted(stop_position-increment:stop_position) = audio_in(stop_position-increment:stop_position);
            is_VAD_frame(i) = 0;
        end
    end            
    start_position = start_position + increment;
    stop_position = stop_position + increment;    
end

%sound(audio_in,fs); % original

for k = 1:length(is_VAD_frame)
    if is_VAD_frame(k) == 1
        is_VAD(1+increment*(k-1):framelength+increment*(k-1)) = 1;
    else
        is_VAD(1+increment*(k-1):framelength+increment*(k-1)) = 0;
    end
end


figure(2)
subplot(2,1,1)
plot(time,audio_in,'b')
title({'Illustration of the signal energy'});
xlabel('Time'); 
ylabel('Signal Amplitude');
subplot(2,1,2)
plot(time,energy_frame);
xlabel('Time'); 
ylabel('energy');


figure(3)
subplot(2,1,1)
plot(time,audio_in,'b')
title({'Illustration of the Voice Activity Detection process'});
xlabel('Time'); 
ylabel('Signal Amplitude');
subplot(2,1,2)
plot(time,is_VAD,'b');
xlabel('Time'); 
ylabel('VAD output');

%{
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
%}