#!/usr/bin/env bash

#Copyright Jacek Matuszewski

#This scripts uses wb_command to grab all the inputs for GLMs and concatenate them into a 4D file
#Then it prepares all the GLM files required by PALM (design matrix, contrasts etc.)

#installed wb_command is a requisite

#script assumes a YODA folder structure with code/src + inputs + outputs/derivatives

#SCRIPT FLOW: 


# SPECIFY YOUR MAIN YODA DIR AND SET UP ALL OTHER DIRS 
main_dir=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted

#hcppipeline outputs


dir_hcp=$main_dir/outputs/derivatives/hcppipelines
#dir_code=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo_32k
dir_output_stats=$main_dir/outputs/derivatives/PALM-stats
dir_output_ROIs=$main_dir/outputs/derivatives/wb_command-ROIs

glm_inputs_dir=$main_dir/inputs/palm_glm_files
glm_inputs_deriv=$dir_output_stats/glm_inputs
glm_files_dir=$dir_output_stats/glm_files



### PREPARE SPLIT BETWEEN GII and NII for TFCE

#Myelin Maps [-volume-all $glm_inputs_deriv/MyelinMaps_BC32k_data_sub.nii produces errors as there is no subcortical data here!]

#32k data
wb_command -cifti-separate $glm_inputs_deriv/SmoothedMyelinMaps_BC32k.dscalar.nii COLUMN -metric CORTEX_LEFT $glm_inputs_deriv/SmoothedMyelinMaps_BC32k_data_L.func.gii -metric CORTEX_RIGHT $glm_inputs_deriv/SmoothedMyelinMaps_BC32k_data_R.func.gii

wb_command -gifti-convert BASE64_BINARY $glm_inputs_deriv/SmoothedMyelinMaps_BC32k_data_L.func.gii $glm_inputs_deriv/SmoothedMyelinMaps_BC32k_data_L.func.gii
wb_command -gifti-convert BASE64_BINARY $glm_inputs_deriv/SmoothedMyelinMaps_BC32k_data_R.func.gii $glm_inputs_deriv/SmoothedMyelinMaps_BC32k_data_R.func.gii


wb_command -cifti-separate $glm_inputs_deriv/MyelinMaps_BC32k.dscalar.nii COLUMN -metric CORTEX_LEFT $glm_inputs_deriv/MyelinMaps_BC32k_data_L.func.gii -metric CORTEX_RIGHT $glm_inputs_deriv/MyelinMaps_BC32k_data_R.func.gii

wb_command -gifti-convert BASE64_BINARY $glm_inputs_deriv/MyelinMaps_BC32k_data_L.func.gii $glm_inputs_deriv/MyelinMaps_BC32k_data_L.func.gii
wb_command -gifti-convert BASE64_BINARY $glm_inputs_deriv/MyelinMaps_BC32k_data_R.func.gii $glm_inputs_deriv/MyelinMaps_BC32k_data_R.func.gii

#PREPARE VISUAL CORTEX MASK
wb_command -cifti-separate $dir_output_ROIs/BinaryTest_Glasser_VisualCortex_LR.32k_fs_LR.dlabel.nii COLUMN -metric CORTEX_LEFT $glm_inputs_deriv/Binary_Glasser_VisualCortex_L.func.gii -metric CORTEX_RIGHT $glm_inputs_deriv/Binary_Glasser_VisualCortex_R.func.gii

wb_command -gifti-convert BASE64_BINARY $glm_inputs_deriv/Binary_Glasser_VisualCortex_L.func.gii $glm_inputs_deriv/Binary_Glasser_VisualCortex_L.func.gii
wb_command -gifti-convert BASE64_BINARY $glm_inputs_deriv/Binary_Glasser_VisualCortex_R.func.gii $glm_inputs_deriv/Binary_Glasser_VisualCortex_R.func.gii

#File: sub-blind01.R.midthickness.32k_fs_LR.surf.gii
#Dir: /Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/hcppipelines/sub-blind01/MNINonLinear/fsaverage_LR32k

LIST_SUBJECTS=('sub-blind01' 'sub-blind02' 'sub-blind03' 'sub-blind04' 'sub-blind05' 'sub-blind06' 
    'sub-blind07' 'sub-blind08' 'sub-blind09' 'sub-blind10' 'sub-blind11' 'sub-blind12' 'sub-blind13' 'sub-blind14'
    'sub-blind15' 'sub-blind16' 'sub-blind17' 'sub-blind18' 'sub-blind19' 'sub-blind20' 'sub-sighted01' 'sub-sighted02' 'sub-sighted03' 
    'sub-sighted04' 'sub-sighted05' 'sub-sighted06' 'sub-sighted07' 'sub-sighted08' 'sub-sighted09' 
    'sub-sighted10' 'sub-sighted11' 'sub-sighted12' 'sub-sighted13' 'sub-sighted14' 
    'sub-sighted15' 'sub-sighted16' 'sub-sighted17' 'sub-sighted18' 'sub-sighted19' 'sub-sighted20')

#Average Surface Generation: LEFT HEMISPHERE
for sub in "${!LIST_SUBJECTS[@]}"; do

    surf_dir=$dir_hcp/${LIST_SUBJECTS[$sub]}/MNINonLinear/fsaverage_LR32k

    wb_command -surface-vertex-areas $surf_dir/${LIST_SUBJECTS[$sub]}.L.midthickness.32k_fs_LR.surf.gii $surf_dir/${LIST_SUBJECTS[$sub]}_L_midthick_va.shape.gii

done

L_avg_MERGELIST=""

for sub in "${!LIST_SUBJECTS[@]}" ; do

    surf_dir=$dir_hcp/${LIST_SUBJECTS[$sub]}/MNINonLinear/fsaverage_LR32k

   L_avg_MERGELIST="${L_MERGELIST} -metric $surf_dir/${LIST_SUBJECTS[$sub]}_L_midthick_va.shape.gii"

done
wb_command -metric-merge $glm_inputs_deriv/L_midthick_va.func.gii ${L_avg_MERGELIST}
wb_command -metric-reduce $glm_inputs_deriv/L_midthick_va.func.gii MEAN $glm_inputs_deriv/avg_L_area.func.gii

#Average Surface Generation: RIGHT HEMISPHERE
for sub in "${!LIST_SUBJECTS[@]}"; do

    surf_dir=$dir_hcp/${LIST_SUBJECTS[$sub]}/MNINonLinear/fsaverage_LR32k

    wb_command -surface-vertex-areas $surf_dir/${LIST_SUBJECTS[$sub]}.R.midthickness.32k_fs_LR.surf.gii $surf_dir/${LIST_SUBJECTS[$sub]}_R_midthick_va.shape.gii

done

R_avg_MERGELIST=""
for sub in "${!LIST_SUBJECTS[@]}" ; do

    surf_dir=$dir_hcp/${LIST_SUBJECTS[$sub]}/MNINonLinear/fsaverage_LR32k

   R_avg_MERGELIST="${R_MERGELIST} -metric $surf_dir/${LIST_SUBJECTS[$sub]}_R_midthick_va.shape.gii"

done
wb_command -metric-merge $glm_inputs_deriv/R_midthick_va.func.gii ${R_avg_MERGELIST}
wb_command -metric-reduce $glm_inputs_deriv/R_midthick_va.func.gii MEAN $glm_inputs_deriv/avg_R_area.func.gii