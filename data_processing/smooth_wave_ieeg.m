function wave_smooth = smooth_wave_ieeg(wave, fsample, smooth_sec)

winSize = floor(fsample*smooth_sec);
gusWin= gausswin(winSize)/sum(gausswin(winSize));
wave_smooth = convn(wave,gusWin','same');

end