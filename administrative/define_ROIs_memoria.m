function ROIs = define_ROIs_memoria(sbj)

switch sbj
    case 'S14_69b_RT'
        ROIs.PCC = [34:36 44];
        ROIs.AG = [19:24 66:68];
        ROIs.IPS = [51 59:61];
        ROIs.ACC = [];
        ROIs.Insula = [];
    case 'S17_107_JQ'
        ROIs.PCC = [];
        ROIs.AG = [];
        ROIs.IPS = [116:118];
        ROIs.ACC = [31];
        ROIs.Insula = [46 47];
    case 'S16_99_CJ'
        ROIs.PCC = [53:55];
        ROIs.AG = [];
        ROIs.IPS = [];
        ROIs.ACC = [42:44];
        ROIs.Insula = [28];
    case 'S16_100_AF'
        ROIs.PCC = [];
        ROIs.AG = [];
        ROIs.IPS = [];
        ROIs.ACC = [];
        ROIs.Insula = [61];
    case 'S16_102_MDO'
        ROIs.PCC = [];
        ROIs.AG = [];
        ROIs.IPS = [];
        ROIs.ACC = [];
        ROIs.Insula = [];
    case 'S17_104_SW'
        ROIs.PCC = [];
        ROIs.AG = [];
        ROIs.IPS = [68 76];
        ROIs.ACC = [];
        ROIs.Insula = [];
    case 'S17_105_TA'
        ROIs.PCC = [];
        ROIs.AG = [17];
        ROIs.IPS = [];
        ROIs.ACC = [69];
        ROIs.Insula = [];
    case 'S17_106_SD'
        ROIs.PCC = [];
        ROIs.AG = [];
        ROIs.IPS = [];
        ROIs.ACC = [];
        ROIs.Insula = [];
    case 'S17_107_PR'
        ROIs.PCC = [];
        ROIs.AG = [];
        ROIs.IPS = [];
        ROIs.ACC = [1 2 62];
        ROIs.Insula = [45 46];
    case 'S17_109_NM'
        ROIs.PCC = [];
        ROIs.AG = [];
        ROIs.IPS = [];
        ROIs.ACC = [];
        ROIs.Insula = [];
    case 'S17_110_SC'
        ROIs.PCC = [51 52];
        ROIs.AG = [];
        ROIs.IPS = [57 58];
        ROIs.ACC = [];
        ROIs.Insula = [91];
    case 'S17_112_EA'
        ROIs.PCC = [46:48];
        ROIs.AG = [];
        ROIs.IPS = [50 51];
        ROIs.ACC = [];
        ROIs.Insula = [];
    case 'S17_114'
        ROIs.PCC = [];
        ROIs.AG = [];
        ROIs.IPS = [];
        ROIs.ACC = [];
        ROIs.Insula = [];
    case 'S17_115'
        ROIs.PCC = [];
        ROIs.AG = [];
        ROIs.IPS = [];
        ROIs.ACC = [];
        ROIs.Insula = [];
    case 'S17_116'
        ROIs.PCC = [121];
        ROIs.AG = [];
        ROIs.IPS = [5 9 12 13];
        ROIs.ACC = [];
        ROIs.Insula = [];
    case 'S17_117'
        ROIs.PCC = [];
        ROIs.AG = [];
        ROIs.IPS = [];
        ROIs.ACC = [];
        ROIs.Insula = [];
    case 'S17_118'
        ROIs.PCC = [52];
        ROIs.AG = [];
        ROIs.IPS = [];
        ROIs.ACC = [70:73 116:118];
        ROIs.Insula = [81];
    case 'S18_119'
        ROIs.PCC = [71:73 111 113];
        ROIs.AG = [];
        ROIs.IPS = [];
        ROIs.ACC = [64 65 103];
        ROIs.Insula = [8 10 11];
end
        
        
        