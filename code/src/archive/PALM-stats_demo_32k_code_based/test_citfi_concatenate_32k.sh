#Try to concatenate cifti files with wb_shorcuts for a 4D input file joining BOTH groups (separated by a design matrix!)

# HELP ON THAT FUNCTION
# wb_shortcuts -cifti-concatenate

dir_hcp='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/hcppipelines'

#unsmoothed maps
output='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo_32k/glm_inputs/MyelinMaps_BC32k.dscalar.nii'

#Grab all inputs
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/fsaverage_LR32k/*.MyelinMap_BC.32k_fs_LR.dscalar.nii)

wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 

#thickness maps
output='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo_32k/glm_inputs/corrThickness_32k.dscalar.nii'
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/fsaverage_LR32k/*.corrThickness.32k_fs_LR.dscalar.nii)

wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 