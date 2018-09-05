function dataNew = removeBadTimepts(data)
% returns new data structure where noisy timepoints of data
% (wave and/or phase fields) are set to NaN

datafields = {'phase','wave'}; % remove bad time pts from these fields (if exist)
datafields = intersect(fieldnames(data),datafields);
otherfields = setdiff(fieldnames(data),datafields);

nd = ndims(data.wave); % determine if spectral data or timecourse
ntrials = size(data.wave,nd-1);
for fi = 1:length(datafields)
    dataNew.(datafields{fi}) = data.(datafields{fi});
end

bfields = {'bad_inds','badinds'}; % was named slightly differently for different sbjs
bfield = intersect(bfields,fieldnames(data.trialinfo));

% replace bad timepts in each trial with NaN
for ti = 1:ntrials
    bad_inds = data.trialinfo.(bfield{1}){ti};
    bad_inds = setdiff(bad_inds,0);
    if ~isempty(bad_inds)
        for fi = 1:length(datafields)
            if (nd == 3) % spectral data
                dataNew.(datafields{fi})(:,ti,bad_inds)=NaN;
            else % timecourse data
                dataNew.(datafields{fi})(ti,bad_inds)=NaN;
            end
        end
    end
end

% keep other fields from data
for fi = 1:length(otherfields)
    dataNew.(otherfields{fi})=data.(otherfields{fi});
end




