function [audio_feature,info_out]= feature_extraction_voicing_control(pwrThreshold, freqThreshold, audio_in, info_in, aFE)        % A function can extract feature automatically
    audio_feature = extract(aFE,audio_in);
    audio_feature = num2cell(audio_feature);
    audio_feature(:,length(audio_feature(1,:))+1) = info_in.Label(1);                % put the emotion lable on
    
    %pwrThreshold = -50;     % Frames with power below this threshold (in dB) are likely to be silence
    %freqThreshold = 1000;   % Frames with zero crossing rate above this threshold (in Hz) are likely to be silence or unvoiced speech
    
    %fs = 16000;
    fs = aFE.SampleRate;
    %frameTime = 25e-3;
    %framelength = floor(frameTime*fs);
    framelength = length(aFE.Window);
    %increment = floor(0.25 *framelength);
    increment = framelength - aFE.OverlapLength;
    start_position = 1;
    stop_position = framelength;
    numFrames = length(audio_feature(:,1));
    voicing = zeros(numFrames,1);
    
    for i = 1: numFrames
        xFrame = audio_in(start_position:stop_position,1);
        voicing(i) = audiopluginexample.SpeechPitchDetector.isVoicedSpeech(xFrame,fs,pwrThreshold,freqThreshold);
    
        start_position = start_position + increment;
        stop_position = stop_position + increment;    
    end
    
    audio_feature((voicing == 0),:) = [];
    
    info_out = info_in;
end
