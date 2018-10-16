function [elect_names, DRMT1] = importElectNames(dirs)
%IMPORTFILE Import numeric data from a text file as a matrix.
%   DRMT1 = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   DRMT1 = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows
%   STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   DRMT1 = importfile('DR_MT1.electrodeNames', 1, 136);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2018/07/12 11:08:04

%% Initialize variables.
delimiter = {',',' '};
if nargin<=2
    startRow = 1;
    endRow = inf;
end

%% Format for each line of text:
%   column1: text (%s)
%	column2: categorical (%C)
%   column3: categorical (%C)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%*s%*s%[^\n\r]';

%% Open the text file.
subDir=dirs.freesurfer;
subj = dir(subDir);
subj = subj(end).name;
subDir = [subDir '/' subj];
filename=fullfile(subDir,'elec_recon',[subj '.electrodeNames']);

fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Create output variable
DRMT1 = table(dataArray{1:end-1}, 'VariableNames', {'Name','VarName2','DepthStripGrid'});
elect_names = DRMT1.Name(3:end);

end

