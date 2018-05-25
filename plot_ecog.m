function []=plot_ecog(globalVar,str)
% plot ecog data, different stages of preprocessing.
% Dependencies:eegplot.m - eeglab toolbox
% Writen by Brett Foster, Parvizi Lab, Stanford
% 2013 - updatee e

% hello
%% Variables
sbj_name= globalVar.sbj_name;
block_name= globalVar.block_name;
data_dir= globalVar.data_dir;
srate_raw = round(globalVar.iEEG_rate);
srate_comp = round(globalVar.fs_comp);

%% Make plots
if strcmp(str,'comp')
    fprintf('Plotting notched compressed data\n')
            
            %load comp. data matrix
            load(sprintf('%s/allChanNotch%s.mat',globalVar.Comp_dir,block_name));
            chans = allChanNotch;
            clear allChanNotch

        %Select bad chans for identification (mod of epoch reject)
        %bad chans
        bad_chans = [globalVar.badChan globalVar.refChan globalVar.epiChan];
        %window reject params; no rejection just plotting
        winrej_start_end = [1 length(chans(1,:))];
        winrej_color = [1 1 1];
        winrej_chans = zeros(1, length(chans(:,1)));
        winrej_chans(bad_chans) = 1;

        %make window reject matrix, for eeglab plotting
        winrej = [winrej_start_end winrej_color winrej_chans];
     
    %plot matrix
    eegplot(chans,'srate',srate_comp,'submean','off','color','on','winlength',10,'winrej',winrej);
end    
    
if strcmp(str,'CAR')
    fprintf('Plotting CAR data\n')
    
    %electrodes
    elecs= setxor([1:globalVar.nchan],[globalVar.refChan,globalVar.badChan,globalVar.epiChan]);
        
        %Put CAR chans into matrix
        for ci= elecs
            load(sprintf('%s/CARiEEG%s_%.2d.mat',globalVar.CAR_dir,block_name, ci));
            chans(ci,:) = wave;
            clear wave
        end
        
        %Select bad chans for identification (mod of epoch reject)
        %bad chans
        bad_chans = [globalVar.badChan globalVar.refChan globalVar.epiChan];
        %window reject params; no rejection just plotting
        winrej_start_end = [srate_comp (length(chans(1,:))-srate_comp)];
        winrej_color = [1 1 1];
        winrej_chans = zeros(1, length(chans(:,1)));
        winrej_chans(bad_chans) = 1;

        %make window reject matrix, for eeglab plotting
        winrej = [winrej_start_end winrej_color winrej_chans];
     
    %plot matrix
    eegplot(chans,'srate',srate_raw,'submean','off','winlength',10,'winrej',winrej);   
    
elseif strcmp(str,'BP')
    fprintf('Plotting BP data\n')
    
    %electrodes
    elecs= 1:globalVar.nchan;
        
        %Put CAR chans into matrix
        for ci= elecs
            load(sprintf('%s/BPiEEG%s_%.2d.mat',globalVar.BP_dir,block_name, ci));
            chans(ci,:) = wave;
            clear wave
        end
        
        %Select bad chans for identification (mod of epoch reject)
        %bad chans
        bad_chans = [globalVar.badChan globalVar.refChan globalVar.epiChan];
        %window reject params; no rejection just plotting
        winrej_start_end = [srate_comp (length(chans(1,:))-srate_comp)];
        winrej_color = [1 1 1];
        winrej_chans = zeros(1, length(chans(:,1)));
        winrej_chans(bad_chans) = 1;

        %make window reject matrix, for eeglab plotting
        winrej = [winrej_start_end winrej_color winrej_chans];
     
    %plot matrix
    eegplot(chans,'srate',srate_raw,'submean','off','winlength',10,'winrej',winrej); 
    
end
    

