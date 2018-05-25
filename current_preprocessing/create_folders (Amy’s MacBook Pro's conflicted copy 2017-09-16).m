% Functions: Generating folders
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Revision date SEP,2009
% Run this once only.
clear
%% Variables
sbj_name= 'S17_115';
block_name= 'E17-681_0009';
project_name= 'Memoria';

comp_root = sprintf('/Users/amydaitch/Documents/MATLAB'); % location of analysis_ECOG folder
data_root= sprintf('%s/analysis_ECOG/neuralData',comp_root);
psych_root= sprintf('%s/analysis_ECOG/psychData',comp_root);
result_root= sprintf('%s/analysis_ECOG/Results/%s',comp_root,project_name); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Making data directory
if ~exist(sprintf('%s/originalData/%s',data_root,sbj_name))
    mkdir(sprintf('%s/originalData',data_root),sbj_name);
end
if ~exist(sprintf('%s/originalData/%s/%s',data_root,sbj_name,block_name))
    mkdir(sprintf('%s/originalData/%s',data_root,sbj_name),block_name);
end

%% Making a directory for common average referencing (CAR)
if ~exist(sprintf('%s/CARData/%s',data_root,sbj_name))
    mkdir(sprintf('%s/CARData',data_root),sbj_name)
end
if ~exist(sprintf('%s/CARData/%s/%s',data_root,sbj_name,block_name))
    mkdir(sprintf('%s/CARData/%s',data_root,sbj_name),block_name)
end

%% Making a directory for compressed data
if ~exist(sprintf('%s/CompData/%s',data_root,sbj_name))
    mkdir(sprintf('%s/CompData',data_root),sbj_name)
end
if ~exist(sprintf('%s/CompData/%s/%s',data_root,sbj_name,block_name))
    mkdir(sprintf('%s/CompData/%s',data_root,sbj_name),block_name)
end

%% Making directory for notch filtered data
if ~exist(sprintf('%s/FiltData/%s',data_root,sbj_name))
    mkdir(sprintf('%s/FiltData',data_root),sbj_name)
end
if ~exist(sprintf('%s/FiltData/%s/%s',data_root,sbj_name,block_name))
    mkdir(sprintf('%s/FiltData/%s',data_root,sbj_name),block_name);
end

%% Making directory for re-referenced data
if ~exist(sprintf('%s/reRefData/%s',data_root,sbj_name))
    mkdir(sprintf('%s/reRefData',data_root),sbj_name)
end
if ~exist(sprintf('%s/reRefData/%s/%s',data_root,sbj_name,block_name))
    mkdir(sprintf('%s/reRefData/%s',data_root,sbj_name),block_name)
end

%% Making directory for spectral data
if ~exist(sprintf('%s/SpecData/%s',data_root,sbj_name))
    mkdir(sprintf('%s/SpecData',data_root),sbj_name)
end
if ~exist(sprintf('%s/SpecData/%s/%s',data_root,sbj_name,block_name))
    mkdir(sprintf('%s/SpecData/%s',data_root,sbj_name),block_name)
end

%% Making directory for normalized spectral data
if ~exist(sprintf('%s/NormData/%s',data_root,sbj_name))
    mkdir(sprintf('%s/NormData',data_root),sbj_name)
end
if ~exist(sprintf('%s/NormData/%s/%s',data_root,sbj_name,block_name))
    mkdir(sprintf('%s/NormData/%s',data_root,sbj_name),block_name)
end

%% Making behavioral directory
if ~exist(sprintf('%s/%s',psych_root,sbj_name))
    mkdir(sprintf('%s',psych_root),sbj_name);
end
if ~exist(sprintf('%s/%s/%s',psych_root,sbj_name,block_name))
    mkdir(sprintf('%s/%s',psych_root,sbj_name),block_name);
end

%% Making result directory
if ~exist(sprintf('%s/%s',result_root,sbj_name))
   mkdir(sprintf('%s',result_root),sbj_name) 
end
if ~exist(sprintf('%s/%s/%s',result_root,sbj_name,block_name))
   mkdir(sprintf('%s/%s',result_root,sbj_name),block_name) 
end



