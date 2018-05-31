
[badind, filtered_beh,spkevtind,spkts] = LBCN_filt_bad_trial(data.wave',500)

hold off

subplot(3,1,1)
plot(data.wave(data.trialinfo.badtrial_raw==0,:)', 'Color', 'k')
hold on
plot(data.wave(data.trialinfo.badtrial_raw==1,:)', 'Color', 'r')


subplot(3,1,2)
plot(data.wave(data.trialinfo.badtrial_HFO==0,:)', 'Color', 'k')
hold on
plot(data.wave(data.trialinfo.badtrial_HFO==1,:)', 'Color', 'r')

subplot(3,1,3)
plot(data.wave(data.trialinfo.badtrial_all==0,:)', 'Color', 'k')
hold on
plot(data.wave(data.trialinfo.badtrial_all==1,:)', 'Color', 'r')


