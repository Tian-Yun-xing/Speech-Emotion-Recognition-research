function prepare_RAVDESS(random_flag,butter_flag,fc)
    addpath 'D:\Users\Y.H.Tian\Desktop\学习\UOG\Msc Project\code\Tian\SER_Library_Tian'
    audio_data_path = '/Users/Y.H.Tian/Desktop/学习/UOG/Msc Project/code/database/RAVDESS_16000'; 
    audio_ds =  audioDatastore(audio_data_path,'FileExtensions','.wav'); 
    audio = readall(audio_ds);
    audio_num = length(audio);
    fs = 16000;
    [b,a] = butter(6,fc/(fs/2));            % 6th order
    Address = '/Users/Y.H.Tian/Desktop/学习/UOG/Msc Project/code/database/Temp';
    if (random_flag == 1) && (butter_flag == 1)
        for i = 1:audio_num
            audio_in = audio(i);
            audio_in = audio_in{1};
            audio_in = awgn(audio_in,10,'measured');
            audio_out = filter(b,a,audio_in);
            file_name_old = audio_ds.Files{i}(end-23:end);
            file_name_new = [Address,'/',file_name_old];
            audiowrite(file_name_new, audio_out, 16000);
        end
    end
    if (random_flag == 1) && (butter_flag == 0)
        for i = 1:audio_num
            audio_in = audio(i);
            audio_in = audio_in{1};
            audio_in = awgn(audio_in,10,'measured');
            audio_out = audio_in;
            file_name_old = audio_ds.Files{i}(end-23:end);
            file_name_new = [Address,'/',file_name_old];
            audiowrite(file_name_new, audio_out, 16000);
        end
    end
    if (random_flag == 0) && (butter_flag == 1)
        for i = 1:audio_num
            audio_in = audio(i);
            audio_in = audio_in{1};
            %audio_in = awgn(audio_in,10,'measured');
            audio_out = filter(b,a,audio_in);
            file_name_old = audio_ds.Files{i}(end-23:end);
            file_name_new = [Address,'/',file_name_old];
            audiowrite(file_name_new, audio_out, 16000);
        end
    end
    if (random_flag == 0) && (butter_flag == 0)
        for i = 1:audio_num
            audio_in = audio(i);
            audio_in = audio_in{1};
            %audio_in = awgn(audio_in,10,'measured');
            audio_out = audio_in;
            file_name_old = audio_ds.Files{i}(end-23:end);
            file_name_new = [Address,'/',file_name_old];
            audiowrite(file_name_new, audio_out, 16000);
        end
    end
end