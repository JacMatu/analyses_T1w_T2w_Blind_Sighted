#!/usr/bin/env bash

palm_exe=/Users/jacekmatuszewski/Documents/GitHub/PALM/palm


#TESTING PHASE 
#Myelin
output_dir=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/PALM-stats/glm_outputs/TFCE_test_MyelinMaps_Demographic_32k_WholeBrain

cd $output_dir


#STATS TEST - calling it with BASH script
# .gii is still not read as a surface! 

$palm_exe -i SmoothedMyelinMaps_BC32k_data_L.func.gii -d design_demo.mat -t conSig_demo.con -o TFCE_MyelinDemo32_WholeBrain_Bl_gt_Sig_L -T -tfce2D -s 'L_midthick_va.func.gii' 'L_area.func.gii' -logp -fdr -n 500


#Why does it work SOMETIMES? 
# adding -T or -C crashes the script! 
# - corrcon produces cFWE (not CLUSTER, it's contrast-corrected FWE)

#HEMI-SPECIFIC VISUAL CORTEX MASK
#Binary_Glasser_VisualCortex_L.func.gii
#Binary_Glasser_VisualCortex_R.func.gii


$palm_exe \
-i SmoothedMyelinMaps_BC32k_data_R.func.gii \
-d design_demo.mat \
-t conSig_demo.con \
-m 'Binary_Glasser_VisualCortex_R.func.gii' \
-s 'R_midthick_va.func.gii' 'R_area.func.gii' \
-o hemi_MyelinDemo32_VisCort_Sig_gt_Bl_R \
-fdr  -n 10000 

$palm_exe \
-i SmoothedMyelinMaps_BC32k_data_L.func.gii \
-d design_demo.mat \
-t conSig_demo.con \
-m 'Binary_Glasser_VisualCortex_L.func.gii' \
-s 'L_midthick_va.func.gii' 'L_area.func.gii' \
-o hemi_MyelinDemo32_VisCort_Sig_gt_Bl_L \
-fdr -n 10000


wb_command \
-cifti-create-dense-from-template SmoothedMyelinMaps_BC32k.dscalar.nii results_hemi_VisCort_merged_fdrp.dscalar.nii \
-metric CORTEX_LEFT hemi_MyelinDemo32_VisCort_Sig_gt_Bl_L_dpv_tstat_fdrp.gii \
-metric CORTEX_RIGHT hemi_MyelinDemo32_VisCort_Sig_gt_Bl_R_dpv_tstat_fdrp.gii


## WHOLE BRAIN TEST - not significant with FDR
#$palm_exe \
#-i SmoothedMyelinMaps_BC32k_data_R.func.gii \
#-d design_demo.mat \
#-t conSig_demo.con \
#-s 'R_midthick_va.func.gii' 'R_area.func.gii' \
#-o hemi_MyelinDemo32_WholeBrain_Sig_gt_Bl_R \
#-fdr \
#-n 10000 

#$palm_exe \
#-i SmoothedMyelinMaps_BC32k_data_L.func.gii \
#-d design_demo.mat \
#-t conSig_demo.con \
#-s 'L_midthick_va.func.gii' 'L_area.func.gii' \
#-o hemi_MyelinDemo32_WholeBrain_Sig_gt_Bl_L \
#-fdr \
#-n 10000 

#MERGE METRICS INTO NEW CIFFI FILES
#wb_command \
#-cifti-create-dense-from-template SmoothedMyelinMaps_BC32k.dscalar.nii results_WholeBrain_merged_fdrp.dscalar.nii \
#-metric CORTEX_LEFT hemi_MyelinDemo32_WholeBrain_Sig_gt_Bl_L_dpv_tstat_fdrp.gii \
#-metric CORTEX_RIGHT hemi_MyelinDemo32_WholeBrain_Sig_gt_Bl_R_dpv_tstat_fdrp.gii

wb_command \
-cifti-create-dense-from-template SmoothedMyelinMaps_BC32k.dscalar.nii results_VisCort_merged_fdrp.dscalar.nii \
-metric CORTEX_LEFT hemi_MyelinDemo32_VisCort_Sig_gt_Bl_L_dpv_tstat_fdrp.gii \
-metric CORTEX_RIGHT hemi_MyelinDemo32_VisCort_Sig_gt_Bl_R_dpv_tstat_fdrp.gii

# TFCE ARGUMENT THAT DO NOT WORK / CLUSTER TESTS

# for now, all .gii files are struct with `cdata` field (aka desnse scalars), not geometry files (faces mat vertices)
# maybe that's the issue? maybe -s files have to be changed to GEOMETRY? 

$palm_exe \
-i SmoothedMyelinMaps_BC32k_data_R.func.gii \
-m 'Binary_Glasser_VisualCortex_R.func.gii' \
-d design_demo.mat \
-t conSig_demo.con \
-T -tfce2D \
-s 'R_midthick_va.func.gii' 'R_area.func.gii' \
-o TFCE_MyelinDemo32_VisCort_Sig_gt_Bl_R \
-n 100 




#-T 
# -tfce2D 
#-C 3.1