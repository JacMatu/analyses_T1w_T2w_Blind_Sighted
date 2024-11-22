%% SCRIPT FOR GLM STATS ON T1w/T2w ratio images from blind and sighted using
%PALM

clear;
clc;


%% Set up dirs
addpath('/Users/jacekmatuszewski/Documents/GitHub/PALM');
addpath('/Users/jacekmatuszewski/Documents/GitHub/workbench_2/bin_macosx64');

stats_dir = '/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/PALM-stats';

main_dir='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted'


%% DEMOGRAPHIC DESIGN FOR PALM
con_demo_bl = fullfile(stats_dir, 'glm_files','conBlind_demo.con');
con_demo_sig = fullfile(stats_dir, 'glm_files','conSig_demo.con');
design_demo = fullfile(stats_dir, 'glm_files', 'design_demo.mat');% 40 subjects 

% GLM INPUTS
input_maps = fullfile(stats_dir,'glm_inputs', 'MyelinMaps_BC32k.dscalar.nii');

%Visual cortex file for SVC
VisCortMask_full_file = fullfile('/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/wb_command-ROIs', 'Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii');

%%%%%%%%%% MYELIN MAPS %%%%%%%%%
%mkdir(fullfile(stats_dir,'glm_outputs','MyelinMaps_Demographic_32k_VisCortSVC_Blind_gt_Sighted'));
%output_dir = fullfile(stats_dir,'glm_outputs','MyelinMaps_Demographic_32k_VisCortSVC_Blind_gt_Sighted');

mkdir(fullfile(stats_dir,'glm_outputs','MyelinMaps_Demographic_32k_VisCortSVC_Sighted_gt_Blind'));
output_dir = fullfile(stats_dir,'glm_outputs','MyelinMaps_Demographic_32k_VisCortSVC_Sighted_gt_Blind');

%Move everything into the glm before callling palm?
copyfile(con_demo_bl, output_dir);
copyfile(con_demo_sig, output_dir);
copyfile(design_demo, output_dir);
copyfile(input_maps, output_dir);
copyfile(VisCortMask_full_file, output_dir);

cd(output_dir);

%RUN PALM WITH BIDIRECTIONAL CONTRASTS! 
% Options/flags to test:
% -fdr
% -T
% -C
% -twotail
% -ee vs -ise 
% -n 

%palm -i MyelinMaps_BC32k.dscalar.nii -d design_demo.mat -m 'Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii' -t conBlind_demo.con -n 10000 -o MeylinDemo32_VisCortMask_Bl_gt_Sig -fdr
palm -i MyelinMaps_BC32k.dscalar.nii -d design_demo.mat -m 'Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii' -t conSig_demo.con -n 10000 -o MeylinDemo32_VisCortMask_Sig_gt_Bl -fdr


cd(main_dir)