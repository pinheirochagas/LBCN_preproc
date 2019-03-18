function PlotCoverageElect(subjVar, elect, correction_factor)


load('cdcol_2018.mat')
marker_size = 6;
marker_size_hl = 22;

figureDim = [0 0 .4 1];
% figureDim = [0 0 1 .4];


figure('units', 'normalized', 'outerposition', figureDim)
views = {'lateral', 'lateral', 'medial', 'medial', 'ventral', 'ventral'};
hemis = {'left', 'right', 'left', 'right', 'left', 'right'};
%
% views = {'lateral', 'ventral'};
% hemis = {'left', 'left'};

for i = 1:length(views)
    subplot(3,2,i)
    %     subplot(1,2,i)
    
    coords_plot = CorrectElecLoc(subjVar.elinfo.LEPTO_coord, views{i}, hemis{i}, correction_factor);
    ctmr_gauss_plot(subjVar.cortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
    %     f1 = plot3(coords_plot(:,1),coords_plot(:,2),coords_plot(:,3), 'o', 'MarkerSize', 10, 'MarkerFaceColor', cdcol.light_cadmium_red, 'MarkerEdgeColor', cdcol.light_cadmium_red);
    
    for ii = setdiff([1:length(coords_plot)], elect)
        % Only plot on the relevant hemisphere
        if (strcmp(hemis{i}, 'left') == 1 && coords_plot(ii,1) > 0) || (strcmp(hemis{i}, 'right') == 1 && coords_plot(ii,1) < 0)
        else
            plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', marker_size, 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'k');
        end
        
    end
    
    plot3(coords_plot(elect,1),coords_plot(elect,2),coords_plot(elect,3), 'o', 'MarkerSize', marker_size_hl, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');
    
    alpha(0.7)
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