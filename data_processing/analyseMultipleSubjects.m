function analyseMultipleSubjects(sbj_name, project_name, dirs)

    disp(['preprocessing subject ' sbj_name])
    
    % List Blocks
    block_names = BlockBySubj(sbj_name,'MMR');
    
    %% Branch 5 - Time-frequency analyses
    % Load elecs info
    load(sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,block_names{1}),'globalVar');
    elecs = setdiff(1:globalVar.nchan,globalVar.refChan);
    
    for bi = 1:length(block_names)
        parfor ei = 1:length(elecs)
            WaveletFilterAll(sbj_name, project_name, block_names{bi}, dirs, elecs(ei), 'HFB', [], [], [], 'Band') % only for HFB
            WaveletFilterAll(sbj_name, project_name, block_names{bi}, dirs, elecs(ei), 'SpecDense', [], [], true, 'Spec') % across frequencies of interest
        end
    end
    
    %% Branch 6 - Epoching, identification of bad epochs and baseline correction
    epoch_params = genEpochParams(project_name, 'stim');
    
    for bi = 1:length(block_names)
        parfor ei = 1:length(elecs)
            EpochDataAll(sbj_name, project_name, block_names{bi}, dirs,elecs(ei), 'HFB', [],[], epoch_params,'Band')
            EpochDataAll(sbj_name, project_name, block_names{bi}, dirs,elecs(ei), 'SpecDense', [],[], epoch_params,'Spec')
        end
    end
    
    % Delete non epoch data after epoching
    deleteContinuousData(sbj_name, dirs, project_name, block_names, 'HFB', 'Band')
%     deleteContinuousData(sbj_name, dirs, project_name, block_names, 'SpecDense', 'Spec')
    disp(['preprocessing subject ' sbj_name ' DONE!'])
    
    % plot avg. HFB timecourse for each electrode separately
    disp(['plotting subject ' sbj_name ' HFB'])
    plot_params = genPlotParams(project_name,'timecourse');
    plot_params.noise_method = 'trials'; %'trials','timepts','none'
    plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
    PlotTrialAvgAll(sbj_name,project_name,block_names,dirs,[],'HFB','stim','condNames',[],plot_params,'Band') % condNames
    
    % plot ERSP (event-related spectral perturbations) for each electrode
    disp(['plotting subject ' sbj_name ' SpecDense'])
    plot_params = genPlotParams(project_name,'ERSP');
    plot_params.noise_method = 'trials'; %'trials','timepts','none'
    plot_params.noise_fields_trials = {'bad_epochs_HFO','bad_epochs_raw_HFspike'};
    PlotERSPAll(sbj_name,project_name,block_names,dirs,[],'SpecDense','stim','condNames',[],plot_params)% condNames
    
end
