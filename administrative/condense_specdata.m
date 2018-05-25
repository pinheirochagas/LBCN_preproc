clear; close all; clc

initialize_dirs;

sbj = 'S11_28_LS';
BN = 'LS0911-08';
task = 'UCLA';

spec_inds = [11:15 10 16]; %indeces to keep
% spec_inds = 1:6;

load(sprintf('%s/OriginalData/%s/global_%s_%s_%s.mat',data_root,sbj,task,sbj,BN))
spec_dir = sprintf('%s/SpecData/%s/%s',data_root,sbj,BN);

elecs = setdiff(1:globalVar.nchan,[globalVar.refChan]);

for ei = elecs
    fp = sprintf('%s/band_%s_%.3d',spec_dir,BN,ei);
    load(fp)
    band.freq = band.freq(:,spec_inds);
    band.amplitude = band.amplitude(spec_inds,:);
    band.phase = band.phase(spec_inds,:);
    save(fp,'band')
    disp(num2str(ei))
end

