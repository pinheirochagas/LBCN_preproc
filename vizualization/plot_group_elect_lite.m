function plot_group_elect_lite(plot_data,task,cond_names, time)

% plot_data = [];
% for i = 1:length(data.wave)
%     for ic = 1:length(cond_names)
%         trials = find(strcmp(data.trialinfo_all{i}.(column), cond_names{ic}));
%         plot_data{ic}(i,:) = nanmean(data.wave{i}(trials,:));
%     end
% end

plot_params = genPlotParams(task,'timecourse');
lineprops = [];
lineprops.style= '-';
lineprops.width = plot_params.lw;
lineprops.edgestyle = '-';

load('cdcol_2018.mat')

h = [];
for i = 1:length(plot_data)
    lineprops.col{1} = plot_params.col(i,:);
    mseb(time,nanmean(plot_data{i}),nanste(plot_data{i}),lineprops,1);
    hold on
    h(i)=plot(time,nanmean(plot_data{i}),'LineWidth',plot_params.lw,'Color',plot_params.col(i,:));
end

time_events = [1 2 3 4];
for i = 1:length(time_events)
    plot([time_events(i) time_events(i)],ylim,'Color', [.5 .5 .5], 'LineWidth',1)
end


xlim(plot_params.xlim)
xlabel(plot_params.xlabel)
ylabel(plot_params.ylabel)
set(gca,'fontsize',plot_params.textsize)
box off
xline(0, 'LineWidth',1.5);
yline(0, 'LineWidth',1.5);
set(gcf,'color','w');
leg = legend(h,cond_names,'Location','Northeast', 'AutoUpdate','off', 'Interpreter', 'none');
legend boxoff
set(leg,'fontsize',14, 'Interpreter', 'none')

end

