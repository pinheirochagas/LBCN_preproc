function CompareBadEpochs(be, data_CAR, wave, datatype, dir_CAR, bn, el)

fieldnames_be = fieldnames(be);

%% Define plot parameters
line_width = 0.5;
font_size = 8;

figureDim = [0 0 1 1];
figure('units', 'normalized', 'outerposition', figureDim)

order_subplots = [1 3 5 7 2 4 6 8];

for i = 1:length(fieldnames_be)
    subplot(length(fieldnames_be),2,order_subplots(i))
    for ii = 1:size(data_CAR.wave,1)
        hold on
        if be.(fieldnames_be{i})(ii) == 1
            col = 'r';
        else
            col = 'k';
        end
        plot(data_CAR.time, data_CAR.wave(ii,:), 'Color', col, 'LineWidth', line_width)
        title([fieldnames_be{i} ' Raw data'], 'Interpreter', 'none');
        xlim([data_CAR.time(1) data_CAR.time(end)])
        set(gca,'LineWidth',2,'FontSize',font_size);
        box on
    end
end

for i = 1:length(fieldnames_be)
    subplot(length(fieldnames_be),2,order_subplots(i+length(fieldnames_be)))
    for ii = 1:size(data_CAR.wave,1)
        hold on
        if be.(fieldnames_be{i})(ii) == 1
            col = 'r';
        else
            col = 'k';
        end
        plot(data_CAR.time, wave(ii,:), 'Color', col, 'LineWidth', line_width)
        title([fieldnames_be{i} datatype], 'Interpreter', 'none');
        xlim([data_CAR.time(1) data_CAR.time(end)])
        set(gca,'LineWidth',2,'FontSize',font_size);
        box on
    end
end

% Save figure
% savePNG(gcf, 200, sprintf('%s/EpochData/bad_epochs_%s_%i.png', dir_CAR, bn, el));
saveas(gcf,sprintf('%s/EpochData/bad_epochs_%s_%s_%i.png', dir_CAR, bn, datatype, el))


close all

end

