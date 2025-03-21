#Try to concatenate cifti files with wb_shorcuts

#This script averages input files across all subjects within one group FOR VISUALIZATION PURPOSES

# HELP ON THAT FUNCTION
# wb_command -cifti-average 
#wb_command -cifti-average \
#    <cifti-out> $output_blind \
#    <cifti-in> $inputs_blind

main_dir=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted

dir_hcp=$main_dir/outputs/derivatives/hcppipelines
dir_output=$main_dir/outputs/derivatives/wb_command-ROIs

mkdir -p $dir_output/average_visualisations

#SMOOTHED MYELIN MAPS
output_blind=$dir_output/average_visualisations/AverageBlindSmoothedMyelinMaps_BC.32k.dscalar.nii
output_sighted=$dir_output/average_visualisations/AverageSightedSmoothedMyelinMaps_BC.32k.dscalar.nii
   
inputs_blind=$(ls $dir_hcp/*/MNINonLinear/fsaverage_LR32k/sub-blind*.SmoothedMyelinMap_BC.32k_fs_LR.dscalar.nii)
inputs_sighted=$(ls $dir_hcp/*/MNINonLinear/fsaverage_LR32k/sub-sighted*.SmoothedMyelinMap_BC.32k_fs_LR.dscalar.nii)

#Concatenate group-specific files to 4D
wb_shortcuts -cifti-concatenate \
    $dir_output/average_visualisations/4D_Blind_SmoothedMyelinMap.dscalar.nii \
    $inputs_blind 

wb_shortcuts -cifti-concatenate \
    $dir_output/average_visualisations/4D_Sighted_SmoothedMyelinMap.dscalar.nii \
    $inputs_sighted

#Average each group
wb_command -cifti-average \
    $output_blind \
    -cifti $dir_output/average_visualisations/4D_Blind_SmoothedMyelinMap.dscalar.nii

wb_command -cifti-average \
    $output_sighted \
    -cifti $dir_output/average_visualisations/4D_Sighted_SmoothedMyelinMap.dscalar.nii



#UNSMOOTHED MYELIN MAPS
output_blind=$dir_output/average_visualisations/AverageBlindMyelinMaps_BC.32k.dscalar.nii
output_sighted=$dir_output/average_visualisations/AverageSightedMyelinMaps_BC.32k.dscalar.nii
   
inputs_blind=$(ls $dir_hcp/*/MNINonLinear/fsaverage_LR32k/sub-blind*.MyelinMap_BC.32k_fs_LR.dscalar.nii)
inputs_sighted=$(ls $dir_hcp/*/MNINonLinear/fsaverage_LR32k/sub-sighted*.MyelinMap_BC.32k_fs_LR.dscalar.nii)

#Concatenate group-specific files to 4D
wb_shortcuts -cifti-concatenate \
    $dir_output/average_visualisations/4D_Blind_MyelinMap.dscalar.nii \
    $inputs_blind 

wb_shortcuts -cifti-concatenate \
    $dir_output/average_visualisations/4D_Sighted_MyelinMap.dscalar.nii \
    $inputs_sighted

#Average each group
wb_command -cifti-average \
    $output_blind \
    -cifti $dir_output/average_visualisations/4D_Blind_MyelinMap.dscalar.nii

wb_command -cifti-average \
    $output_sighted \
    -cifti $dir_output/average_visualisations/4D_Sighted_MyelinMap.dscalar.nii



#CORTICAL THICKNESS MAPS
#output_blind=$dir_output/average_visualisations/AverageBlindThickness_164k.dscalar.nii
#output_sighted=$dir_output/average_visualisations/AverageSightedThickness_164k.dscalar.nii

#inputs_blind=$(ls $dir_hcp/*/MNINonLinear/sub-blind*.thickness.164k_fs_LR.dscalar.nii)
#inputs_sighted=$(ls $dir_hcp/*/MNINonLinear/sub-sighted*.thickness.164k_fs_LR.dscalar.nii)

#Concatenate group-specific files to 4D
#wb_shortcuts -cifti-concatenate \
#    $dir_output/average_visualisations/4D_Blind_Thickness.dscalar.nii \
#    $inputs_blind 

#wb_shortcuts -cifti-concatenate \
#    $dir_output/average_visualisations/4D_Sighted_Thickness.dscalar.nii \
#    $inputs_sighted

#Average each group
#wb_command -cifti-average \
#    $output_blind \
#    -cifti $dir_output/average_visualisations/4D_Blind_Thickness.dscalar.nii

#wb_command -cifti-average \
#    $output_sighted \
#    -cifti $dir_output/average_visualisations/4D_Sighted_Thickness.dscalar.nii


##CLEAN-UP THE 4D FILE LISTS?
find $dir_output/average_visualisations/ -type f -name '*4D_*.dscalar.nii' -delete