function MakeVideoActivationTime_lite(data, elinfo,cfg, dirs)


if cfg.project_left
    elinfo.MNI_coord(:,1) = -abs(elinfo.MNI_coord(:,1));
    elinfo.LvsR = repmat({'L'}, size(elinfo,1),1);
end

%% Load template brain
[cmcortex.right.vert cmcortex.right.tri]=read_surf(fullfile('/Applications/freesurfer/subjects/fsaverage/surf',['rh.' 'pial']));
[cmcortex.left.vert cmcortex.left.tri]=read_surf(fullfile('/Applications/freesurfer/subjects/fsaverage/surf',['lh.' 'pial']));

%% Get indices for colloring
% data.wave(data.wave>cfg.c_lim(2)) = data.wave(data.wave>cfg.c_lim(2))/max(data.wave(data.wave>cfg.c_lim(2))) * cfg.c_lim(2);

[col_idx, rgb, cols] = vals2colormap(data.wave(:), 'Reds');

col_idx = reshape(col_idx,size(data.wave,1), size(data.wave,2));


x = rand(length(cols),1);
y = rand(length(cols),1);
% 
% for i = 1:length(cols)
%     hold on
%     plot(x(i),y(i), '.', 'MarkerSize', 40, 'Color', cols(i,:));
%     
% end
%% Plot parameters
mark = 'o';
MarkSizeEffect = 10;
colRing = [0 0 0]/255;
time = data.time(find(data.time > cfg.time_lim(1),1):max(find(data.time <= cfg.time_lim(2))));

% Define channels to plot
coords_plot = elinfo.MNI_coord;

%% Plot math
views =  cfg.views;
hemis = cfg.hemis;

F = struct;
count = 0;

% cfg.stim_times = [0, 1, 2, 3]

for e = 1:1:length(time)
    count = count+1;
    f1 = figure('units', 'normalized', 'outerposition', cfg.figureDim);
    
    for i = 1:length(views)
        subplot(cfg.subplots(1),cfg.subplots(2),i)
%         coords_plot = CorrectElecLoc(coords_plot, views{i}, hemis{i}, elinfo.sEEG_ECoG, cfg.CorrectFactor); %
        ctmr_gauss_plot(cmcortex.(hemis{i}),[0 0 0], 0, hemis{i}, views{i})
        
        for ii = 1:size(coords_plot,1)
            % Only plot on the relevant hemisphere
            if ~isnan(col_idx(ii))
                if (strcmp(hemis{i}, 'left') == 1 && strcmp(elinfo.LvsR(ii), 'R') == 1) || (strcmp(hemis{i}, 'right') == 1 && strcmp(elinfo.LvsR(ii), 'L') == 1)
                else
%                     plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', MarkSizeEffect*abs(data.wave(ii,e)), 'MarkerFaceColor', cols(col_idx(ii,e),:), 'MarkerEdgeColor', 'k');
%                     col_idx(ii,e)
                    plot3(coords_plot(ii,1),coords_plot(ii,2),coords_plot(ii,3), 'o', 'MarkerSize', round(MarkSizeEffect*(1+data.wave(ii,e)/4)), 'MarkerFaceColor', cols(col_idx(ii,e),:), 'MarkerEdgeColor', 'k');
                end
            else
            end
        end
        
        
        alpha(cfg.alpha)
        
        
        time_tmp = num2str(time(e));
        
        if length(time_tmp) < 6
            time_tmp = [time_tmp '00'];
        end
        
        if strcmp(time_tmp(1), '-')
            time_tmp = time_tmp(1:6);
        elseif ~strcmp(time_tmp(1), '-') && ~strcmp(time_tmp, '000') && length(time_tmp) > 3
            time_tmp = time_tmp(1:5);
        elseif strcmp(time_tmp, '000')
            time_tmp = time_tmp(1);
        end
        
        
        text(0, 0, -80, [time_tmp ' s'], 'FontSize', 40, 'HorizontalAlignment', 'center')
        
%         if time(e) > cfg.times(1) && time(e) < cfg.times(1) + .5
%            text(0, 0, 85, 'X', 'FontSize', 50, 'HorizontalAlignment', 'center', 'Color', 'k')
%         elseif time(e) > cfg.times(2) && time(e) < cfg.times(2) + .5
%            text(0, 0, 85, '+', 'FontSize', 50, 'HorizontalAlignment', 'center', 'Color', 'k')
%         elseif time(e) > cfg.times(3) && time(e) < cfg.times(3) + .5
%            text(0, 0, 85, 'Y', 'FontSize', 50, 'HorizontalAlignment', 'center', 'Color', 'k')
%         elseif time(e) > cfg.times(4) && time(e) < cfg.times(4) + .5
%            text(0, 0, 85, '=', 'FontSize', 50, 'HorizontalAlignment', 'center', 'Color', 'k')
%         elseif time(e) > cfg.times(5) && time(e) < cfg.times(5) + .5
%            text(0, 0, 85, 'Z', 'FontSize', 50, 'HorizontalAlignment', 'center', 'Color', 'k')
%         else
%         end
        
%         if time(e) > cfg.times(1) 
%            text(0, 0, 85, 'X+Y=Z', 'FontSize', 50, 'HorizontalAlignment', 'center', 'Color', 'k')
%         else
%         end
        
        
        cdata = getframe(gcf);
        F(count).cdata = cdata.cdata;
        F(count).colormap = [];
        close all
    end
   
    
end




fig = figure('units', 'normalized', 'outerposition', cfg.figureDim);
movie(fig,F,1)

dir_out = [dirs.paper_figures 'videos' filesep];
videoRSA = VideoWriter([dir_out 'mmr_math_only' '.avi']);
videoRSA.FrameRate = 30;  % Default 30
videoRSA.Quality = 100;    % Default 75
open(videoRSA);
writeVideo(videoRSA, F);
close(videoRSA);