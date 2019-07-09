function PlotCoverageGroup(coords, cfg)


%% Load comon brain (replace by fsaverage)
% load([dirs.code_root filesep 'vizualization/Colin_cortex_left.mat']);
% cmcortex.left = cortex;
% load([dirs.code_root filesep 'vizualization/Colin_cortex_right.mat']);
% cmcortex.right = cortex;
%
%
% [DOCID,GID] = getGoogleSheetInfo('math_network', project_name);
% googleSheet = GetGoogleSpreadsheet(DOCID, GID);
% implant = googleSheet.implant{strcmp(googleSheet.subject_name, sbj_name)};


[cmcortex.right.vert cmcortex.right.tri]=read_surf(fullfile('/Applications/freesurfer/subjects/fsaverage/surf',['rh.' 'pial']));
[cmcortex.left.vert cmcortex.left.tri]=read_surf(fullfile('/Applications/freesurfer/subjects/fsaverage/surf',['lh.' 'pial']));


%% Plot electrodes as dots in native space
views = {'lateral', 'lateral', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right'};

figure('units', 'normalized', 'outerposition', [0 0 .5 1])
for i = 1:length(views)
    subplot(2,2,i)
    coords_plot = CorrectElecLoc(coords, views{i}, hemis{i}, cfg.CorrectFactor);
    ctmr_gauss_plot(cmcortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
    
    for ii = 1:length(coords_plot)
        % Only plot on the relevant hemisphere
        if (strcmp(hemis{i}, 'left') == 1 && coords_plot(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && coords_plot(ii,1) < 0)
        else
            plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', 8, 'MarkerFaceColor',[0 0 0], 'MarkerEdgeColor', [0 0 0]);
        end
        
        if ~isempty(cfg.chan_highlight)
            for hi = 1:length(cfg.chan_highlight)
                if (strcmp(hemis{i}, 'left') == 1 && coords_plot(cfg.chan_highlight(hi),1) > 0) || (strcmp(hemis{i}, 'right') == 1 && coords_plot(cfg.chan_highlight(hi),1) < 0)
                else
                    plot3(coords_plot(cfg.chan_highlight(hi),1),coords_plot(cfg.chan_highlight(hi),2),coords_plot(cfg.chan_highlight(hi),3), 'o', 'MarkerSize', 12, 'MarkerFaceColor', [1 0 0], 'MarkerEdgeColor', [1 0 0]);
                end
            end
        end
        
    end
    
    alpha(cfg.alpha)
end

end

