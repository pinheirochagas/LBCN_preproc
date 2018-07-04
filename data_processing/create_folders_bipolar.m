% Functions: Generating folders
% Writen by Mohammad Dastjerdi, Parvizi Lab, Stanford
% Revision date SEP,2009
% Run this once only.
clear
%% Variables
sbj_name= 'S15_82_JB';
block_name= 'S15_82_JB_07_bipolar';
project_name= 'MMR';

% 'S09_07_CM'
% ST07-03       UCLA
% ST07-07       UCLA



%S14_65_HN
% HN	MMR prt 2	S14_65_HN_02
% HN	MMR prt#1	S14_65_HN_05
% HN	7heaven V2	S14_65_HN_06
% HN	Context_1	S14_65_HN_08
% HN	Context 2	S14_65_HN_09
% HN	Context 2	S14_65_HN_10
% HN	Context 3	S14_65_HN_11
% HN	Context 4	S14_65_HN_12
% HN	Context 5	S14_65_HN_13
% HN	Context 6	S14_65_HN_14


% S13_46_JDB
% JDB	MMR 1       JDB_01
% JDB	MMR 2       JDB_03
% JDB	Scrambled	JDB_05
% JDB	7 heaven	JDB_06
% JDB	7 h passive	JDB_09

% S13_60_DY
% DY	2013	7heaven V2	7Heaven	DY_02
% DY	2013	MMR P1	MMR	DY_06
% DY	2013	MMR P2	MMR	DY_09

% S12_42_NC
% NC    7 heaven v2	NC_02
% NC	MMR 1       NC_05
% NC	MMR 2       NC_06
% NC	MFA 2       NC_09

% S11_28_LS
% LS	7Heaven     LS0911_03
% LS	7Heaven     LS0911_04
% LS	MFA         LS0911_05
% LS	2E          LS0911_06
% LS	2E          LS0911_07
% LS	UCLA        LS0911_08
% LS	7H masked	LS0911_46
% LS	Scrambled	LS0911_47

%S11_31_DZa
% DZ a	MMR1        DZ1211-09
% DZ a	MMR2        DZ1211-10
% DZ a	MFA         DZ1211-11
% DZ a	Scrambled 1	DZ1211-14
% DZ a	7heaven     DZ1211-15
% DZ a	2E          DZ1211-16

%S11_31_DZb
% DZb	MMR         DZb1211-01
% DZb	MFA         DZb1211-04
% DZb	MFA-2       DZb1211-05
% DZb	Scrmb_V2    DZb1211-11
% DZb	7 heaven	DZb1211-12
% DZb	2e          DZb1211-13


% S14_62_JW
% JW	MMR P1          S14_62_03
% JW	MMR P1          S14_62_04
% JW	MMR P2          S14_62_05
% JW	7Heaven_v2      S14_62_25
% JW	Calculia pt 1	S14_62_42
% JW	Calculia pt 2	S14_62_43
% JW	Calculia pt 3	S14_62_44


% S13_56_THS
% THS	MMR p1      THS_01
% THS	MMR p2      THS_02
% THS	7 Heaven v2	THS_03
% THS	MMR2 p1     THS_07
% THS	MMR2 p2     THS_08

% S12_38_LK
% LK	MMR 1 (a)       LK_01
% LK	7heaven read	LK_02
% LK	MMR 1 (b)       LK_06                                              
% LK	MMR2 (b)        LK_07
% LK	MMR 1 (c)       LK_08
% LK	MMR 2 ©         LK_10
% LK	Scrambled       LK_21
% LK	Scrambled       LK_26
% LK	7Heaven ?old	LK_27
% LK	2E              LK_30


% %S12_34_TC
% TC	7 heaven- read 1	TC0212-03
% TC	7 heaven auto       TC0212-04
% TC	7 heaven auto b     TC0212-05
% TC	7 heaven read 2     TC0212-06
% TC	7 heaven read 3     TC0212-07
% TC	MMR 1               TC0212-08
% TC	7 heaven auto c     TC0212-09
% TC	MMR 2               TC0212-10

%S13_47_JT2
% JT2	MMR 1       JT2_01
% JT2	7 heaven v2	JT2_02
% JT2	MMR 2       JT2_03
% JT2	MFA         JT2_16

%S12_45_LR
% LR	MMR 1       LR_03
% LR	MMR 2       LR_06
% LR	7 heaven v2	LR_14
% LR	Scrambled	LR_15
% LR	Context 1	LR_24
% LR	Context 2	LR_27
% LR	Context 3	LR_32
% LR	Context 4	LR_33

% S12_41_KS
% KS	MMR 1       KS_09
% KS	MMR 2       KS_10
% KS	7 heaven v2	KS_12
% KS	MMR 2- redo	KS_13
% KS	Scrambled	KS_15
% KS	MFA         KS_16
% KS	Nested # 1	KS_23
% KS	Context 1	KS_24
% KS	Context 2	KS_25
% KS	Context 3	KS_26
% KS	Context 4	KS_27
% KS	Context 5	KS_28
% KS	Context 6	KS_29
% KS	Context Together 1	KS_30


% S13_55_JJC
% JJC	MMR p1      JJC _02
% JJC	MMR p1      JJC _03
% JJC	MMR p2      JJC _04
% JJC	MMR p1      JJC _06
% JJC	7 Heaven V2	JJC _08
% JJC	MFA         JJC _10
% JJC	scrambled	JJC _12
% JJC	scrambled 2	JJC _13

