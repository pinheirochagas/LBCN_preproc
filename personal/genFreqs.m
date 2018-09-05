function freqs = genFreqs(freqName)

switch freqName
    case 'HFB'
        freqs = 2.^(5.7:0.05:7.5);   
    case 'Spec'
        freqs = 2.^([0:0.5:2,2.3:0.3:5,5.2:0.2:8]);
    case 'Spec2'
        freqs = 2.^([0:0.3:6,6.15:0.15:8]);        
    case 'SpecDense'
        freqs = 2.^([0:0.25:2,2.15:0.15:5,5.1:0.1:8]);
end