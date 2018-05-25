clear all
clear all; close all
clc


% Load event file
sbj_name= 'S18_122';
block_name= 'E18-226_0005';
project_name= 'MMR';

initialize_dirs;
% comp_root = sprintf('/Users/parvizilab/Desktop/Math Project'); % location of analysis_ECOG folder
% data_root= sprintf('%s/analysis_ECOG/neuralData',comp_root);
load(sprintf('%s/OriginalData/%s/global_%s_%s_%s.mat',data_root,sbj_name,project_name,sbj_name,block_name));
load (sprintf('%s/events_%s.mat',globalVar.result_dir,block_name));
%%
%Math

switch project_name
    case 'MMR'
        k=5;
    case 'UCLA'
        k=7;
end

trexM=find(events.categories(1,k).RT<=0.7);
sortMath = sort(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(trexM))));
%plot(sortMath,'Linewidth',3);

%find the outliers and define 'exM'
meanMathAll = mean(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(trexM))));
stdMath= std(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(trexM))));
exMmax=find(events.categories(1,k).RT>=(meanMathAll+stdMath*2));
exMmin=find(events.categories(1,k).RT<=(meanMathAll-stdMath*2));
exM=[trexM exMmin exMmax];
exM=unique(exM);
exMvl=events.categories(1,k).RT(exM)

%Calculate mean, median, min, max for Math cond

meanMath = mean(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(exM))));
medMath = median(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(exM))));
minMath = min(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(exM))));
maxMath = max(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(exM))));
nMath=length(events.categories(1,k).RT)-length(exM);

%%
close all; clear k

%Autobio

switch project_name
    case 'MMR'
        k=4;
    case 'UCLA'
        k=8;
end

trexA=find(events.categories(1,k).RT<=0.7);
sortAutobio = sort(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(trexA))));
%plot(sortAutobio,'Linewidth',3);

%find the outliers and define 'exA'
meanAutobioAll = mean(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(trexA))));
stdAutobio=std(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(trexA))));
exAmax=find(events.categories(1,k).RT>=(meanAutobioAll+stdAutobio*2));
exAmin=find(events.categories(1,k).RT<=(meanAutobioAll-stdAutobio*2));
exA=[trexA exAmin exAmax];
exA=unique(exA);
exAvl=events.categories(1,k).RT(exA)

%Calculate mean, median, min, max for Math cond

meanAutobio = mean(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(exA))));
medAutobio = median(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(exA))));
minAutobio = min(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(exA))));
maxAutobio = max(setxor((events.categories(1,k).RT),(events.categories(1,k).RT(exA))));
nAutobio=length(events.categories(1,k).RT)-length(exA);

%%
close all
% clear ans
RTinfo=NaN*ones(1,11);
RTinfo(1,1)=meanMath;
RTinfo(1,2)=medMath;
RTinfo(1,3)=minMath;
RTinfo(1,4)=maxMath;
RTinfo(1,5)=nMath;
RTinfo(1,7)=meanAutobio;
RTinfo(1,8)=medAutobio;
RTinfo(1,9)=minAutobio;
RTinfo(1,10)=maxAutobio;
RTinfo(1,11)=nAutobio;

% xlswrite('G:/LBCN/artiz.xls',block_name,'RTinfo_MMR','A21')
% xlswrite('G:/LBCN/artiz.xls',RTinfo,'RTinfo_MMR','L21')

%%
fn= sprintf('%s/beh_%s.mat',globalVar.result_dir,block_name);
save(fn,'exA', 'exM', 'RTinfo');