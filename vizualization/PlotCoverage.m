function PlotCoverage(sbj_name,project_name)

dirs = InitializeDirs('Pedro_iMAC', project_name, sbj_name); % 'Pedro_NeuroSpin2T'
load('cdcol.mat')
fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
cortex = getcort(dirs);
coords = importCoordsFreesurfer(dirs);
elect_names = importElectNames(dirs);

[DOCID,GID] = getGoogleSheetInfo(project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
hemisphere = googleSheet.hemi{strcmp(googleSheet.subject_name, sbj_name)};
implant = googleSheet.implant{strcmp(googleSheet.subject_name, sbj_name)};

%% Plot electrodes as dots in native space
if ~strcmp(hemisphere, 'left') && ~strcmp(hemisphere, 'right')
    warning([ sbj_name ' skipped: coverage was in both hemi - do it manually.'])
else
    
    figureDim = [0 0 1 .4];
    figure('units', 'normalized', 'outerposition', figureDim)
    views = [1 2 4];
    for i = 1:length(views)
        subplot(1,length(views),i)
        coords_plot = CorrectElecLoc(coords, views(i), hemisphere);
        ctmr_gauss_plot(cortex.(hemisphere),[0 0 0], 0, hemisphere(1), views(i))
        f1 = plot3(coords_plot(:,1),coords_plot(:,2),coords_plot(:,3), 'o', 'MarkerSize', 10, 'MarkerFaceColor', cdcol.light_cadmium_red, 'MarkerEdgeColor', cdcol.light_cadmium_red);
        if strcmp(implant, 'sEEG')
            alpha(0.7)
        else
        end
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
if views == 1
    if strcmp(hemisphere, 'right')
        coords_plot(:,1) = coords_plot(:,1) + 5;
    elseif strcmp(hemisphere, 'left')
        coords_plot(:,1) = coords_plot(:,1) - 5;
    end
elseif views == 2
    if strcmp(hemisphere, 'right')
        coords_plot(:,1) = coords_plot(:,1) - 5;
    elseif strcmp(hemisphere, 'left')
        coords_plot(:,1) = coords_plot(:,1) + 5;
    end
elseif views == 4
    if strcmp(hemisphere, 'right')
        coords_plot(:,3) = coords_plot(:,3) - 5;
    end
end
end