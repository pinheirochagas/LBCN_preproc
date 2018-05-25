function commonAvgRef(globalVar,str)
% Rereferencing to a Common Average Reference
% str variable is 'orig' or 'noiseFilt'
% Dependencies:
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Revision date SEP,2009


%% variable names
sbj_name= globalVar.sbj_name;
block_name= globalVar.block_name;
data_dir= globalVar.data_dir;

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

elecs = setxor([1:globalVar.nchan],[globalVar.badChan,globalVar.refChan,globalVar.epiChan]);

if strcmp(str,'orig')
    fprintf('Making CAR from original data\n')
    %% Calculating Common Average Reference
    fprintf('Making CAR\n')
    CAR = zeros(1,globalVar.chanLength,'single');
    for ci = elecs
        ['Reading: ' sprintf('%s/iEEG%s_%.2d.mat',globalVar.data_dir,block_name,ci)]
        load(sprintf('%s/iEEG%s_%.2d.mat',globalVar.data_dir,block_name,ci));
        wave= wave - mean(wave);                    % remove mean before CAR
        CAR = CAR + wave;             % sum CAR in groups
        clear wave
    end
    
    CAR= CAR/cnt; % common average reference
    save(sprintf('%s/CAR%s.mat',globalVar.CAR_dir,block_name),'CAR');
    
    % figure, plot((1:length(CAR))/iEEG_rate,CAR/cnt),hold on
    % plot((1:length(CAR))/iEEG_rate,wave)
    
    %% Subtracting the common average reference from all channels
    for ii = 1:globalVar.nchan(end)
        fprintf('Subtracting CAR from data\n')
%         if ii~= [globalVar.refChan, globalVar.badCahan];
            ['Reading: ' sprintf('%s/iEEG%s_%.2d.mat',globalVar.data_dir,block_name,ii)]
            load(sprintf('%s/iEEG%s_%.2d.mat',globalVar.data_dir,block_name,ii));
            
            wave = wave - CAR;
            ['Writing: ' sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,block_name, ii)]
            save(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,block_name, ii),'wave');
            clear wave
%         end
        
    end
    
    
elseif strcmp(str,'noiseFilt')
    fprintf('Making CAR from notch filtered data\n')
    fprintf('Making CAR\n')
    %% Calculating Common Average Reference
    CAR = zeros(1,globalVar.chanLength,'single');
    for ci = elecs
        ['Reading: ' sprintf('%s/fiEEG%s_%.2d.mat',globalVar.Filt_dir,block_name,ci)]
        load(sprintf('%s/fiEEG%s_%.2d.mat',globalVar.Filt_dir,block_name,ci));
        wave= wave - mean(wave);                    % remove mean before CAR
        CAR = CAR + wave;             % sum CAR in groups
        clear wave
    end
    
    CAR= CAR/cnt; % common average reference
    save(sprintf('%s/CAR%s.mat',globalVar.CAR_dir,block_name),'CAR');
    
    % figure, plot((1:length(CAR))/iEEG_rate,CAR/cnt),hold on
    % plot((1:length(CAR))/iEEG_rate,wave)
    
    %% Subtracting the common average reference from all channels
    fprintf('Subtracting CAR from data\n')
    
    %for ii= 65:globalVar.nchan(end) %for patients with depth electrodes
    for ii = 1:globalVar.nchan(end)
%         if ii~= globalVar.refChan
            ['Reading: ' sprintf('%s/fiEEG%s_%.2d.mat',globalVar.Filt_dir,block_name,ii)]
            load(sprintf('%s/fiEEG%s_%.2d.mat',globalVar.Filt_dir,block_name,ii));
            wave = wave - CAR;
            ['Writing: ' sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,block_name, ii)]
            
            save(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,block_name, ii),'wave');
            clear wave
%         end
        
    end
 

elseif strcmp(str,'artRep')
    fprintf('Making CAR from notch filtered and artifact-rejected data\n')
    %% Calculating Common Average Reference
    CAR = zeros(1,globalVar.chanLength,'single');
    for ci = elecs
        fprintf(['Reading: ' sprintf('%s/aiEEG%s_%.2d.mat',globalVar.Art_dir,globalVar.block_name,ci) '\n']);
        load(sprintf('%s/aiEEG%s_%.2d.mat',globalVar.Art_dir,globalVar.block_name,ci)); % contains "wave" var
        wave = wave - mean(wave);                    % remove mean before CAR
        CAR = CAR + wave;             % sum CAR in groups
        clear wave
    end

    CAR= CAR/cnt; % common average reference
    save(sprintf('%s/CAR%s.mat',globalVar.CAR_dir,globalVar.block_name),'CAR','elecs');

    % figure, plot((1:length(CAR))/iEEG_rate,CAR/cnt),hold on
    % plot((1:length(CAR))/iEEG_rate,wave)
    
    %% Subtracting the common average reference from all channels
    fprintf('Subtracting CAR from data\n')
    for ii = 1:globalVar.nchan(end)
        if ii~= globalVar.refChan
            fn = sprintf('%s/aiEEG%s_%.2d.mat',globalVar.Art_dir,globalVar.block_name,ii);
            ['Reading: ' fn]
            load(fn);
            avgbeforeCAR(ci) = mean(wave);

            wave = wave - CAR;
            ['Writing: ' sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,globalVar.block_name, ii)]
            save(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,globalVar.block_name, ii),'wave');
            avgafterCAR(ci) = mean(wave);
            clear wave 
        end
    end
    
    save(sprintf('%s/chanavgs_%s.mat',globalVar.CAR_dir,globalVar.block_name),'avgbeforeCAR','avgafterCAR');

else
    error('str variable should be orig, noiseFilt, or artRep')
end

