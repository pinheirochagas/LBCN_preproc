function normsig = normMinMax(sig)

% normalize input signal between min and max (0-1)

normsig = (sig-nanmin(sig))/(nanmax(sig)-nanmin(sig));