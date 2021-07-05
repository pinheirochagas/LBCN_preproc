


subplot(1,6,i)

[x, y ] = sort(sig_con.math.max_time{61})


maxtime = sig_con.math.max_time{61}(y)
auc_pct = sig_con.math.auc_pct{61}(y)
time = sig_con.math.time{61}(y)

exclude = isnan(maxtime) | maxtime<0.250;
maxtime(exclude) = []
auc_pct(exclude) = []
time(exclude) = []

cols = viridis(length(auc_pct))
for i = 1:length(auc_pct)
   hold on
   plot(time{i},auc_pct{i}, 'Color', cols(i,:), 'LineWidth', 2)
    
end

xlabel('Time in sec.')
ylabel('AUC')