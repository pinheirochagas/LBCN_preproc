function []= commonAvgRefNK(globalVar)
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

% chRank = ones(1,globalVar.nchan);
% chRank(globalVar.badChan) = 0;
% chRank(globalVar.refChan) = 0;
% chRank(globalVar.epiChan) = 0;
% cnt= sum(chRank);

elecs = setxor([1:globalVar.nchan],[globalVar.badChan,globalVar.refChan,globalVar.epiChan]);
elecnames_good = {globalVar.elecnames{elecs}};
cnt = length(elecnames_good);

fprintf('Making CAR from notch filtered data\n')
fprintf('Making CAR\n')
%% Calculating Common Average Reference
CAR = zeros(1,globalVar.chanLength,'single');
for ci = 1:cnt
    load(sprintf('%s/fiEEG_%s_%s.mat',globalVar.Filt_dir,block_name,elecnames_good{ci}))
    ['Reading: ' sprintf('%s/fiEEG_%s_%s.mat',globalVar.Filt_dir,block_name,elecnames_good{ci})]
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

for ci = 1:globalVar.nchan(end)
    load(sprintf('%s/fiEEG_%s_%s.mat',globalVar.Filt_dir,block_name,globalVar.elecnames{ci}))
    ['Reading: ' sprintf('%s/fiEEG_%s_%s.mat',globalVar.Filt_dir,block_name,globalVar.elecnames{ci})]
    
    wave = wave - CAR;
    ['Writing: ' sprintf('%s/CARiEEG_%s_%s.mat',globalVar.CAR_dir,block_name,globalVar.elecnames{ci})]
    save(sprintf('%s/CARiEEG_%s_%s.mat',globalVar.CAR_dir,block_name,globalVar.elecnames{ci}),'wave');
    clear wave
end

end



