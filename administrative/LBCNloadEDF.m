function LBCNloadEDF(FileName, varargin)

% LBCNloadEDF aims seamlessly to adopt the New NK system as previous TDT system. It helps to load an edf file and save the mat files for each electrodes and pdio with a table of channel labels
% This function also controls the memory load in order to prevent system from overloading and crashing. 
%
% The future version will be able to change the order of channel for matching the ECoG label order.
%
% A. All the files will be created under the folder "FolderName". 
%    (1). Pdio[Block_Name]_02.mat
%    (2). iEEG[Block_Name]_0X.mat (for all the channels)
%    (3). Channel_Label[Block_Name].mat
% B. Sampling Rate
%    (1). Pdio will be stored in the same sampling rate as recording(10,000 Hz)
%    (2). All the other channels will be downsampled (by @decimate, IIR filter) by the factor of 10 (to 1,000 Hz)  
% C. Normalization
%    (1). The pdio will be normalized to [0, 1] for farther processing (Amy)
%         0: is set for the bottom line, rather than the minimum
%         0: is set for the upper line (plateau), rather than the maximum
%
% Code Example:
%   FileName = 'E15-282_0012.edf';
%   BlockName = 'RL_12';
%   FolderName = './SandraClassroomRL12';
%   LBCNloadEDF(FileName, 'BlockName', BlockName, 'FolderName', FolderName);

% Default value & Acquire the input value
BlockName = 'S15_87_RL_04';
FolderName = './AmyMMR02';
SelectIds = [];

% hidden variable
IsElecSelec = 0;
GB1 = 1000000000;
[~, TempMem] = memory;
MemoryMax = TempMem.PhysicalMemory.Available/GB1/3; %  

assignopts(who, varargin);
mkdir(FolderName);

if ~isempty(SelectIds)
    IsElecSelec = 1;
end
% Read the Header of EDF file in order to determine the data loading
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

fseek(fp, 0,'eof');
FileLen = ftell(fp);
DataLen = FileLen - header.length;

% Load the data by determining the size of temporary stored data for
% reducing the RAM load
GB2Doub = GB1*2/8;
RecChunk = floor(GB2Doub/(header.channels*header.samplerate(1)));
NumTempData = ceil(header.records/RecChunk);

for i = 1:NumTempData
    NumPoints = RecChunk*header.channels*header.samplerate(1)*2;
    fseek(fp, header.length+(i-1)*NumPoints,-1);
    if i == NumTempData
        data = fread(fp, (DataLen - (i-1)*NumPoints)/2, 'int16');
    else
        data = fread(fp, NumPoints/2, 'int16');
    end
    fprintf('Reading original data: %d percent \n', round(i*100/NumTempData));
    Dmat = reshape(data, header.samplerate(1), header.channels, []);
    clear data
    temp = zeros(header.channels, numel(Dmat)/header.channels);
    for j=1:size(Dmat,3)
        temp(:,((j-1)*header.samplerate(1)+1):(j*header.samplerate(1))) = Dmat(:,:,j)';
    end
    Dmat = temp;
    clear temp
    FileName = sprintf('./TempData_%02d.mat', i);
    save(FileName, 'Dmat');
    clear Dmat
end
fclose(fp);

% Reconstruct the Channel Label Table
ElecName = cellstr(header.channelname);
StripDealer ={{'-Ref', ''}, {'POL ', ''}};
for i = 1:length(StripDealer)
    ElecName = strrep(ElecName, StripDealer{i}{1}, StripDealer{i}{2});
end
if IsElecSelec
    Channel_label = ElecName(SelectIds);
else
    Channel_label = ElecName;
end
FileName = sprintf('%s/Channel_Label_%s',FolderName, BlockName);
save(FileName, 'Channel_label');

% Generate the data for each electrode by loading temporary stored file
% sequencially. First step is to determine the maximum size of electrode
% could be used in workspace (RAM)
GB2Doub = GB1*MemoryMax/8;
ChanChunk = floor(GB2Doub/(header.samplerate(1)*header.records*2));
NumLoad = ceil(header.channels/ChanChunk);
NumTpFile = RecChunk*header.samplerate(1);
for i = 1:NumLoad
    if i == NumLoad
        NumChan = header.channels - (NumLoad-1)*ChanChunk;
    else
        NumChan = ChanChunk;
    end
    Elecs = ((i-1)*ChanChunk+1):((i-1)*ChanChunk+NumChan);
    ChanD = zeros(NumChan, header.samplerate(1)*header.records);
    for j = 1:NumTempData
        FileName = sprintf('./TempData_%02d.mat', j);
        fprintf('Loading temporary data: %d percent \n', round(j*100/NumTempData));
        load(FileName);
        ChanD(:, ((j-1)*NumTpFile+1):(j-1)*NumTpFile+size(Dmat,2))= Dmat(Elecs,:);
    end
    clear Dmat
    for j = 1:length(Elecs);        
        if ismember(Elecs(j), 1)
            FileName = sprintf('%s/Pdio%s_02',FolderName, BlockName);
            anlg = ChanD(1,:);
            MaxV = median(anlg(anlg > 2));
            MinV = median(anlg(anlg < 2));
            anlg = (anlg - MinV)/(MaxV-MinV);
            save(FileName, 'anlg');
            clear anlg
            continue
        end
        if IsElecSelec
            SelecNum = find(SelectIds == Elecs(j));
            if ~isempty(SelecNum)
                fprintf('Saving electrode: %d/%d \n', SelecNum,length(SelectIds));
            end
        else
            fprintf('Saving electrode: %d/%d \n', Elecs(j),header.channels);
        end
        if IsElecSelec
            if ismember(Elecs(j), SelectIds)
                FileName = sprintf('%s/iEEG%s_%02d',FolderName, BlockName,SelecNum);
                wave = decimate(ChanD(j,:),10);
                save(FileName, 'wave');       
            end
        else
            FileName = sprintf('%s/iEEG%s_%02d',FolderName, BlockName,Elecs(j));
            wave = decimate(ChanD(j,:),10);
            save(FileName, 'wave');
        end
        clear wave
    end    
end

% Delete the temporary files
for j = 1:NumTempData
    FileName = sprintf('./TempData_%02d.mat', j);
    fprintf('Deleting temporary data: %d percent \n', round(j*100/NumTempData));
    delete(FileName);
end
end