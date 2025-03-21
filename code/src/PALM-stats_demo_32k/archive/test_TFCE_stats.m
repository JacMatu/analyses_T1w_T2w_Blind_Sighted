%% SCRIPT FOR GLM STATS ON T1w/T2w ratio images from blind and sighted using
%PALM

clear;
clc;


%% Set up dirs
addpath('/Users/jacekmatuszewski/Documents/GitHub/PALM');
addpath('/Users/jacekmatuszewski/Documents/GitHub/workbench_2/bin_macosx64');

stats_dir = '/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/PALM-stats';

main_dir='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted';

Smoothed='Smoothed'; %'Smoothed' or '' for non-smoothed

%% DEMOGRAPHIC DESIGN FOR PALM
con_demo_bl = fullfile(stats_dir, 'glm_files','conBlind_demo.con');
con_demo_sig = fullfile(stats_dir, 'glm_files','conSig_demo.con');
design_demo = fullfile(stats_dir, 'glm_files', 'design_demo.mat');% 40 subjects 

% TFCE FILES
midthick_L= fullfile(stats_dir, 'glm_inputs','L_midthick_va.func.gii');
midthick_R= fullfile(stats_dir, 'glm_inputs','R_midthick_va.func.gii');

area_L= fullfile(stats_dir, 'glm_inputs','L_area.func.gii');
area_R= fullfile(stats_dir, 'glm_inputs','R_area.func.gii');
%%%%%%%%%% SMOOTHED MYELIN MAPS %%%%%%%%%

input_maps_L = fullfile(stats_dir,'glm_inputs', [Smoothed,'MyelinMaps_BC32k_data_L.func.gii']);
input_maps_R = fullfile(stats_dir,'glm_inputs', [Smoothed,'MyelinMaps_BC32k_data_R.func.gii']);

mkdir(fullfile(stats_dir,'glm_outputs','TFCE_test_MyelinMaps_Demographic_32k_WholeBrain'));
output_dir = fullfile(stats_dir,'glm_outputs','TFCE_test_MyelinMaps_Demographic_32k_WholeBrain');


%Move everything into the glm before callling palm?
copyfile(con_demo_bl, output_dir);
copyfile(con_demo_sig, output_dir);
copyfile(design_demo, output_dir);
copyfile(input_maps_L, output_dir);
copyfile(input_maps_R, output_dir);
copyfile(midthick_L, output_dir);
copyfile(midthick_R, output_dir);
copyfile(area_L, output_dir);
copyfile(area_R, output_dir);

cd(output_dir);

palm -i SmoothedMyelinMaps_BC32k_data_L.func.gii ...
 -d design_demo.mat ...
 -t conSighted_demo.con ...
 -o TFCE_MyelinDemo32_WholeBrain_Bl_gt_Sig_L ...
 -C 3.1 ...
 -tfce2D ...
 -s 'L_midthick_va.func.gii' ...
 -s 'L_area.func.gii' ...
 -logp ...
 -fdr ...
 -n 10000



%% OLD TESTS

%palm -i MyelinMaps_BC32k.dscalar.nii -d design_demo.mat  -t conBlind_demo.con -n 10000 -o TESTyelinDemo32_WholeBrain_Bl_gt_Sig -fdr -ise -ee
%palm -i SmoothedMyelinMaps_BC32k.dscalar.nii -d design_demo.mat  -t conSig_demo.con -n 10000 -o SmoothedMyelinDemo32_WholeBrain_Sig_gt_Bl -fdr

%palm -i MyelinMaps_BC32k_data_L.func.gii -d design_demo.mat -t conBlind_demo.con -o TFCE_MyelinDemo32_WholeBrain_Bl_gt_Sig_L -C -tfce2D -s 'L_midthick_va.func.gii' 'L_area.func.gii' -logp -fdr -n 10000

%palm -i MyelinMaps_BC32k_data_R.func.gii -d design_demo.mat -t conBlind_demo.con -o TFCE_MyelinDemo32_WholeBrain_Bl_gt_Sig_R -C -tfce2D -s 'R_midthick_va.func.gii' 'R_area.func.gii' -logp -fdr -n 10000

%tests - R_midthickness.surf.gii 
%palm -i MyelinMaps_BC32k_data_R.surf.gii -d design_demo.mat -t conBlind_demo.con -o TFCE_MyelinDemo32_WholeBrain_Bl_gt_Sig_R -T -tfce2D -s 'R_midthickness.surf.gii' 'R_area.func.gii' -logp -fdr -n 10000


%% CHECK CHAT GPT SOLUTION? - doesn't work, no -cifti argument in PALM!
%palm -i SmoothedMyelinMaps_BC32k.dscalar.nii -d design_demo.mat -t conSig_demo.con -T -n 5000 -cifti -cifti-out -o TEST_T_tfce_GPT

cd(main_dir)