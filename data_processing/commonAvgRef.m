function commonAvgRef(globalVar,str)
% Rereferencing to a Common Average Reference
% str variable is 'orig' or 'noiseFilt'
% Dependencies:
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Revision date SEP,2009


%% variable names
block_name= globalVar.block_name;

%% Removing Bad Channels
% epiChan= globalVar.epiChan; %excluding channels with epileptic activity
% elecs= [1:globalVar.nchan];
% elecs(globalVar.badChan)= []; %excluding noisy channels from the common average
% elecs(globalVar.refChan)= []; %excluding the reference channel from the common average
% elecs(globalVar.epiChan)= []; %excluding channels with epileptic activity from the common average
% elecs= setxor([1:globalVar.nchan],[globalVar.badChan,globalVar.refChan,globalVar.epiChan]);

chRank = ones(1,globalVar.nchan);
chRank(globalVar.badChan) = 0;
chRank(globalVar.refChan) = 0;
chRank(globalVar.epiChan) = 0;
cnt= sum(chRank);

elecs = setxor(1:globalVar.nchan,[globalVar.badChan,globalVar.refChan,globalVar.epiChan]);

if strcmp(str,'orig')
    fprintf('Making CAR from original data\n')
    %% Calculating Common Average Reference
    fprintf('Making CAR\n')
    CAR = zeros(1,globalVar.chanLength,'single');
    for ci = elecs
        ['Reading: ' sprintf('%s/iEEG%s_%.2d.mat',globalVar.originalData,block_name,ci)]
        load(sprintf('%s/iEEG%s_%.2d.mat',globalVar.originalData,block_name,ci));
        wave = wave - mean(wave);                    % remove mean before CAR
        CAR = CAR + wave;             % sum CAR in groups
        clear wave
    end
    
    CAR = CAR/cnt; % common average reference
    save(sprintf('%s/CAR%s.mat',globalVar.CARData,block_name),'CAR');
    
    % figure, plot((1:length(CAR))/iEEG_rate,CAR/cnt),hold on
    % plot((1:length(CAR))/iEEG_rate,wave)
    
    %% Subtracting the common average reference from all channels
    for ii = 1:globalVar.nchan(end)
        fprintf('Subtracting CAR from data\n')
%         if ii~= [globalVar.refChan, globalVar.badCahan];
            ['Reading: ' sprintf('%s/iEEG%s_%.2d.mat',globalVar.originalData,block_name,ii)]
            load(sprintf('%s/iEEG%s_%.2d.mat',globalVar.originalData,block_name,ii));
            
            wave = wave - CAR;
            ['Writing: ' sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CARData,block_name, ii)]
            save(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CARData,block_name, ii),'wave');
            clear wave
%         end
    end
    
elseif strcmp(str,'noiseFilt')
    fprintf('Making CAR from notch filtered data\n')
    fprintf('Making CAR\n')
    %% Calculating Common Average Reference
    CAR = zeros(1,globalVar.chanLength,'single');
    for ci = elecs
        ['Reading: ' sprintf('%s/fiEEG%s_%.2d.mat',globalVar.FiltData,block_name,ci)]
        load(sprintf('%s/fiEEG%s_%.2d.mat',globalVar.FiltData,block_name,ci));
        wave = wave - mean(wave);                    % remove mean before CAR
        CAR = CAR + wave;             % sum CAR in groups
        clear wave
    end
    
    CAR= CAR/cnt; % common average reference
    save(sprintf('%s/CAR%s.mat',globalVar.CARData,block_name),'CAR');
    
    % figure, plot((1:length(CAR))/iEEG_rate,CAR/cnt),hold on
    % plot((1:length(CAR))/iEEG_rate,wave)
    
    %% Subtracting the common average reference from all channels
    fprintf('Subtracting CAR from data\n')
    
    %for ii= 65:globalVar.nchan(end) %for patients with depth electrodes
    for ii = 1:globalVar.nchan(end)
%         if ii~= globalVar.refChan
            ['Reading: ' sprintf('%s/fiEEG%s_%.2d.mat',globalVar.FiltData,block_name,ii)]
            load(sprintf('%s/fiEEG%s_%.2d.mat',globalVar.FiltData,block_name,ii));
            data.wave = wave - CAR;
            data.fsample = globalVar.iEEG_rate;
            ['Writing: ' sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CARData,block_name, ii)]
            save(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CARData,block_name, ii),'data');
            clear wave
    end
 
else
    error('str variable should be orig, noiseFilt, or artRep')
end
