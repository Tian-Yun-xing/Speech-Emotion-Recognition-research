function feature_label = creat_feature_label(aFE)
    aFE_info = info(aFE);
    feature_label_type = fieldnames(aFE_info);
    feature_label_type_number = length(feature_label_type);
    aFE_info = struct2cell(aFE_info);

    feature_label = {};
    for i = 1:feature_label_type_number
        feature_label_col = length(aFE_info{i});
        for j = 1:feature_label_col
            feature_label = [feature_label, {[feature_label_type{i},int2str(j)]}]; %#ok<AGROW> 
        end
    end
    feature_label = [feature_label, {'Emotion'}];
end