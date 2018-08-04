function [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center)


if strcmp(center, 'Stanford')

    sbj_name_split = strsplit(sbj_name, '_');
    sbj_number = str2num(sbj_name_split{2});


    if sbj_number < 48
        fs_iEEG = 3051.76;
        fs_Pdio = 24414.1;
        data_format = 'TDT';

    elseif (sbj_number > 47) && (sbj_number < 87)
        fs_iEEG = 1525.88;
        fs_Pdio = 24414.1;
        data_format = 'TDT';

    elseif sbj_number > 86
        fs_iEEG = 1000;
        fs_Pdio = 1000;
        data_format = 'edf';
    end

elseif strcmp(center, 'China')
    fs_iEEG = 2000;
    fs_Pdio = 2000;
    data_format = 'edf';
    
end

end