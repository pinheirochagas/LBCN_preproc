function PlotCoverage(sbj_name,project_name, dirs, plot_label)


% Load subjVar 
if exist([dirs.original_data filesep sbj_name filesep 'subjVar_' sbj_name '.mat'], 'file')
    load([dirs.original_data filesep sbj_name filesep 'subjVar_' sbj_name '.mat']);
else
    center = 'Stanford';
    fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
    [fs_iEEG, fs_Pdio, data_format] = GetFSdataFormat(sbj_name, center);
    subjVar = CreateSubjVar(sbj_name, dirs, data_format, fsDir_local);
end

%% Load a given globalVar
% if plot_label
%     gv_dir = dir(fullfile([dirs.data_root filesep 'originalData/' sbj_name]));
%     gv_inds = arrayfun(@(x) contains(x.name, 'global'), gv_dir);
%     fn_tmp = gv_dir(gv_inds);
%     load([fn_tmp(1).folder filesep fn_tmp(1).name])
% else
% end

load('cdcol_2018.mat')
[DOCID,GID] = getGoogleSheetInfo('math_network', project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
hemisphere = googleSheet.hemi{strcmp(googleSheet.subject_name, sbj_name)};
implant = googleSheet.implant{strcmp(googleSheet.subject_name, sbj_name)};

%% Plot electrodes as dots in native space
if ~strcmp(hemisphere, 'left') && ~strcmp(hemisphere, 'right')
    warning([ sbj_name ' skipped: coverage was in both hemi - do it manually.'])
else
    
    figureDim = [0 0 1 .4];
    figure('units', 'normalized', 'outerposition', figureDim)
    views = {'lateral', 'medial', 'ventral'};
    for i = 1:length(views)
        subplot(1,length(views),i)
        coords_plot = CorrectElecLoc(subjVar.native_coord, views{i}, hemisphere);
        ctmr_gauss_plot(subjVar.cortex.(hemisphere),[0 0 0], 0, hemisphere(1), views{i})
        f1 = plot3(coords_plot(:,1),coords_plot(:,2),coords_plot(:,3), 'o', 'MarkerSize', 10, 'MarkerFaceColor', cdcol.light_cadmium_red, 'MarkerEdgeColor', cdcol.light_cadmium_red);
        
        if plot_label
            for it = 1:length(elecs)
                hold on
                text(coords_plot(it,1),coords_plot(it,2),coords_plot(it,3), num2str(globalVar.label(it)), 'FontSize', 20);
            end        
        else
        end



        if strcmp(implant, 'sEEG')
            alpha(0.7)
        else
        end
        alpha(0.7)
        if i == 2
            yl = ylim;
            xl = xlim;
            zl = zlim;
            text(sum(xl)/2,sum(yl)/2,zl(2)+zl(2)*0.1,sbj_name, 'Interpreter', 'none', 'FontSize', 30, 'HorizontalAlignment', 'Center')
        else
        end
    end
    light('Position',[1 0 0])
    savePNG(gcf, 300, [dirs.result_root '/coverage/' sbj_name '.png']);
    close all
end


end

%% Function to optimize electrode location for plotting
function coords_plot = CorrectElecLoc(coords, views, hemisphere)
coords_plot = coords;
correction_factor = 10;
switch views
    case 'lateral'
        if strcmp(hemisphere, 'right')
            coords_plot(:,1) = coords_plot(:,1) + correction_factor;
        elseif strcmp(hemisphere, 'left')
            coords_plot(:,1) = coords_plot(:,1) - correction_factor;
        end
    case 'medial'
        if strcmp(hemisphere, 'right')
            coords_plot(:,1) = coords_plot(:,1) - correction_factor;
        elseif strcmp(hemisphere, 'left')
            coords_plot(:,1) = coords_plot(:,1) + correction_factor;
        end
    case 'ventral'
            coords_plot(:,3) = coords_plot(:,3) - correction_factor;
end
end