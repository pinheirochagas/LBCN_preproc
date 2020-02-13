function plotIRASA(sbj_name, project_name, elecs, dirs)

% Load subjVar
load([dirs.original_data filesep  sbj_name filesep 'subjVar_'  sbj_name '.mat']);

if isempty(elecs)
    elecs = 1:length(subjVar.labels_EDF);
else
end

for el = 1:140 %
    
%     load(sprintf('%s/%s/%s/signal_properties/oscillatory_%s.mat', dirs.result_root, project_name, sbj_name, subjVar.labels_EDF{el}))
    load(sprintf('%s/%s/%s/signal_properties/oscillatory_%s.mat', dirs.result_root, project_name, sbj_name, subjVar.elinfo.FS_label{el}))

    
    %% plot the fractal component and the power spectrum
    figure('units', 'normalized', 'outerposition', [0 0 .5 .25]) % [0 0 .6 .3]
    fontsize = 16;
    
    subplot(1,2,1)
    plot(frac.freq, frac.powspctrm, ...
        'linewidth', 3, 'color', [0 0 0])
    hold on; plot(orig.freq, orig.powspctrm, ...
        'linewidth', 3, 'color', [.6 .6 .6])
    title(subjVar.labels_EDF{el})
    set(gca,'fontsize',fontsize)
    legend('Fractal component', 'Power spectrum');
    
    %
    % plot the full-width half-maximum of the oscillatory component
    f    = fit(osci.freq(osci.freq>2)', osci.powspctrm(osci.freq>2)', 'gauss2');
    % See why negative, if negative set to 0.
    
    if f.b2 < f.b1
        f    = fit(osci.freq(osci.freq>2)', osci.powspctrm(osci.freq>2)', 'gauss1');
        mean1= f.b1;
        std1  = f.c1/sqrt(2)*2.3548;
        mean1_str = num2str(mean1);
        texty1 = orig.powspctrm(max(find(mean1 > orig.freq)));
        text(mean1, texty1, mean1_str(1:end-2), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'baseline', 'FontSize', 20, 'Color', 'blue')
        plot(orig.freq(min(find(orig.freq>=mean1-std1)):max(find(orig.freq<=mean1+std1))), orig.powspctrm(min(find(orig.freq>=mean1-std1)):max(find(orig.freq<=mean1+std1))), 'Color', 'blue', 'LineWidth',3)
        
        legend('Fractal component', 'Power spectrum', 'FWHM oscillation peak 1');
        
        
    else
        
        mean1= f.b1;
        mean2= f.b2;
        
        std1  = f.c1/sqrt(2)*2.3548;
        std2  = f.c2/sqrt(2)*2.3548;
        
        mean1_str = num2str(mean1);
        mean2_str = num2str(mean2);
        
        texty1 = orig.powspctrm(max(find(mean1 > orig.freq)));
        texty2 = orig.powspctrm(max(find(mean2 > orig.freq)));
        
        text(mean1, texty1, mean1_str(1:end-2), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'baseline', 'FontSize', 20, 'Color', 'blue')
        text(mean2, texty2, mean2_str(1:end-2), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'baseline', 'FontSize', 20, 'Color', 'red')
        
        plot(orig.freq(min(find(orig.freq>=mean1-std1)):max(find(orig.freq<=mean1+std1))), orig.powspctrm(min(find(orig.freq>=mean1-std1)):max(find(orig.freq<=mean1+std1))), 'Color', 'blue', 'LineWidth',3)
        plot(orig.freq(min(find(orig.freq>=mean2-std2)):max(find(orig.freq<=mean2+std2))), orig.powspctrm(min(find(orig.freq>=mean2-std2)):max(find(orig.freq<=mean2+std2))), 'Color', 'red', 'LineWidth',3)
        legend('Fractal component', 'Power spectrum', 'FWHM oscillation peak 1', 'FWHM oscillation peak 2');
        
        % yl   = get(gca, 'YLim');
        % p = patch([fwhm flip(fwhm)], [yl(1) yl(1) yl(2) yl(2)], [1 1 1], 'EdgeColor', 'blue');
        % uistack(p, 'bottom');
        % p = patch([fwhm2 flip(fwhm2)], [yl(1) yl(1) yl(2) yl(2)], [1 1 1], 'EdgeColor', 'red');
        % uistack(p, 'bottom');
    end
    
    xlabel('Frequency'); ylabel('Power');
    
    % set(gca, 'YLim', yl);
    set(gca,'fontsize',fontsize)
    
    
    subplot(1,2,2)
    plot(frac.freq, frac.powspctrm, ...
        'linewidth', 3, 'color', [0 0 0])
    hold on; plot(orig.freq, orig.powspctrm, ...
        'linewidth', 3, 'color', [.6 .6 .6])
    title(subjVar.labels_EDF{el})
    xlabel('Log(Frequency)'); ylabel('Log(Power)');
    set(gca, 'YScale', 'log')
    set(gca, 'XScale', 'log')
    set(gca,'fontsize',fontsize)
    fout = sprintf('%s/%s/%s/signal_properties/oscillatory_%s.png', dirs.result_root, project_name, sbj_name, subjVar.labels_EDF{el});
    savePNG(gcf, 300, fout)
    close all
end

end

