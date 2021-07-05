function [time_cross, auc, auc_pct] = signal_concentration(signal, time, treshhold)

signal = signal+abs(min(signal));

% 
% signal(signal<0) = 0;
% signal(isnan(signal)) = 0;

auc = trapz(signal);


for i = 1:length(signal)
    tmp = trapz(signal(1:i));
    auc_pct(i) = (tmp/auc)*100;
end

time_cross = time(min(find(auc_pct>treshhold)));

end