function zcr_result = ZCR(audio_in, framelength, overlapLength, numFrames)

start_position = 1;
stop_position = framelength;
increment = framelength - overlapLength;
zcr_result_temp = zeros(numFrames,1);
for i = 1: numFrames
    xFrame = audio_in(start_position:stop_position,1);
    zcr_result_temp(i) = sum(abs(diff(xFrame>0)))/length(xFrame);
    start_position = start_position + increment;
    stop_position = stop_position + increment;    
end
zcr_result = zcr_result_temp;
end
