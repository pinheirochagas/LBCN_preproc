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
    K.theData(1:420) = [];
    ntrials = 420;     
elseif strcmp(sbj_name,'S16_100_AF') && strcmp(bn,'E16-950_0007')
    K.theData(1:350) = [];
    ntrials = 350;  
elseif strcmp(sbj_name,'S17_104_SW') && strcmp(bn,'E17-32_0005')
    K.theData(1:400) = [];
    ntrials = 400; 
elseif strcmp(sbj_name,'S17_106_SD') && strcmp(bn,'E17-107_0005')
    K.theData(1:420) = [];
    ntrials = 420;   
elseif strcmp(sbj_name,'S17_107_PR') && strcmp(bn,'E17-237_0003')
    K.theData(1:420) = [];
    ntrials = 420;  
elseif strcmp(sbj_name,'S17_108_AH') && strcmp(bn,'E17-265_0005')
    K.theData(1:420) = [];
    ntrials = 420;     
elseif strcmp(sbj_name,'S17_109_NM') && strcmp(bn,'E17-356_0004')
    K.theData(1:420) = [];
    ntrials = 420;  
elseif strcmp(sbj_name,'S17_110_SC') && strcmp(bn,'E17-394_0003')
    K.theData(1:420) = [];
    ntrials = 420;     
elseif strcmp(sbj_name,'S17_113_CAM') && strcmp(bn,'E17-508_0004')
    K.theData(1:420) = [];
    ntrials = 420;   
elseif strcmp(sbj_name,'S17_114_EB') && strcmp(bn,'E17-526_0003')
    K.theData(1:420) = [];
    ntrials = 420; 
elseif strcmp(sbj_name, 'S17_116_AA') && strcmp(bn,'E17-789_0006')
    K.theData(1:420) = [];
    ntrials = 420;   
elseif strcmp(sbj_name, 'S17_117_MC') && strcmp(bn,'E17-823_0002')
    K.theData(1:420) = [];
    ntrials = 420;       
elseif strcmp(sbj_name, 'S17_118_TW') && strcmp(bn,'E17-910_0003')
    K.theData(1:420) = [];
    ntrials = 420;     
elseif strcmp(sbj_name, 'S15_89_JQb') && strcmp(bn,'E17-152_0005')
    K.theData(1:420) = [];
    ntrials = 420;         
elseif strcmp(sbj_name, 'S18_124_JR2') && strcmp(bn,'E18-309_0002')
    K.theData(1:420) = [];
    ntrials = 420;     
    
%only for third block!
elseif strcmp(sbj_name,'S17_112_EA') && strcmp(bn, 'E17-450_0004')
    K.theData(1:840) = [];
    ntrials = 425;
elseif strcmp(sbj_name,'S18_123_KJ') && strcmp(bn, 'E18-274_0006')
    K.theData(1:840) = [];
    ntrials = 425;
elseif strcmp(sbj_name,'S17_69_RTb') && strcmp(bn,'E17-438_0007')
    K.theData(1:840) = [];
    ntrials = 425;   
elseif strcmp(sbj_name,'S16_100_AF') && strcmp(bn,'E16-950_0008')
    K.theData(1:700) = [];
    ntrials = 345;    
elseif strcmp(sbj_name,'S17_104_SW') && strcmp(bn,'E17-32_0006')
    K.theData(1:800) = [];
    ntrials = 410;
elseif strcmp(sbj_name,'S17_106_SD') && strcmp(bn,'E17-107_0006')
    K.theData(1:840) = [];
    ntrials = 425;
elseif strcmp(sbj_name,'S17_107_PR') && strcmp(bn,'E17-237_0004')
    K.theData(1:840) = [];
    ntrials = 425;   
elseif strcmp(sbj_name,'S17_108_AH') && strcmp(bn,'E17-265_0007')
    K.theData(1:840) = [];
    ntrials = 425; 
elseif strcmp(sbj_name,'S17_109_NM') && strcmp(bn,'E17-356_0005')
    K.theData(1:840) = [];
    ntrials = 425; 
elseif strcmp(sbj_name,'S17_110_SC') && strcmp(bn,'E17-394_0004')
    K.theData(1:840) = [];
    ntrials = 425; 
elseif strcmp(sbj_name,'S17_113_CAM') && strcmp(bn,'E17-508_0005')
    K.theData(1:840) = [];
    ntrials = 425;   
elseif strcmp(sbj_name,'S17_114_EB') && strcmp(bn,'E17-526_0004')
    K.theData(1:840) = [];
    ntrials = 425;
elseif strcmp(sbj_name, 'S17_116_AA') && strcmp(bn,'E17-789_0007')
    K.theData(1:840) = [];
    ntrials = 425;
elseif strcmp(sbj_name, 'S17_117_MC') && strcmp(bn,'E17-823_0003')
    K.theData(1:840) = [];
    ntrials = 425;
elseif strcmp(sbj_name, 'S17_118_TW') && strcmp(bn,'E17-910_0004')
    K.theData(1:840) = [];
    ntrials = 425;
elseif strcmp(sbj_name, 'S15_89_JQb') && strcmp(bn,'E17-152_0006')
    K.theData(1:840) = [];
    ntrials = 425;
elseif strcmp(sbj_name, 'S18_124_JR2') && strcmp(bn,'E18-309_0006')
    K.theData(1:840) = [];
    ntrials = 425;
end
end
