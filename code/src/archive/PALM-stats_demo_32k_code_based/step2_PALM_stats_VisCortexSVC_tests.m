%% SCRIPT FOR GLM STATS ON T1w/T2w ratio images from blind and sighted using
%PALM

clear;
clc;


%% Set up dirs
addpath('/Users/jacekmatuszewski/Documents/GitHub/PALM');
addpath('/Users/jacekmatuszewski/Documents/GitHub/workbench_2/bin_macosx64');

%root_dir = fullfile(fileparts(mfilename('fullpath')), '..', '..','..');

%opt.dir.derivatives = fullfile(root_dir, 'outputs', 'derivatives');
%opt.dir.stats = fullfile(opt.dir.derivatives, 'PALM-stats'); 
%opt.dir.hcp = fullfile(opt.dir.derivatives, 'hcppipelines');

this_dir = '/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo_32k';

cd(this_dir);

%% BASIC DESIGN FOR PALM

%con_basic_bl = fullfile(this_dir, 'glm_files','conBlind_basic.con');
%con_basic_sig = fullfile(this_dir, 'glm_files','conSig_basic.con');
%design_basic = fullfile(this_dir, 'glm_files', 'design_basic.mat');% 40 subjects 

%mkdir(fullfile(this_dir,'glm_outputs','basic_MyelinMapsSmoothed'));
%mkdir(fullfile(this_dir,'glm_outputs','basic_MyelinMaps'));
%mkdir(fullfile(this_dir,'glm_outputs','basic_Thickness'));

%% DEMOGRAPHIC DESIGN FOR PALM
con_demo_bl = fullfile(this_dir, 'glm_files','conBlind_demo.con');
con_demo_sig = fullfile(this_dir, 'glm_files','conSig_demo.con');
design_demo = fullfile(this_dir, 'glm_files', 'design_demo.mat');% 40 subjects 

mkdir(fullfile(this_dir,'glm_outputs','TEST_demo_MyelinMaps_VisCortSVC_32k'));

%% DEMOgRAPHIC MODELS

input_file = fullfile(this_dir,'glm_inputs', 'MyelinMaps_BC32k.dscalar.nii');
output_dir = fullfile(this_dir, 'glm_outputs', 'TEST_demo_MyelinMaps_VisCortSVC_32k');

%This has to be a 4D file with dimensions matching the GLM input files and design matrix rows [40]
%VisCortMask_full_file = fullfile(this_dir, 'MMP_Glasser_Atlas', 'Glasser_VisualCortex_R.32k_fs_LR.dlabel.nii');
%VisCortMask_full_file = fullfile(this_dir, 'MMP_Glasser_Atlas', 'Glasser_VisualCortex_R.32k_fs_LR.dscalar.nii');
VisCortMask_full_file = fullfile(this_dir, 'MMP_Glasser_Atlas', 'dlabel_to_dscalar_tests','test_Glasser_VisualCortex_R.32k_fs_LR.dscalar.nii');

%Move everything into the glm before callling palm?
copyfile(con_demo_bl, output_dir);
copyfile(con_demo_sig, output_dir);
copyfile(design_demo, output_dir);
copyfile(input_file, output_dir);
copyfile(VisCortMask_full_file, output_dir);

cd(output_dir);
%palm -i input_file -d design_basic -t con_basic_bl -n 5000 -corrcon -o output_dir

palm -i MyelinMaps_BC32k.dscalar.nii -d design_demo.mat -m 'test_Glasser_VisualCortex_R.32k_fs_LR.dscalar.nii' -t conBlind_demo.con -n 5000 -o demo32_VisCortMask_Bl_gt_Sig
palm -i MyelinMaps_BC32k.dscalar.nii -d design_demo.mat -m 'test_Glasser_VisualCortex_R.32k_fs_LR.dscalar.nii' -t conSig_demo.con -n 5000 -o demo32_VisCortMask_Sig_gt_Bl

