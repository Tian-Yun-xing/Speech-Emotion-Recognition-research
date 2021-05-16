function type_ds = creat_datastore_fit_type(audio_ds,type_location,Var0, Var1, Var2, Var3, Var4, Var5, Var6, Var7, Var8, Var9)
%% 
% parameters: 
% audio_ds is the datastore for all original database
% type_location is a number indicates where the info can be found in file
% name. for .wav, the last digit is 0 
% eg: 03a01Fa.wav,type_location for a is 0 and type_location for F is 1 
% what we want stored in Var0 - Var9, if just use sevearl Vars, others should be set to NA
%%
    audio_number = length(audio_ds.Files);
    type_flag = cell(1,audio_number);           % Creat a matrix for storing a flag for tpye information
    type_path = cell(0);                        % creat a cell for storing the path of the audio agree with the desired types
    
    for i = 1:audio_number 
        type_flag(i) = {audio_ds.Files{i}(end-4-type_location)};        % -4 represents ".wav", if database change (eg, to .jpeg), that must change 
        if (type_flag{i} == Var0) || (type_flag{i} == Var1) || (type_flag{i} == Var2) || (type_flag{i} == Var3) || (type_flag{i} == Var4) || (type_flag{i} == Var5) || (type_flag{i} == Var6) || (type_flag{i} == Var7) || (type_flag{i} == Var8) || (type_flag{i} == Var9)                                         
            type_path = [type_path audio_ds.Files(i)];%#ok<AGROW>       % store the paths for the audios fit the requirements
        end 
    end
    
    type_ds = audioDatastore(type_path);
end