function BadChanReject(sbj_name, project_name, bns, dirs)


for i = 1:length(bns)
    bn = bns{i};
    
    % Load globalVar
    fn = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn);
    load(fn,'globalVar');
    
    %Filtering 60 Hz line noise & harmonics
    noiseFiltData(globalVar);
    %Chan info PROMPT
    globalVar.badChan = [globalVar.refChan globalVar.epiChan];
    
    %% Step 1: Bad channel detection based on raw power
    %This part saves data.mat
    
    % Format the data
    sub_info.data.name = sprintf('%s/fiEEG%s_',globalVar.Filt_dir,bn);
    sub_info.Pdiode.name = sprintf('%s/Pdio%s_02',globalVar.data_dir,bn);
    
    data_nr=1;
    load([sub_info.data(data_nr).name '01.mat'])
    ttot=size(wave,2); % ttot = total time in units of samples
    clear wave
    
    data=zeros(ttot,globalVar.nchan); % initialize data variable
    for n=1:globalVar.nchan % cycle through channels
        if n<10,nl=['0' num2str(n)]; else nl=num2str(n); end % lame hack-around for channel names
        load([sub_info.data(data_nr).name nl '.mat'],'wave'),
        wave=wave.'; %because has incorrect ordering for efficiency, should be time x 1
        data(:,n)=-wave; % invert: data are recorded inverted
        clear wave nl
    end
    data=single(data);
    
    %% Run algorithm
    bad_chans=[globalVar.refChan globalVar.badChan globalVar.epiChan];
    a=var(data);
    b=find(a>(5*median(a)));
    c=find(a<(median(a)/5));
    if ~isempty([b c])
        disp(['additional bad channels: ' int2str(setdiff([b c],bad_chans))]);
    end
    disp('add additional bad channel to subj_info-bad_channels2 if you want to cut them')
    
    % %Plot bad channels
    bad_cha_tmp = setdiff([b c],[globalVar.badChan globalVar.epiChan]);
    figureDim = [0 0 1 1];
    figure('units', 'normalized', 'outerposition', figureDim)
    for ii = bad_cha_tmp
        hold on
        plot(zscore(data(:,ii))+ii);
    end
    % Update the globalVar.badChan
    globalVar.badChan = [bad_cha_tmp globalVar.badChan];

        % remove bad channels
    chan_lbls=1:size(data,2);
    data(:,globalVar.badChan)=[];
    chan_lbls(globalVar.badChan)=[];
  
    %% Step 2: Bad channel detection based on spikes in the raw data  
    nr_jumps=zeros(1,size(data,2));
    for k=1:size(data,2)
        nr_jumps(k)=length(find(diff(data(:,k))>80)); % find jumps>80uV
    end
    
    figure,plot(nr_jumps);
    ej= floor(globalVar.chanLength/globalVar.iEEG_rate);% 1 jump per second in average
    jm=find(nr_jumps>ej);% Find channels with more than ... jumps
    clcl=chan_lbls(jm);% Real channel numbers of outliers
    disp(['spiky channels: ' int2str(clcl)]);
    % return chan
    
    % Add the bad channels to globalVar.badChan if you think they are bad bad!
    
    %% Bad channel detection step 3: Bad channel detection based on powerspectra 
    set_ov=0; % overlap
    f = 0:250; % 
    data_pxx=zeros(length(f),size(data,2));
    
    for k=1:size(data,2)
        [Pxx,f] = pwelch(data(1:100*globalVar.iEEG_rate,k),globalVar.iEEG_rate,set_ov,f,globalVar.iEEG_rate);
        data_pxx(:,k)=Pxx;
    end
    
    % Plot chnas in different colors:
    figureDim = [0 0 .5 1];
    figure('units', 'normalized', 'outerposition', figureDim)
    plotthis=log(data_pxx);
    for fi = 1:size(plotthis,2)
        hold on
        plot(f,plotthis(:,fi))
        text(0:20:size(plotthis,1), plotthis(1:20:size(plotthis,1),fi), num2str(chan_lbls(fi)), ...
            'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle')
    end
    xlim([1 size(plotthis,1)])
    ylim([min(plotthis(:)) max(plotthis(:))])
    
    % Prompt for bad channels
    bad_chan_spec = promptBadChanSpec; % of the remaining channels
    bad_chan_spec_lab = chan_lbls(bad_chan_spec); % returns the original channel number
    close all
    
    % Update globalVar.badChan 
    globalVar.badChan = [bad_chan_spec_lab globalVar.badChan];
    
    % remove bad channels
    data(:,bad_chan_spec)=[];
    chan_lbls(bad_chan_spec)=[];
    
    % Eyeball the rereferenced data after removing the bad channels
    data_down_car = car(data);
    % Plot CAR data for eyeballing
    figureDim = [0 0 .5 1];
    figure('units', 'normalized', 'outerposition', figureDim)
    for iii = 1:size(data_down_car,2)
        hold on
        plot(zscore(data_down_car(1:round(globalVar.iEEG_rate*20),iii))+iii);
    end
    
    %% Re-referencing data to the common average reference CAR - and save
    elecs = setxor(1:globalVar.nchan,[globalVar.badChan globalVar.refChan globalVar.epiChan]); %
    commonAvgRef(globalVar,'noiseFilt'); % 'orig'
      
    %% Save globalVar (For the last time; don't re-write after this point!)
    fn = sprintf('%s/originalData/%s/global_%s_%s_%s.mat',dirs.data_root,sbj_name,project_name,sbj_name,bn);
    save(fn,'globalVar');
end

end



