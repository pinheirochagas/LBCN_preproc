
%% |PIPELINE FOR THE MATH PAPER| 

%% Define paths to directories
[server_root, comp_root, code_root] = AddPaths('Pedro_iMAC');
dirs = InitializeDirs(' ', ' ', comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'


%% Tasks:
% * *Localizers:* VTC, Scrambled, AllCateg, Logo, 7Heaven
% * *Calculation Simultaneous:* MMR, UCLA, MFA
% * *Calculation Sequential:* Calculia, Memoria

%% Paper folder
result_dir = '/Users/pinheirochagas/Pedro/Stanford/papers/spatiotempoal_dynamics_math/results/';
figure_dir = '/Users/pinheirochagas/Pedro/Stanford/papers/spatiotempoal_dynamics_math/figures/';

%% Define final cohorts
% Read the google sheets
[DOCID,GID] = getGoogleSheetInfo('math_network','cohort');
sinfo = GetGoogleSpreadsheet(DOCID, GID);
subject_names = sinfo.sbj_name;

%% Plot coverage
outdir = '/Volumes/LBCN8T/Stanford/data/Results/coverage/';
% Filer for subjVar data
sinfo = sinfo(strcmp(sinfo.subjVar, '1'),:);
% Filer for usable data
sinfo = sinfo(strcmp(sinfo.behavior, '1'),:);
subjects = unique(sinfo.sbj_name);
subjects_unique = unique(subjects);

% Vizualize task per subject
vizualize_task_subject_coverage(sinfo, 'task_group')
savePNG(gcf, 600, [figure_dir, 'tasks_break_group_down_subjects.png'])
 
% Plot full coverage
vars = {'LvsR','MNI_coord', 'WMvsGM', 'sEEG_ECoG', 'DK_lobe', 'Yeo7', 'Yeo17'};
subjVar_all_all = ConcatSubjVars(subjects, dirs, vars);
subjVar_all = subjVar_all_all(strcmp(subjVar_all_all.WMvsGM, 'GM') | strcmp(subjVar_all_all.WMvsGM, 'WM'), :);
sort_tabulate(subjVar_all.WMvsGM)
sort_tabulate(subjVar_all.sEEG_ECoG)
sort_tabulate(subjVar_all.DK_lobe_generic)
sort_tabulate(subjVar_all.Yeo7)
sort_tabulate(subjVar_all.Yeo17)

data_ecog = subjVar_all(strcmp(subjVar_all.sEEG_ECoG, 'ECoG'), :);
data_seeg = subjVar_all(strcmp(subjVar_all.sEEG_ECoG, 'sEEG'), :);
sort_tabulate(data_ecog.WMvsGM)
sort_tabulate(data_ecog.LvsR)
sort_tabulate(data_seeg.WMvsGM)
sort_tabulate(data_seeg.LvsR)


cfg = getPlotCoverageCFG('full');
PlotModulation(dirs, subjVar_all, cfg)

% Plot coverage by task group
col_group = 'task_group'; % or task_group
task_group = unique(sinfo.(col_group));
cols = hsv(length(task_group));
for i = 1:length(task_group)
    disp(task_group{i})
    sinfo_tmp = sinfo(strcmp(sinfo.(col_group), task_group{i}),:);
    subjects = unique(sinfo_tmp.sbj_name);
    subjVar_all = ConcatSubjVars(subjects, dirs);
    cfg = getPlotCoverageCFG('tasks_group'); 
    cfg.MarkerColor = cols(i,:);
    PlotModulation(dirs, subjVar_all, cfg)
end





%% Univariate Selectivity
tag = 'stim';
tasks = unique(sinfo.task);
tasks = {'Memoria'};
dirs = InitializeDirs(tasks{1}, sinfo.sbj_name{1}, comp_root, server_root, code_root); % 'Pedro_NeuroSpin2T'
dirs.result_dir = result_dir;
for it = 1:length(tasks)
    task = tasks{it};
    sinfo_tmp = sinfo(strcmp(sinfo.task, task),:);
    parfor i = 1:size(sinfo_tmp,1)
        ElecSelectivityAll(sinfo_tmp.sbj_name{i}, dirs, task, 'stim', 'Band', 'HFB')
    end
end


vars = {'chan_num', 'FS_label', 'LvsR','MNI_coord', 'WMvsGM', 'sEEG_ECoG', 'DK_lobe', 'Yeo7', 'Yeo17', 'DK_long_josef', ...
        'elect_select', 'act_deact_cond1', 'act_deact_cond2', 'sc1c2_FDR', 'sc1b1_FDR' , 'sc2b2_FDR', ...
        'sc1c2_Pperm', 'sc1b1_Pperm', 'sc2b2_Pperm', 'sc1c2_tstat', 'sc1b1_tstat', 'sc2b2_tstat'};

task = 'MMR';    
sinfo_MMR = sinfo(strcmp(sinfo.task, task),:);    
el_selectivity_MMR = concat_elect_select(sinfo_MMR.sbj_name, task, dirs, vars);
task = 'UCLA';    
sinfo_UCLA = sinfo(strcmp(sinfo.task, task),:);    
el_selectivity_UCLA = concat_elect_select(sinfo_UCLA.sbj_name, task, dirs, vars);

el_selectivity_calc_sim = [el_selectivity_MMR;el_selectivity_UCLA]
el_selectivity_calc_sim = el_selectivity_calc_sim(strcmp(el_selectivity_calc_sim.WMvsGM, 'GM') | strcmp(el_selectivity_calc_sim.WMvsGM, 'WM'), :);
el_selectivity_calc_sim = el_selectivity_calc_sim(~strcmp(el_selectivity_calc_sim.Yeo7, 'FreeSurfer_Defined_Medial_Wall'),:)



selectivities = {{'math only'}, {'math selective'}, {'math deact'}, {'no selectivity'}, {'episodic only', 'autobio only'}, {'episodic selective', 'autobio selective'}, {'autobio deact',  'episodic deact'}, {'math and episodic', 'math and autobio'}};
columns = {'Yeo7', 'DK_lobe'};
figure('units', 'normalized', 'outerposition', [0 0 1 1])
for ic = 1:length(columns)
    for i = 1:length(selectivities)
        selectivity = selectivities{i};
        column = columns{ic};
        subplot(2,4,i)
        if strcmp(selectivity, 'math deact') == 1
            el_tmp = el_selectivity_calc_sim(el_selectivity_calc_sim.act_deact_cond1 == -1,:);
        elseif contains(selectivity, {'autobio deact',  'episodic deact'}) == 2
            el_tmp = el_selectivity_calc_sim(el_selectivity_calc_sim.act_deact_cond2 == -1,:);
        else
            el_tmp = el_selectivity_calc_sim(contains(el_selectivity_calc_sim.elect_select, selectivity),:);
        end
        plot_frequency(el_tmp, column, 'ascend', 'horizontal')
        title(selectivity)
    end
    savePNG(gcf, 300, [figure_dir, ['selectivity ', column, '.png']])
end


selectivities = {{'math only'},{'episodic only', 'autobio only'}};
columns = {'DK_long_josef'};
figure('units', 'normalized', 'outerposition', [0 0 1 1])
for ic = 1:length(columns)
    for i = 1:length(selectivities)
        selectivity = selectivities{i};
        column = columns{ic};
        subplot(1,2,i)
        if strcmp(selectivity, 'math deact') == 1
            el_tmp = el_selectivity_calc_sim(el_selectivity_calc_sim.act_deact_cond1 == -1,:);
        elseif contains(selectivity, {'autobio deact',  'episodic deact'}) == 2
            el_tmp = el_selectivity_calc_sim(el_selectivity_calc_sim.act_deact_cond2 == -1,:);
        else
            el_tmp = el_selectivity_calc_sim(contains(el_selectivity_calc_sim.elect_select, selectivity),:);
        end
        plot_frequency(el_tmp, column, 'ascend', 'horizontal')
        title(selectivity)
    end
    savePNG(gcf, 300, [figure_dir, ['selectivity ', column, '.png']])
end

%% Plot coverage selectivity

% Plot coverage by task group
el_selectivity_only = el_selectivity_calc_sim(contains(el_selectivity_calc_sim.elect_select, 'only'),:);


cfg = getPlotCoverageCFG('tasks_group'); 
cfg.MarkerSize = 10;
cfg.alpha = 0.5;
cfg.views = {'lateral', 'lateral', 'ventral', 'ventral'};
cfg.hemis = {'left', 'right', 'right', 'left'};
cfg.subplots = [2,2];
cfg.figureDim = [0 0 1 1];
            
load('cdcol_2018.mat')
for i = 1:size(el_selectivity_only,1)
    if contains(el_selectivity_only.elect_select{i}, 'math') == 1
        cfg.MarkerColor(i,:) = cdcol.light_cadmium_red;
    else
        cfg.MarkerColor(i,:) = cdcol.sapphire_blue;
    end
end
PlotModulation(dirs, el_selectivity_only, cfg)
savePNG(gcf, 600, [figure_dir, 'MMR_selectivity_brain_only.png'])



el_selectivity_selective = el_selectivity_calc_sim(contains(el_selectivity_calc_sim.elect_select, 'selective'),:);
load('cdcol_2018.mat')
for i = 1:size(el_selectivity_selective,1)
    if contains(el_selectivity_selective.elect_select{i}, 'math selective') == 1
        cfg.MarkerColor(i,:) = cdcol.light_cadmium_red;
    else
        cfg.MarkerColor(i,:) = cdcol.sapphire_blue;
    end
end
PlotModulation(dirs, el_selectivity_selective, cfg)
savePNG(gcf, 300, [figure_dir, 'MMR_selectivity_brain_selective.png'])



el_selectivity_math_deact = el_selectivity_calc_sim(el_selectivity_calc_sim.act_deact_cond1 == -1,:);
el_selectivity_math_deact(~strcmp(el_selectivity_math_deact.Yeo7, 'Somatomotor'),:)
load('cdcol_2018.mat')
for i = 1:size(el_selectivity_math_deact,1)
    if contains(el_selectivity_math_deact.elect_select{i}, 'math selective') == 1
        cfg.MarkerColor(i,:) = cdcol.light_cadmium_red;
    else
        cfg.MarkerColor(i,:) = cdcol.sapphire_blue;
    end
end
PlotModulation(dirs, el_selectivity_math_deact, cfg)
savePNG(gcf, 300, [figure_dir, 'MMR_el_selectivity_math_deact.png'])





%% MEMORIA

task = 'Memoria';    
sinfo_Memoria = sinfo(strcmp(sinfo.task, task),:);    
el_selectivity_Memoria = concat_elect_select(sinfo_Memoria.sbj_name, task, dirs, vars);
el_selectivity_Memoria = el_selectivity_Memoria(strcmp(el_selectivity_Memoria.WMvsGM, 'GM') | strcmp(el_selectivity_Memoria.WMvsGM, 'WM'), :);
el_selectivity_Memoria = el_selectivity_Memoria(~strcmp(el_selectivity_Memoria.Yeo7, 'FreeSurfer_Defined_Medial_Wall'),:)

selectivities = {{'math only'}, {'math selective'}, {'math deact'}, {'no selectivity'}, {'autobio only'}, {'autobio selective'}, {'autobio deact'}, {'math and autobio'}};
columns = {'Yeo7', 'DK_lobe'};
figure('units', 'normalized', 'outerposition', [0 0 1 1])
for ic = 1:length(columns)
    for i = 1:length(selectivities)
        selectivity = selectivities{i};
        column = columns{ic};
        subplot(2,4,i)
        if strcmp(selectivity, 'math deact') == 1
            el_tmp = el_selectivity_Memoria(el_selectivity_Memoria.act_deact_cond1 == -1,:);
        elseif contains(selectivity, {'autobio deact',  'episodic deact'}) == 2
            el_tmp = el_selectivity_Memoria(el_selectivity_Memoria.act_deact_cond2 == -1,:);
        else
            el_tmp = el_selectivity_Memoria(contains(el_selectivity_Memoria.elect_select, selectivity),:);
        end
        plot_frequency(el_tmp, column, 'ascend', 'horizontal')
        title(selectivity)
    end
    savePNG(gcf, 300, [figure_dir, ['Memoria_selectivity ', column, '.png']])
end


selectivities = {{'math only'},{'episodic only', 'autobio only'}};
columns = {'DK_long_josef'};
figure('units', 'normalized', 'outerposition', [0 0 1 1])
for ic = 1:length(columns)
    for i = 1:length(selectivities)
        selectivity = selectivities{i};
        column = columns{ic};
        subplot(1,2,i)
        if strcmp(selectivity, 'math deact') == 1
            el_tmp = el_selectivity_Memoria(el_selectivity_Memoria.act_deact_cond1 == -1,:);
        elseif contains(selectivity, {'autobio deact',  'episodic deact'}) == 2
            el_tmp = el_selectivity_Memoria(el_selectivity_Memoria.act_deact_cond2 == -1,:);
        else
            el_tmp = el_selectivity_Memoria(contains(el_selectivity_Memoria.elect_select, selectivity),:);
        end
        plot_frequency(el_tmp, column, 'ascend', 'horizontal')
        title(selectivity)
    end
    savePNG(gcf, 300, [figure_dir, ['Memoria_selectivity ', column, '.png']])
end



el_selectivity_only = el_selectivity_Memoria(contains(el_selectivity_Memoria.elect_select, 'only'),:);


cfg = getPlotCoverageCFG('tasks_group'); 
cfg.MarkerSize = 10;
cfg.alpha = 0.5;
cfg.views = {'lateral', 'lateral', 'ventral', 'ventral'};
cfg.hemis = {'left', 'right', 'right', 'left'};
cfg.subplots = [2,2];
cfg.figureDim = [0 0 1 1];
            
load('cdcol_2018.mat')
for i = 1:size(el_selectivity_only,1)
    if contains(el_selectivity_only.elect_select{i}, 'math') == 1
        cfg.MarkerColor(i,:) = cdcol.light_cadmium_red;
    else
        cfg.MarkerColor(i,:) = cdcol.sapphire_blue;
    end
end
PlotModulation(dirs, el_selectivity_only, cfg)
savePNG(gcf, 600, [figure_dir, 'Memoria_selectivity_brain_only.png'])


el_selectivity_selective = el_selectivity_Memoria(contains(el_selectivity_Memoria.elect_select, 'selective'),:);


load('cdcol_2018.mat')
for i = 1:size(el_selectivity_selective,1)
    if contains(el_selectivity_selective.elect_select{i}, 'math selective') == 1
        cfg.MarkerColor(i,:) = cdcol.light_cadmium_red;
    else
        cfg.MarkerColor(i,:) = cdcol.sapphire_blue;
    end
end
PlotModulation(dirs, el_selectivity_selective, cfg)
savePNG(gcf, 300, [figure_dir, 'Memoria_selectivity_brain_selective.png'])



%% ALL MATH
el_selectivity_all_calc = [el_selectivity_Memoria; el_selectivity_calc_sim];


selectivities = {{'math only'}, {'math selective'}, {'math deact'}, {'no selectivity'}, {'episodic only', 'autobio only'}, {'episodic selective', 'autobio selective'}, {'autobio deact',  'episodic deact'}, {'math and episodic', 'math and autobio'}};
columns = {'Yeo7', 'DK_lobe'};
figure('units', 'normalized', 'outerposition', [0 0 1 1])
for ic = 1:length(columns)
    for i = 1:length(selectivities)
        selectivity = selectivities{i};
        column = columns{ic};
        subplot(2,4,i)
        if strcmp(selectivity, 'math deact') == 1
            el_tmp = el_selectivity_all_calc(el_selectivity_all_calc.act_deact_cond1 == -1,:);
        elseif contains(selectivity, {'autobio deact',  'episodic deact'}) == 2
            el_tmp = el_selectivity_all_calc(el_selectivity_all_calc.act_deact_cond2 == -1,:);
        else
            el_tmp = el_selectivity_all_calc(contains(el_selectivity_all_calc.elect_select, selectivity),:);
        end
        plot_frequency(el_tmp, column, 'ascend', 'horizontal')
        title(selectivity)
    end
    savePNG(gcf, 300, [figure_dir, ['Calc_all_selectivity ', column, '.png']])
end
close all


selectivities = {{'math only'},{'episodic only', 'autobio only'}};
columns = {'DK_long_josef'};
figure('units', 'normalized', 'outerposition', [0 0 1 1])
for ic = 1:length(columns)
    for i = 1:length(selectivities)
        selectivity = selectivities{i};
        column = columns{ic};
        subplot(1,2,i)
        if strcmp(selectivity, 'math deact') == 1
            el_tmp = el_selectivity_all_calc(el_selectivity_all_calc.act_deact_cond1 == -1,:);
        elseif contains(selectivity, {'autobio deact',  'episodic deact'}) == 2
            el_tmp = el_selectivity_all_calc(el_selectivity_all_calc.act_deact_cond2 == -1,:);
        else
            el_tmp = el_selectivity_all_calc(contains(el_selectivity_all_calc.elect_select, selectivity),:);
        end
        plot_frequency(el_tmp, column, 'ascend', 'horizontal')
        title(selectivity)
    end
    savePNG(gcf, 300, [figure_dir, ['Calc_all_selectivity ', column, '.png']])
end
close all




el_selectivity_only = el_selectivity_all_calc(contains(el_selectivity_all_calc.elect_select, 'only'),:);
sort_tabulate(el_selectivity_only.elect_select, 'descend')

cfg = getPlotCoverageCFG('tasks_group'); 
cfg.MarkerSize = 10;
cfg.alpha = 0.8;
cfg.views = {'lateral', 'lateral', 'ventral', 'medial', 'medial', 'ventral',};
cfg.hemis = {'left', 'right', 'left', 'left', 'right', 'right', };
cfg.subplots = [2,3];
cfg.figureDim = [0 0 1 1];
            
load('cdcol_2018.mat')
for i = 1:size(el_selectivity_only,1)
    if contains(el_selectivity_only.elect_select{i}, 'math') == 1
        cfg.MarkerColor(i,:) = cdcol.light_cadmium_red;
    else
        cfg.MarkerColor(i,:) = cdcol.sapphire_blue;
    end
end
PlotModulation(dirs, el_selectivity_only, cfg)
savePNG(gcf, 600, [figure_dir, 'All_calc_selectivity_brain_only.png'])


el_selectivity_selective = el_selectivity_all_calc(contains(el_selectivity_all_calc.elect_select, 'selective'),:);


load('cdcol_2018.mat')
for i = 1:size(el_selectivity_selective,1)
    if contains(el_selectivity_selective.elect_select{i}, 'math selective') == 1
        cfg.MarkerColor(i,:) = cdcol.light_cadmium_red;
    else
        cfg.MarkerColor(i,:) = cdcol.sapphire_blue;
    end
end
PlotModulation(dirs, el_selectivity_selective, cfg)
savePNG(gcf, 300, [figure_dir, 'All_calc_selectivity_brain_selective.png'])


%% Calculia

task = 'Calculia';    
sinfo_Calculia = sinfo(strcmp(sinfo.task, task),:);    
sinfo_Calculia(contains(sinfo_Calculia.sbj_name, {'S14_74_OD', 'S15_87_RL', 'S16_95_JOB', 'S15_83_RR', 'S16_96_LF'}),:) = [];
el_selectivity_Calculia = concat_elect_select(sinfo_Calculia.sbj_name, task, dirs, vars);
el_selectivity_Calculia = el_selectivity_Calculia(strcmp(el_selectivity_Calculia.WMvsGM, 'GM') | strcmp(el_selectivity_Calculia.WMvsGM, 'WM'), :);
el_selectivity_Calculia = el_selectivity_Calculia(~strcmp(el_selectivity_Calculia.Yeo7, 'FreeSurfer_Defined_Medial_Wall'),:)

selectivities = {{'math only'}, {'math selective'}, {'math deact'}, {'no selectivity'}, {'autobio only'}, {'autobio selective'}, {'autobio deact'}, {'math and autobio'}};
columns = {'Yeo7', 'DK_lobe'};
figure('units', 'normalized', 'outerposition', [0 0 1 1])
for ic = 1:length(columns)
    for i = 1:length(selectivities)
        selectivity = selectivities{i};
        column = columns{ic};
        subplot(2,4,i)
        el_tmp = el_selectivity_Memoria(contains(el_selectivity_Memoria.elect_select, selectivity),:);
        plot_frequency(el_tmp, column, 'ascend', 'horizontal')
        title(selectivity)
    end
    savePNG(gcf, 300, [figure_dir, ['Memoria_selectivity ', column, '.png']])
end


el_selectivity_only = el_selectivity_Calculia(~contains(el_selectivity_Calculia.elect_select, {'no selectivity', 'digit_active and letter_active'}),:);

el_selectivity_only = el_selectivity_Calculia(contains(el_selectivity_Calculia.elect_select, {'only'}),:);
sort_tabulate(el_selectivity_only.elect_select, 'descend')

cfg = getPlotCoverageCFG('tasks_group'); 
cfg.MarkerSize = 10;
cfg.alpha = 0.5;
cfg.views = {'lateral', 'lateral', 'ventral', 'medial', 'medial', 'ventral',};
cfg.hemis = {'left', 'right', 'left', 'left', 'right', 'right', };
cfg.subplots = [2,3];
cfg.figureDim = [0 0 1 1];
            
load('cdcol_2018.mat')
for i = 1:size(el_selectivity_only,1)
    if contains(el_selectivity_only.elect_select{i}, {'digit_active selective', 'digit_active only'}) == 1
        cfg.MarkerColor(i,:) = cdcol.light_cadmium_red;
    elseif contains(el_selectivity_only.elect_select{i}, {'letter_active selective', 'letter_active only'}) == 1
        cfg.MarkerColor(i,:) = cdcol.sapphire_blue;
    else
        cfg.MarkerColor(i,:) = [0 0 0];
    end
end
PlotModulation(dirs, el_selectivity_only, cfg)
savePNG(gcf, 300, [figure_dir, 'Calculia_only_brain_selective.png'])


%% Viz proportions
el_selectivity = simplify_selectivity(el_selectivity_all_calc, 'MMR');
sort_tabulate(el_selectivity.elect_select, 'descend')

el_selectivity_only = el_selectivity(contains(el_selectivity.elect_select, 'only'), :)
el_selectivity_only = el_selectivity_only(~contains(el_selectivity_only.Yeo7, 'Depth'),:)


conditions = {'math', 'memory'};
Yeo7_networks = {'Frontoparietal', 'Dorsal Attention', 'Default', 'Limbic',  'Ventral Attention','Visual', 'Somatomotor'};

frequencies = [];
for i = 1:length(conditions)
    tmp_Yeo7 = el_selectivity_only(contains(el_selectivity_only.elect_select, conditions{i}),:);
    tmp_Yeo7 = sort_tabulate(tmp_Yeo7.Yeo7, 'descend');
    for in = 1:length(Yeo7_networks)
        frequencies(i,in) = tmp_Yeo7{strcmp(tmp_Yeo7.value, Yeo7_networks{in}), 2};
    end
end
frequencies = frequencies'

% frequencies = flip(frequencies');
[frequencies, idx] = sortrows(frequencies, 1, 'descend')
frequencies = flip(frequencies);
Yeo7_networks = Yeo7_networks(idx)
Yeo7_networks = flip(Yeo7_networks)

ba = barh(frequencies, 'stacked' ,'EdgeColor', 'k','LineWidth',2)
ba(1).FaceColor = cdcol.light_cadmium_red;
ba(2).FaceColor = cdcol.sapphire_blue

set(gca,'fontsize',16)
xlabel('Number of electrodes')
yticks(1:length(Yeo7_networks))
ylim([0, length(Yeo7_networks)+1])
yticklabels(Yeo7_networks)
set(gca,'TickLabelInterpreter','none')

for i = 1:length(conditions)
    for in = 1:length(Yeo7_networks)
        if i == 1
            txt = text(frequencies(in,i)-1,in, num2str(frequencies(in,i)), 'FontSize', 20, 'HorizontalAlignment', 'right', 'Color', 'w');
        elseif i > 1
            txt = text(frequencies(in,i)+sum(frequencies(in,1:i-1))-1,in, num2str(frequencies(in,i)), 'FontSize', 20, 'HorizontalAlignment', 'right', 'Color', 'w');
        end
    end
end
title('Frequency of math vs. memory only sites per intrinsic network')
savePNG(gcf, 300, [figure_dir, 'math_all_frequencies_Yeo7_stacked.png'])






conditions = {'math', 'memory'};
hemis = {'L', 'R'};

frequencies = [];
for i = 1:length(conditions)
    LvsR = el_selectivity_only(contains(el_selectivity_only.elect_select, conditions{i}),:);
    LvsR = sort_tabulate(LvsR.LvsR, 'descend');
    for in = 1:length(hemis)
        frequencies(i,in) = LvsR{strcmp(LvsR.value, hemis{in}), 2};
    end
end
frequencies = frequencies'

% frequencies = flip(frequencies');
[frequencies, idx] = sortrows(frequencies, 1, 'descend')
frequencies = frequencies;
hemis = hemis(idx)
hemis = flip(hemis)

ba = bar(frequencies, 'stacked' ,'EdgeColor', 'k','LineWidth',2)
ba(1).FaceColor = cdcol.light_cadmium_red;
ba(2).FaceColor = cdcol.sapphire_blue

set(gca,'fontsize',16)
ylabel('Number of electrodes')
xlim([0, length(hemis)+1])
xlabel('Hemispheres')
xticklabels({'Left', 'Right'})
set(gca,'TickLabelInterpreter','none')

for i = 1:length(conditions)
    for in = 1:length(Yeo7_networks)
        if i == 1
            txt = text(in, frequencies(in,i)-1, num2str(frequencies(in,i)), 'FontSize', 20, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'Color', 'w');
        elseif i > 1
            txt = text(in, frequencies(in,i)+sum(frequencies(in,1:i-1))-1, num2str(frequencies(in,i)), 'FontSize', 20, 'HorizontalAlignment', 'center',  'VerticalAlignment', 'top', 'Color', 'w');
        end
    end
end
title('Frequency of math vs. memory only sites per hemi network')
savePNG(gcf, 300, [figure_dir, 'math_all_frequencies_hemi_stacked.png'])



[DOCID,GID] = getGoogleSheetInfo('math_network','cohort');
sinfo = GetGoogleSpreadsheet(DOCID, GID);
subject_names = sinfo.sbj_name;
sinfo = sinfo(strcmp(sinfo.subjVar, '1'),:);
% Filer for usable dat
subjects = unique(sinfo.sbj_name);


parfor i = 1:length(subjects)
    CreateSubjVar(subjects{i}, comp_root, server_root, code_root)
end
































