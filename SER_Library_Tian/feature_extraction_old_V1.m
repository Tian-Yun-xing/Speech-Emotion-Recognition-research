function [audio_feature,info_out]= feature_extraction(audio_in, info_in, aFE, flag_zc)        % A function can extract feature automatically
    audio_feature = extract(aFE,audio_in);
    if flag_zc == 1
         audio_feature(:,length(audio_feature(1,:))+1) = ZCR(audio_in, length(aFE.Window), aFE.OverlapLength, length(audio_feature(:,1)));
    end
    audio_feature = num2cell(audio_feature);
    audio_feature(:,length(audio_feature(1,:))+1) = info_in.Label(1);                % put the emotion lable on       
    info_out = info_in;
end
