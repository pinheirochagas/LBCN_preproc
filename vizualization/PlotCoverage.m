function PlotCoverage(sbj_name,project_name)

dirs = InitializeDirs('Pedro_iMAC', project_name, sbj_name); % 'Pedro_NeuroSpin2T'
fsDir_local = '/Applications/freesurfer/subjects/fsaverage';
cortex = getcort(dirs);
coords = importCoordsFreesurfer(dirs);
elect_names = importElectNames(dirs);

[DOCID,GID] = getGoogleSheetInfo(project_name);
googleSheet = GetGoogleSpreadsheet(DOCID, GID);
hemisphere = googleSheet.hemi(strcmp(googleSheet.subject_name, sbj_name));
hemisphere = hemisphere{1};

%% Plot electrodes as dots in native space
if ~strcmp(hemisphere, 'left') && ~strcmp(hemisphere, 'right')
    warning([ sbj_name ' skipped: coverage was in both hemi - do it manually.'])
else
    
    figureDim = [0 0 1 .4];
    figure('units', 'normalized', 'outerposition', figureDim)
    load('cdcol.mat')
    views = [1 2 4];
    for i = 1:length(views)
        subplot(1,length(views),i)
        ctmr_gauss_plot(cortex.(hemisphere),[0 0 0], 0, hemisphere(1), views(i))
        f1 = plot3(coords(:,1),coords(:,2),coords(:,3), 'o', 'MarkerSize', 10, 'MarkerFaceColor', cdcol.light_cadmium_red, 'MarkerEdgeColor', cdcol.light_cadmium_red);
        alpha(0.7)
    end
    light('Position',[1 0 0])
    text(350,90,sbj_name, 'Interpreter', 'none', 'FontSize', 30)
    savePNG(gcf, 300, [dirs.result_root '/coverage/' sbj_name '.png']);
    close all
end

end