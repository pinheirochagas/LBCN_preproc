function PlotCoverageElect(subjVar,correction_factor, ifsave, savefold)
% This function plots the electrodes on native brain, requiring only
% subjVar (which should have elinfo table), correction factor (default: 0)
% and ifsave (true/false) to save the plots to savefold 
% (savefold/Individual_Coverage/[subj_name]).


load('cdcol_2018.mat')
marker_size = 6;

figureDim = [0 0 .4 1];
% figureDim = [0 0 1 .4];


figure('units', 'normalized', 'outerposition', figureDim)
views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right', 'left', 'right'};

if nargin == 1
    correction_factor = 0;
    ifsave = false;
elseif nargin == 2
    ifsave = false;
elseif nargin == 3 && ifsave == true
    savefold = uigetdir('/Volumes/');
end

for i = 1:length(views)
    subplot(3,2,i)    
    coords_plot = CorrectElecLoc(subjVar.elinfo.LEPTO_coord, views{i}, hemis{i}, correction_factor);
    ctmr_gauss_plot(subjVar.cortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
    
    for ii = 1:length(coords_plot)
        if (strcmp(hemis{i}, 'left') && strcmpi(subjVar.elinfo.LvsR{ii},'L'))
%             plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
            plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', cdcol.light_cadmium_red, 'MarkerEdgeColor', cdcol.light_cadmium_red);
        elseif (strcmp(hemis{i}, 'right') && strcmpi(subjVar.elinfo.LvsR{ii},'R'))
%             plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
            plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', cdcol.light_cadmium_red, 'MarkerEdgeColor', cdcol.light_cadmium_red);
        end
    end    
    alpha(0.7)
end

if ifsave
    if ~exist([savefold filesep 'Individual_Coverage'],'dir')
        mkdir([savefold filesep 'Individual_Coverage'])
    end
    savePNG(gcf, 300, [savefold filesep 'Individual_Coverage' filesep subjVar.sbj_name '_coverage.png']);
    close all
end
end

%% Function to optimize electrode location for plotting
function coords_plot = CorrectElecLoc(coords, views, hemisphere, correction_factor)
coords_plot = coords;
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


%
%
%
%
%
% if plot_label
%         for it = 1:length(coords_plot)
%             hold on
%             if (strcmp(hemis{i}, 'left') == 1 && coords_plot(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && coords_plot(ii,1) < 0)
%             else
%                 text(coords_plot(it,1),coords_plot(it,2),coords_plot(it,3), subjVar.labels(it), 'FontSize', 7);
%             end
%         end
%     else
%     end