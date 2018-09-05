function [itc_out,p] = itc(phases,dim)
% This function takes in an array of phase values (phases), and computes
% the inter-trial phase coherence across the trial dimension, dim
% 
% output, itc_out, is complex:
%   abs(itc_out) = ITC value

if nargin < 2
    if (min(size(phases))>1)
        error('must specify dimension')
    else
        phases = phases(:);
        dim = 1;
    end
end
ntrials = size(phases,dim);

itc_out = squeeze(nanmean(exp(1i*(phases)),dim));

% p-value (against null hypothesis that phases come from uniform circular
% distribution)
p = circular_p(abs(itc_out),ntrials);




