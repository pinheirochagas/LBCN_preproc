function PlotCoverageHeatmap(sbj_name,project_name, coords, colors_plot, col_idx, dirs)

cortex = getcort(dirs);

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
    views = [1 2 4];
    for i = 1:length(views)
        subplot(1,length(views),i)
        coords_plot = CorrectElecLoc(coords, views(i), hemisphere);
        ctmr_gauss_plot(cortex.(hemisphere),[0 0 0], 0, hemisphere(1), views(i))
        for ii = 1:length(coords)
            plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', 15, 'MarkerFaceColor', colors_plot(col_idx(ii),:), 'MarkerEdgeColor', 'k');
        end
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
    savePNG(gcf, 300, [dirs.result_root '/coverage_heatmap/' sbj_name '.png']); % ADD TASK AND CONDITION
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
        coords_plot(:,3) = coords_plot(:,3) - 10;
    end
end
end