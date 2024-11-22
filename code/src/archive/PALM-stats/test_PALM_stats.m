%% SCRIPT FOR GLM STATS ON T1w/T2w ratio images from blind and sighted using
%PALM

clear;
clc;


%% Set up dirs
addpath('/Users/jacekmatuszewski/Documents/GitHub/PALM');
addpath('/Users/jacekmatuszewski/Documents/GitHub/workbench_2/bin_macosx64');

root_dir = fullfile(fileparts(mfilename('fullpath')), '..', '..','..');

opt.dir.derivatives = fullfile(root_dir, 'outputs', 'derivatives');
opt.dir.stats = fullfile(opt.dir.derivatives, 'PALM-stats'); 
opt.dir.hcp = fullfile(opt.dir.derivatives, 'hcppipelines');

opt.subjects = {'blind01', 'blind02', 'sighted01', 'sighted02'};


%% Set up design for PALM

con_bl = fullfile(fileparts(mfilename('fullpath')), 'con_blind_gt_sighted.csv');
con_sig = fullfile(fileparts(mfilename('fullpath')), 'con_sighted_gt_blind.csv');

toy_DM = fullfile(fileparts(mfilename('fullpath')), 'toy_design.csv'); %4 subjects
full_DM = fullfile(fileparts(mfilename('fullpath')), 'full_design.csv');% 40 subjects 

%% Get input images 

%HANDLE THAT WITH wb_shortcuts -cifti-contatenate! 

%can it be a cellstring? DUE TO DESIGN MATRIX AND CONTRASTS BLINDS ARE
%ASSUMED TO BE FIRST! 
%input_name = 'sub-blind01.SmoothedMyelinMap_BC.164k_fs_LR.dscalar.nii'
% 
% inputs = cellstr(spm_select('FPlistRec', opt.dir.hcp, '.*.SmoothedMyelinMap_BC.164k_fs_LR.dscalar.nii'));
% %WATCH OUT THERE ARE SOME HILLBILLY STATS AND GROUP AVERAGES THERE
% toy_inputs = [inputs(3); inputs(4); inputs(23); inputs(24)];


%% Convert input images to 4D file 
% matlabbatch{1}.spm.util.cat.vols = toy_inputs;
% matlabbatch{1}.spm.util.cat.name = 'palm_toy_inputs_4D.nii';
% matlabbatch{1}.spm.util.cat.dtype = 4;
% matlabbatch{1}.spm.util.cat.RT = NaN;
% 
% spm_jobman('run', matlabbatch); 
% 
% clear('matlabbatch');
% 
% movefile('/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/hcppipelines/sub-blind01/MNINonLinear/palm_toy_inputs_4D.nii', ...
%     '/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats/palm_toy_inputs_4D.nii');

%% TRY THAT PALM SHIT 
% palm -i dataset4D.nii -d design.mat -t design.con -m mask.nii -f design.fts -T -C 3.1 -n 5000 -corrcon -o myresults
palm -i toyCIFTI4D.dscalar.nii -d design.mat -t conBlind.con -n 5000 -corrcon -o palm_blind_gt_sig

palm -i toyCIFTI4D.dscalar.nii -d design.mat -t conSig.con -n 5000 -corrcon -o palm_sig_gt_blind

%% REAL SHIT 
%WHY THESE CONSTRASTS ARE IDENTICAL?
%palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design.mat -t conBlind.con -n 5000 -corrcon -o palm_SmoothedMyelinMaps_BC164k_blind_gt_sig
%palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design.mat -t conSig.con -n 5000 -corrcon -o palm_SmoothedMyelinMaps_BC164k_sig_gt_blind

%SMOOTHED MAPS
palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design.mat -t conBlind.con -o TEST_smoothed_blind_gt_sig
palm -i SmoothedMyelinMaps_BC164k.dscalar.nii -d design.mat -t conSig.con -o TEST_smoothed_sig_gt_blind

%UNSMOOTHED MAPS
palm -i MyelinMaps_BC164k.dscalar.nii -d design.mat -t conBlind.con -o TEST_unsmoothed_blind_gt_sig
palm -i MyelinMaps_BC164k.dscalar.nii -d design.mat -t conSig.con -o TEST_unsmoothed_sig_gt_blind

%THICKNESS 
palm -i Thickness_164k.dscalar.nii -d design.mat -t conBlind.con -n 5000 -o Thick_blind_gt_sig_test
palm -i Thickness_164k.dscalar.nii -d design.mat -t conSig.con -n 5000 -o Thick_sig_gt_blind_test