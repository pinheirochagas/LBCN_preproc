function [K,ntrials] =  OrganizeTrialInfoVTCExceptions(sbj_name,bn,K,ntrials)
%if error on second block
if strcmp(sbj_name,'S17_112_EA') && strcmp(bn, 'E17-450_0003') 
    K.theData(1:420) = [];
    ntrials = 420;
elseif strcmp(sbj_name,'S18_132_MDC') && strcmp(bn, 'E18-975_0005')
    K.theData(1:420) = [];
    ntrials = 420;
elseif strcmp(sbj_name,'S18_130_RH') && strcmp(bn, 'E18-841_0006')
    K.theData(1:420) = [];
    ntrials = 420; 
elseif strcmp(sbj_name,'S18_130_RH') && strcmp(bn, 'E18-841_0006')
    K.theData(1:420) = [];
    ntrials = 420; 
elseif strcmp(sbj_name,'S18_129_AS') && strcmp(bn, 'E18-767_0003')
    K.theData(1:420) = [];
    ntrials = 420;  
% elseif strcmp(sbj_name,'S18_127_AK') && strcmp(bn, 'E18-706_0016')
%     K.theData(1:420) = [];
%     ntrials = 420;  
elseif strcmp(sbj_name,'S18_126_DF') && strcmp(bn, 'E18-602_0036')
    K.theData(1:420) = [];
    ntrials = 420;    
elseif strcmp(sbj_name,'S18_125_LU') && strcmp(bn,'E18-542_0004')
    K.theData(1:420) = [];
    ntrials = 420; 
elseif strcmp(sbj_name,'S18_120_EGb') && strcmp(bn,'E18-447_0004')
    K.theData(1:420) = [];
    ntrials = 420; 
elseif strcmp(sbj_name,'S18_123_KJ') && strcmp(bn,'E18-274_0004')
    K.theData(1:420) = [];
    ntrials = 420; 
elseif strcmp(sbj_name,'S17_80_KBb') && strcmp(bn,'E17-669_0004')
    K.theData(1:420) = [];
    ntrials = 420;     
elseif strcmp(sbj_name,'S17_69_RTb') && strcmp(bn,'E17-438_0005')
    K.theData(1:351) = [];
    ntrials = 420;     
elseif strcmp(sbj_name,'S16_100_AF') && strcmp(bn,'E16-950_0007')
    K.theData(1:420) = [];
    ntrials = 280;    
    
%only for third block!
elseif strcmp(sbj_name,'S17_112_EA') && strcmp(bn, 'E17-450_0004')
    K.theData(1:840) = [];
    ntrials = 420;
elseif strcmp(sbj_name,'S18_123_KJ') && strcmp(bn, 'E18-274_0006')
    K.theData(1:840) = [];
    ntrials = 420;
elseif strcmp(sbj_name,'S17_69_RTb') && strcmp(bn,'E17-438_0007')
    K.theData(1:840) = [];
    ntrials = 420;   
elseif strcmp(sbj_name,'S16_100_AF') && strcmp(bn,'E16-950_0008')
    K.theData(1:840) = [];
    ntrials = 420;       
end
end
