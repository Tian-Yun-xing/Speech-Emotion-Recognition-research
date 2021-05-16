function audio_ds = put_emotion_labels(audio_ds)
    audio_number = length(audio_ds.Files);                  % get how many audio files in the datastore
    emotion_labels = cell(1,audio_number);                  % Create a empty matrix (cell) for emotion information of the audio files
    for i = 1:audio_number                                  % get the emotion info for each audio file one by one      
        switch (audio_ds.Files{i}(end-4-1))                 % Extract the sixth digit from the file name, for it is emotion info for EMODB                                                            
            case 'W'                                        % use more readable infomation in english according to the documentation of the audio database
                emotion_labels(i) = {'anger'};
            case 'L'
                emotion_labels(i) = {'boredom'};
            case 'E'
                emotion_labels(i) = {'disgust'};
            case 'A'
                emotion_labels(i) = {'fear'};
            case 'F'
                emotion_labels(i) = {'happiness'};
            case 'T'
                emotion_labels(i) = {'sadness'};
            case 'N'
                emotion_labels(i) = {'neutral'};
            otherwise
                switch (audio_ds.Files{i}(end-4-12))        % 12th digit for RAVDESS
                    case '1'
                        emotion_labels(i) = {'neutral'};
                    case '2'
                        emotion_labels(i) = {'calm'};
                    case '3'
                        emotion_labels(i) = {'happiness'};    
                    case '4'
                        emotion_labels(i) = {'sadness'};      
                    case '5'
                        emotion_labels(i) = {'anger'};
                    case '6'
                        emotion_labels(i) = {'fear'};
                    case '7'
                        emotion_labels(i) = {'disgust'};
                    case '8'
                        emotion_labels(i) = {'surprised'};
                    otherwise
                        switch (audio_ds.Files{i}(end-4-2))        % for SAVEE
                            case 'n'
                                emotion_labels(i) = {'neutral'};
                            case 'h'
                                emotion_labels(i) = {'happiness'};    
                            case 's'
                                emotion_labels(i) = {'sadness'};      
                            case 'a'
                                emotion_labels(i) = {'anger'};
                            case 'f'
                                emotion_labels(i) = {'fear'};
                            case 'd'
                                emotion_labels(i) = {'disgust'};
                            otherwise
                                emotion_labels(i) = {nan};
                        end                        
                end
        end
    end
    audio_ds.Labels = emotion_labels;                   % put the lables       
end