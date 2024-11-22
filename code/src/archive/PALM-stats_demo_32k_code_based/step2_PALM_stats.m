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

this_dir = '/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo';

%% BASIC DESIGN FOR PALM

con_basic_bl = fullfile(this_dir, 'glm_files','conBlind_basic.con');
con_basic_sig = fullfile(this_dir, 'glm_files','conSig_basic.con');
design_basic = fullfile(this_dir, 'glm_files', 'design_basic.mat');% 40 subjects 

mkdir(fullfile(this_dir,'glm_outputs','basic_MyelinMapsSmoothed'));
mkdir(fullfile(this_dir,'glm_outputs','basic_MyelinMaps'));
mkdir(fullfile(this_dir,'glm_outputs','basic_Thickness'));

%% DEMOGRAPHIC DESIGN FOR PALM
con_demo_bl = fullfile(this_dir, 'glm_files','conBlind_demo.con');
con_demo_sig = fullfile(this_dir, 'glm_files','conSig_demo.con');
design_demo = fullfile(this_dir, 'glm_files', 'design_demo.mat');% 40 subjects 

mkdir(fullfile(this_dir,'glm_outputs','demo_MyelinMapsSmoothed'));
mkdir(fullfile(this_dir,'glm_outputs','demo_MyelinMaps'));
mkdir(fullfile(this_dir,'glm_outputs','demo_Thickness'));

%% REAL SHIT 
%WHY THESE CONSTRASTS ARE IDENTICAL?
%palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design.mat -t conBlind.con -n 5000 -corrcon -o palm_SmoothedMyelinMaps_BC164k_blind_gt_sig
%palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design.mat -t conSig.con -n 5000 -corrcon -o palm_SmoothedMyelinMaps_BC164k_sig_gt_blind

%% SMOOTHED MAPS
%palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design.mat -t conBlind.con -o TEST_smoothed_blind_gt_sig
%palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design.mat -t conSig.con -o TEST_smoothed_sig_gt_blind

input_file = fullfile(this_dir,'glm_inputs', 'SmoothedMyelinMaps_BC164k.dscalar.nii');
output_dir = fullfile(this_dir, 'glm_outputs', 'basic_MyelinMapsSmoothed');

%Move everything into the glm before callling palm?
copyfile(con_basic_bl, output_dir);
copyfile(con_basic_sig, output_dir);
copyfile(design_basic, output_dir);
copyfile(input_file, output_dir);

cd(output_dir);
%palm -i input_file -d design_basic -t con_basic_bl -n 5000 -corrcon -o output_dir

palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design_basic.mat -t conBlind_basic.con -n 5000 -o basic_sm_Bl_gt_Sig
palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design_basic.mat -t conSig_basic.con -n 5000  -o basic_sm_Sig_gt_Bl

%% UNSMOOTHED MAPS
input_file = fullfile(this_dir,'glm_inputs', 'MyelinMaps_BC164k.dscalar.nii');
output_dir = fullfile(this_dir, 'glm_outputs', 'basic_MyelinMaps');

%Move everything into the glm before callling palm?
copyfile(con_basic_bl, output_dir);
copyfile(con_basic_sig, output_dir);
copyfile(design_basic, output_dir);
copyfile(input_file, output_dir);

cd(output_dir);

palm -i MyelinMaps_BC164k.dscalar.nii -d design_basic.mat -t conBlind_basic.con -n 5000 -o basic_Bl_gt_Sig
palm -i MyelinMaps_BC164k.dscalar.nii -d design_basic.mat -t conSig_basic.con -n 5000 -o basic_Sig_gt_Bl


%% THICKNESS 
input_file = fullfile(this_dir,'glm_inputs', 'Thickness_164k.dscalar.nii');
output_dir = fullfile(this_dir, 'glm_outputs', 'basic_Thickness');

%Move everything into the glm before callling palm?
copyfile(con_basic_bl, output_dir);
copyfile(con_basic_sig, output_dir);
copyfile(design_basic, output_dir);
copyfile(input_file, output_dir);

cd(output_dir);

palm -i Thickness_164k.dscalar.nii -d design_basic.mat -t conBlind_basic.con -n 5000 -o basic_Thick_Bl_gt_Sig
palm -i Thickness_164k.dscalar.nii -d design_basic.mat -t conSig_basic.con -n 5000 -o basic_Thick_Sig_gt_Bl


%% DEMOgRAPHIC MODELS

%% SMOOTHED MAPS
%palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design.mat -t conBlind.con -o TEST_smoothed_blind_gt_sig
%palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design.mat -t conSig.con -o TEST_smoothed_sig_gt_blind

input_file = fullfile(this_dir,'glm_inputs', 'SmoothedMyelinMaps_BC164k.dscalar.nii');
output_dir = fullfile(this_dir, 'glm_outputs', 'demo_MyelinMapsSmoothed');

%Move everything into the glm before callling palm?
copyfile(con_demo_bl, output_dir);
copyfile(con_demo_sig, output_dir);
copyfile(design_demo, output_dir);
copyfile(input_file, output_dir);

cd(output_dir);
%palm -i input_file -d design_basic -t con_basic_bl -n 5000 -corrcon -o output_dir

palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design_demo.mat -t conBlind_demo.con -n 5000 -o demo_sm_Bl_gt_Sig
palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design_demo.mat -t conSig_demo.con -n 5000 -o demo_sm_Sig_gt_Bl

%% UNSMOOTHED MAPS
input_file = fullfile(this_dir,'glm_inputs', 'MyelinMaps_BC164k.dscalar.nii');
output_dir = fullfile(this_dir, 'glm_outputs', 'demo_MyelinMaps');

%Move everything into the glm before callling palm?
copyfile(con_demo_bl, output_dir);
copyfile(con_demo_sig, output_dir);
copyfile(design_demo, output_dir);
copyfile(input_file, output_dir);

cd(output_dir);

palm -i MyelinMaps_BC164k.dscalar.nii -d design_demo.mat -t conBlind_demo.con -n 5000 -o demo_Bl_gt_Sig
palm -i MyelinMaps_BC164k.dscalar.nii -d design_demo.mat -t conSig_demo.con -n 5000 -o demo_Sig_gt_Bl


%% THICKNESS 
input_file = fullfile(this_dir,'glm_inputs', 'Thickness_164k.dscalar.nii');
output_dir = fullfile(this_dir, 'glm_outputs', 'basic_Thickness');

%Move everything into the glm before callling palm?
copyfile(con_demo_bl, output_dir);
copyfile(con_demo_sig, output_dir);
copyfile(design_demo, output_dir);
copyfile(input_file, output_dir);

cd(output_dir);

palm -i Thickness_164k.dscalar.nii -d design_demo.mat -t conBlind_demo.con -n 5000 -o demo_Thick_Bl_gt_Sig
palm -i Thickness_164k.dscalar.nii -d design_demo.mat -t conSig_demo.con -n 5000 -o demo_Thick_Sig_gt_Bl

%explore other stats options: 
%https://web.mit.edu/fsl_v5.0.10/fsl/doc/wiki/PALM(2f)UserGuide.html#Input_files
% -fdr
% -T -tfce2D
% -C <real>
% -demean
% -T -C 3.1 -n 5000 -corrcon -o myresults -ise