% S13_52_FVV
% FVV	MMR p1      FVV_01
% FVV	MMR p2      FVV_02
% FVV	7 heaven v2	FVV_03
% FVV	MFA         FVV_08
% FVV	MFA 2       FVV_09
% FVV	Context 1	FVV_12
% FVV	Context 2	FVV_13
% FVV	Context 3	FVV_14
% FVV	Context 4	FVV_16
% FVV	context delay 1	FVV_18
% FVV	context delay 2	FVV_19
% FVV	context delay 3	FVV_21
% FVV	context delay 4	FVV_22
% FVV	context delay 5	FVV_23
% FVV	context delay 6	FVV_24

% S12_36_SrS;
% SrS	7Heaven     SrS_01
% SrS	MFA         SrS_02
% SrS	Logo        SrS_03
% SrS	Scrambled	SrS_04
% SrS	2E          SrS_05
% SrS	MMR 1       SrS_09 
% SrS	MMR 2       SrS_10
% SrS   All Cat     SrS_15
% SrS	Logo        SrS_16
% SrS	All Cat     SrS_17

% S13_57_TVD
% TVD	MMR p1      TVD_08
% TVD	MMR p2      TVD_10
% TVD	7Heaven     TVD_11
% TVD	MMR p1      TVD_13
% TVD	MMR p2      TVD_14
% TVD	MFA         TVD_16
% TVD	Context 1   TVD_22
% TVD	Context 2	TVD_23
% TVD	Context 3	TVD_24
% TVD	Context 4	TVD_25
% TVD	Context 5	TVD_26

% S13_53_KS2
% KS2	MMR p1- error	KS2_01
% KS2	MMR p1          KS2_02
% KS2	MMR p2          KS3_03
% KS2	Logo            KS4_04
% KS2	7Heaven         KS2_06
% KS2	Scrambled       KS2_07
% KS2	MFA             KS2_08
% KS2	Context_V2 #1	KS2_24
% KS2	Context_V2 #2	KS2_25
% KS2	Context_V2 #3	KS2_26
% KS2	Context_V2 #4	KS2_27
% KS2	Context_V2 #5	KS2_28
% KS2	Context_V2 #6	KS2_29

% S11_26_SRa
% SRa	UCLA        SR_03
% SRa	7Heaven     SR_07
% SRa	UCLA        SR_10
% SRa	7Heaven     SR_13

% S11_26_SRb
% SRb	UCLA        SRb_06
% SRb	7Heaven     SRb_16
% SRb	UCLA        SRb_17

% MD	UCLA        MD0311-01
% MD	7Heaven     MD0311-04
% MD	UCLA        MD0311-05
% MD	7Heaven     MD0311-09

% S11_29_RB
% RB    UCLA 1      RB0911-02
% RB    Math mask	RB0911-16
% RB    All Cat     RB0911-17
% RB    7Heaven     RB0911-18
% RB    UCLA 2      RB0911-19
% RB    UCLA 2      RB0911-20
% RB    MFA         RB0911-21
% RB    word/sym	RB0911-22
% RB    MMR 1		RB0911-67
% RB    MMR 2       RB0911-69

%'S11_25_DL'; 
% DL	UCLA            dl_04
% DL	2E              dl_05
% DL	7Heaven         dl_06
% DL	MFA             dl_07
% DL	UCLA            dl_44
% DL	MFA             dl_45
% DL	2E              dl_46
% DL	7Heaven         dl_47

% S12_32_JTa
% JT	MMR             JT0112-03
% JT	MMR             JT0112-04
% JT	All Category	JT0112-27
% JT 	MFA             JT0112-28
% JT	7heaven         JT0112-29

% S12_32_JTb
% JT	MFA             JT0112-42
% JT	2E              JT0112-43
% JT	MMR             JT0112-45
% JT	MMR -error      JT0112-46
% JT 	MMR -error      JT0112-47




% HH    MMR 1 		HH_02
% HH	MMR 2 		HH_04

% VA	MMR 1           VA121011-05
% VA	MMR 2           VA121011-06
% VA	All-Category	VA121011-07
% VA	Scramble V2     VA121011-08

comp_root = sprintf('/Users/parvizilab/Desktop/Math Project'); % location of analysis_ECOG folder
data_root= sprintf('%s/analysis_ECOG/neuralData',comp_root);
psych_root= sprintf('%s/analysis_ECOG/psychData',comp_root);
result_root= sprintf('%s/analysis_ECOG/Results/%s',comp_root,project_name); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Making directory for notch filtered data
if ~exist(sprintf('%s/FiltData/%s',data_root,sbj_name))
    mkdir(sprintf('%s/FiltData',data_root),sbj_name)
end
if ~exist(sprintf('%s/FiltData/%s/%s',data_root,sbj_name,block_name))
    mkdir(sprintf('%s/FiltData/%s',data_root,sbj_name),block_name);
end

%% Making directory for spectral data
if ~exist(sprintf('%s/SpecData/%s',data_root,sbj_name))
    mkdir(sprintf('%s/SpecData',data_root),sbj_name)
end
if ~exist(sprintf('%s/SpecData/%s/%s',data_root,sbj_name,block_name))
    mkdir(sprintf('%s/SpecData/%s',data_root,sbj_name),block_name)
end

%% Making result directory
if ~exist(sprintf('%s/%s',result_root,sbj_name))
   mkdir(sprintf('%s',result_root),sbj_name) 
end
if ~exist(sprintf('%s/%s/%s',result_root,sbj_name,block_name))
   mkdir(sprintf('%s/%s',result_root,sbj_name),block_name) 
end



