function EventIdentifier (sbj_name, project_name, block_names, dirs)
%% Globar Variable elements


%% loop across blocks
for i = 1:length(block_names)
    bn = block_names{i};
    
    %% Load globalVar
    
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn));
    iEEG_rate=globalVar.iEEG_rate;
    
    %% Reading PsychData BAHAVIORAL DATA
    
    % ---------------------------------------------
    % Create specific subfunctions to extract the relevant info for each
    % project_name
    soda_name = dir(fullfile(globalVar.psych_dir, 'sodata*.mat'));
    K = load([globalVar.psych_dir '/' soda_name.name]); % block 55 %% FIND FILE IN THE FOLDER AUTO
        
    lsi= length(K.theData);
    
    SOT= nan(1,lsi);
    sbj_resp= nan(1,lsi);
    RT = [K.theData.RT];
    for si= 1:lsi %
        if (~isempty(K.theData(si).flip))
            SOT(si)= K.theData(si).flip.StimulusOnsetTime; %% time between
            if ~isnan(str2num(K.theData(si).keys))
                sbj_resp(si)= str2num(K.theData(si).keys(1));
            else
                sbj_resp(si)= NaN;
            end
        end
    end
    %

    % ---------------------------------------------
    
    %return
    %% reading analog channel from neuralData directory
    load(sprintf('%s/Pdio%s_01.mat',globalVar.originalData,bn)); % going to be present in the globalVar
     
    
    %% varout is anlg (single percision)
    downRatio= round(globalVar.Pdio_rate/iEEG_rate);
    pdio= decimate(double(anlg),downRatio)*-1; % down sample to the iEEG rate and make it positive
    clear anlg
    
    pdio = pdio/max(pdio)*2;
    
    
    %% Thresholding the signal
    ind_above= pdio > 0.5;
    ind_df= diff(ind_above);
    clear ind_above
    onset= find(ind_df==1);
    offset= find(ind_df==-1);
    clear ind_df
    pdio_onset= onset/iEEG_rate;
    pdio_offset= offset/iEEG_rate;
    
    % %remove onset flash
    
    % pdio_onset(1:12)=[]; % Add in calculia production the finisef to experiment to have 12 pulses
    % pdio_offset(1:12)=[]; %
    
    
    %get osnets from diode
    pdio_dur= pdio_offset - pdio_onset;
    IpdioI= [pdio_onset(2:end)-pdio_offset(1:end-1) 0];
    isi_ind = find(IpdioI > 0.2);
    
    stim_offset= [pdio_offset(isi_ind) pdio_offset(end)];
    stim_onset= [pdio_onset(isi_ind) pdio_onset(end)];
    % stim_onset = [stim_onset(1:115) stim_onset(117:end)];
    % stim_offset = [stim_offset(1:115) stim_offset(117:end)];
    
    stim_dur= stim_offset - stim_onset;
    
    %% Get trials, insturuction onsets
    n_stim_per_trial = 3;
    all_stim_onset = NaN*ones(lsi,n_stim_per_trial); %% the second input is project dependent
    
    rest_onset = [];
    rest_offset = [];
       
    % SIMPLIFY THAT AND MAKE IT PROJECT DEPENDENT
    
    counter = 1;
    for ti = 1:lsi
        end_counter = min(counter+n_stim_per_trial,length(stim_onset));
        numinds = end_counter-counter;
        all_stim_onset(ti,1:numinds) = stim_onset(counter:counter+numinds-1);
        counter = counter + n_stim_per_trial;
    end
    
    %%% WHY IS THE LAST EVETN OF THE LAST TRIAL NAN???? Doesnt matter much
    %%% cause we are using only the 1 column.
    
        
    %plot each presentation in trial
    figureDim = [0 0 1 1];
    figure('units', 'normalized', 'outerposition', figureDim)
    subplot(2,3,1:3)
    hold on
    plot(pdio)
    plot(all_stim_onset(:,1)*iEEG_rate,0.9*ones(lsi,1),'r*');
    plot(all_stim_onset(:,2)*iEEG_rate,0.7*ones(lsi,1),'b*');
    plot(all_stim_onset(:,3)*iEEG_rate,0.5*ones(lsi,1),'g*');
    
    
    %% Comparing photodiod with behavioral data
    %for just the first stimulus of each trial
    df_SOT= diff(SOT);
    % df_stim_onset= diff(stim_onset_fifth); %fifth? why?
    df_stim_onset = diff(all_stim_onset(:,1))';
    %plot overlay
    subplot(2,3,4)
    plot(df_SOT,'o','MarkerSize',8,'LineWidth',3),hold on, plot(df_stim_onset,'r*')
    df= df_SOT - df_stim_onset;
    
    %plot diffs, across experiment and histogram
    subplot(2,3,5)
    plot(df), ylim([-.005 .005]);
    title('Diff. behavior diode (exp)');
    xlabel('Trial number');
    ylabel('Time (ms)');
    subplot(2,3,6)
    hist(df), xlim([-.005 .005])
    title('Diff. behavior diode (hist)');
    xlabel('Time (ms)');
    ylabel('Count');

    %flag large difference
    if ~all(abs(df)<.1)
        disp('behavioral data and photodiod mismatch'),return
    end
    
    %% Segment audio grom mic
    % adapt: segment_audio_mic 
%      load(sprintf('%s/%s_%s_slist.mat',globalVar.psych_dir,sbj_name,bn))
%      K.slist = slist; 
  
    
    %% Updating the events with onsets. 
    trialinfo = K.slist;
    trialinfo.block = repmat(i,size(K.slist,1),1);
    trialinfo.RT = RT'; % from PsychToolBox! 
    trialinfo.sbj_resp = sbj_resp'; % from PsychToolBox! 
    trialinfo.allonsets = all_stim_onset;
    trialinfo.RT_lock = trialinfo.RT + trialinfo.allonsets(:,end);    
    
    
    %% Save trialinfo   
    fn= sprintf('%s/trialinfo_%s.mat',globalVar.result_dir,bn);
    save(fn, 'trialinfo');
    
end


end