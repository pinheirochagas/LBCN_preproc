function nums = ChanNamesToNums(globalVar,names)
%% INPUTS: 
% globalVar: globalVar structure
% names: cell of channel names (within globalVar.channame)

nums = nan(1,length(names));
for i = 1:length(names)
    nums(i)=find(strcmp(globalVar.channame,names{i}));
end