clear;

sbj = 'S14_80_KB';
project_name = 'MMR';
task = get_project_name(sbj,'MMR');

initialize_dirs;
k1 = load(sprintf('%s/%s/%s/2blocks/%s_HFB_stats2.mat',results_root,task,sbj,task));
k2 = load(sprintf('%s/%s/%s/2blocks/%s_HFB_stats3.mat',results_root,task,sbj,task));

numcmps1 = length(k1.comp_cond);
numcmps2 = length(k2.comp_cond);

comp_cond = [k1.comp_cond k2.comp_cond];
comp_win = [k1.comp_win k2.comp_win];

elecnames = fieldnames(k1.dprime);
cmpnames1 = fieldnames(k1.dprime.e1);
cmpnames2 = fieldnames(k2.dprime.e1);

noise_sd = k1.noise_sd;
noise_sd_max = k1.noise_sd_max;

for ei = 1:length(elecnames);
    for ci = 1:numcmps1
        dprime.(elecnames{ei}).(cmpnames1{ci})=k1.dprime.(elecnames{ei}).(cmpnames1{ci});
        p.(elecnames{ei}).(cmpnames1{ci})=k1.p.(elecnames{ei}).(cmpnames1{ci});
        HFB.(elecnames{ei}).(cmpnames1{ci}).c1 = k1.HFB.(elecnames{ei}).(cmpnames1{ci}).c1;
        HFB.(elecnames{ei}).(cmpnames1{ci}).c2 = k1.HFB.(elecnames{ei}).(cmpnames1{ci}).c2;
    end
    for ci = 1:numcmps2
        dprime.(elecnames{ei}).(['cmp',num2str(ci+numcmps1)])=k2.dprime.(elecnames{ei}).(cmpnames2{ci});
        p.(elecnames{ei}).(['cmp',num2str(ci+numcmps1)])=k2.p.(elecnames{ei}).(cmpnames2{ci});
        HFB.(elecnames{ei}).(['cmp',num2str(ci+numcmps1)]).c1=k2.HFB.(elecnames{ei}).(cmpnames2{ci}).c1;
        HFB.(elecnames{ei}).(['cmp',num2str(ci+numcmps1)]).c2=k2.HFB.(elecnames{ei}).(cmpnames2{ci}).c2;
    end
end

fp = sprintf('%s/%s/%s/2blocks/%s_HFB_stats4.mat',results_root,task,sbj,task);
save(fp,'comp_cond','comp_win','noise_sd','noise_sd_max','HFB','p','dprime')