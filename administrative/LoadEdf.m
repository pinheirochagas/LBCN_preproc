FileName = '/Users/parvizilab/Desktop/Math Project/analysis_EcoG/neuralData/OriginalData/S15_87_RL/S15_87_RL_02/E15-282_0005.edf';
BlockName = 'S15_87_RL_02';
FolderName = '/Users/parvizilab/Desktop/Math Project/analysis_EcoG/neuralData/OriginalData/S15_87_RL/S15_87_RL_02';
mkdir(FolderName);
%A = readedf(FileName);

fp = fopen(FileName,'r','ieee-le');
if fp == -1,
  error('File not found ...!');
  return;
end

hdr = setstr(fread(fp,256,'uchar')');
header.length = str2num(hdr(185:192));
header.records = str2num(hdr(237:244));
header.duration = str2num(hdr(245:252));
header.channels = str2num(hdr(253:256));
header.channelname = setstr(fread(fp,[16,header.channels],'char')');
header.transducer = setstr(fread(fp,[80,header.channels],'char')');
header.physdime = setstr(fread(fp,[8,header.channels],'char')');
header.physmin = str2num(setstr(fread(fp,[8,header.channels],'char')'));
header.physmax = str2num(setstr(fread(fp,[8,header.channels],'char')'));
header.digimin = str2num(setstr(fread(fp,[8,header.channels],'char')'));
header.digimax = str2num(setstr(fread(fp,[8,header.channels],'char')'));
header.prefilt = setstr(fread(fp,[80,header.channels],'char')');
header.samplerate = str2num(setstr(fread(fp,[8,header.channels],'char')'));

fseek(fp,header.length,-1);
data = fread(fp,'int16');
fclose(fp);

return


%% 
SelectIds = [7:215];

D = reshape(data, header.samplerate(1), header.channels, header.records);
temp = zeros(header.channels, length(data)/header.channels);
for i=1:header.records
  temp(:,((i-1)*header.samplerate(1)+1):(i*header.samplerate(1))) = D(:,:,i)';
end
DComp = temp;

ElecName = cellstr(header.channelname);

StripDealer ={{'-Ref', ''}, {'POL ', ''}};
for i = 1:length(StripDealer)
    ElecName = strrep(ElecName, StripDealer{i}{1}, StripDealer{i}{2});
end


FileName = sprintf('%s/Pdio%s_01',FolderName, BlockName);
anlg = DComp(1,:);
save(FileName, 'anlg');

DComp = DComp(SelectIds,:);
for i = 1:length(SelectIds)
    FileName = sprintf('%s/iEEG%s_%02d',FolderName, BlockName,i);
    wave = downsample(DComp(i,:),10);
    save(FileName, 'wave');
end
Channel_label = ElecName(SelectIds);
FileName = sprintf('%s/Channel_Label_%s',FolderName, BlockName);
save(FileName, 'Channel_label');
