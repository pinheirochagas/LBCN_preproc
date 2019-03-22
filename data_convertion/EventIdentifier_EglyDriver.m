function EventIdentifier_EglyDriver (sbj_name, project_name, block_names, dirs, pdio_chan)
%% Globar Variable elements

%% loop across blocks
for i = 1:length(block_names)
    bn = block_names{i};
    
    %% Load globalVar
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
    iEEG_rate=globalVar.iEEG_rate;
    
    %% reading analog channel from neuralData directory
    load(sprintf('%s/Pdio%s_%.2d.mat',globalVar.originalData, bn, pdio_chan)); % going to be present in the globalVar
    
    %% varout is anlg (single precision)
    pdio = anlg/max(double(anlg));
    n_initpulse_onset = 0;
    n_initpulse_offset = 0;
    clear anlg
    plot(pdio)
    
    
    %% Thresholding the signal
    if strcmp(project_name, 'Calculia_production')
        ind_above= pdio < -5;
    else
        ind_above= pdio > 0.5;
    end
    
    ind_df= diff(ind_above);
    clear ind_above
    onset= find(ind_df==1);
    offset= find(ind_df==-1);
    clear ind_df
    pdio_onset= onset/globalVar.Pdio_rate;
    pdio_offset= offset/globalVar.Pdio_rate;
    if length(pdio_onset) < length(pdio_offset)
        pdio_onset = [0 pdio_onset];
        warning('Adding additional onset as 0, since recording started in the middle of the photodiode signal')
    else
    end
    
    % %remove onset flash
    pdio_onset(1:n_initpulse_onset)=[]; % Add in calculia production the finisef to experiment to have 12 pulses
    pdio_offset(1:n_initpulse_offset)=[]; %
    clear n_initpulse_onset; clear n_initpulse_offset;
    
    %get osnets from diode
    pdio_dur= pdio_offset - pdio_onset;
    IpdioI= [pdio_onset(2:end)-pdio_offset(1:end-1) 0];
    isi_ind = find(IpdioI <0.1);
    clear stim_offset stim_onset
    stim_offset= [pdio_offset(isi_ind) pdio_offset(end)];
    stim_onset= [pdio_onset(isi_ind) pdio_onset(end)];
    % stim_onset = [stim_onset(1:115) stim_onset(117:end)];
    % stim_offset = [stim_offset(1:115) stim_offset(117:end)];
    
    stim_dur= stim_offset - stim_onset;
    
    %% Load trialinfo
    % ---------------------------------------------
    % Create specific subfunctions to extract the relevant info for each
    % project_name
    load([globalVar.psych_dir '/trialinfo_', bn '.mat'], 'trialinfo');
    
    
    
    %%
    % Plot photodiode segmented data
    figureDim = [0 0 1 1];
    figure('units', 'normalized', 'outerposition', figureDim)
    subplot(2,3,1:3)
    hold on
    plot(pdio)
    
    % Event onset

    diff_pdio_onset = diff(pdio_onset)
    pdio_onset(find(diff_pdio_onset<0.4)+1) = [];
    
    if strcmp(bn, 'E19-199_0039')
         pdio_onset(1:4) = [];
        pdio_onset([end]) = [];
        trialinfo(1,:) = [];
    else
        pdio_onset([end]) = [];
    end
    hold on
    plot(pdio_onset*globalVar.Pdio_rate,0.9*ones(length(pdio_onset),1),'r*');
    plot(pdio_offset*globalVar.Pdio_rate,0.9*ones(length(pdio_offset),1),'g*');    


    n_stim_per_trial = 5;
    allonsets = reshape(pdio_onset,n_stim_per_trial,length(pdio_onset)/n_stim_per_trial)';    
       
    trialinfo.allonsets = allonsets;
    
%    
%     trialinfo.allonsets(event_trials,:) = all_stim_onset;
%     trialinfo.RT_lock = nan(ntrials,1);
%     for ti = 1:ntrials
%         trialinfo.RT_lock(ti) = trialinfo.RT(ti) + trialinfo.allonsets(ti,nstim(ti));
%     end
%     trialinfo.allonsets(rest_trials,:) = (trialinfo.StimulusOnsetTime(rest_trials,:)-trialinfo.StimulusOnsetTime(rest_trials-1,:))+trialinfo.allonsets(rest_trials-1,:);
%     
%     
%     %% Account for when recording started in the middle of photodiode signal
%     if trialinfo.allonsets(1) == 0
%         warning('First trial excluded, since recording started in the middle of the photidiode signal')
%     else
%     end
%     trialinfo = trialinfo(trialinfo.allonsets(:,1) ~= 0,:);
    
    
    %% Update trialinfo
    disp('updating trialinfo')
    fn= sprintf('%s/trialinfo_%s.mat',globalVar.psych_dir,bn);
    save(fn, 'trialinfo');
    close all
end