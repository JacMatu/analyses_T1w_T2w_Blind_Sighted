#Try to concatenate cifti files with wb_shorcuts

# HELP ON THAT FUNCTION
# wb_shortcuts -cifti-concatenate

output_blind='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats/AverageBlindSmoothedMyelinMaps_BC164k.dscalar.nii'
output_sighted='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats/AverageSightedSmoothedMyelinMaps_BC164k.dscalar.nii'
dir_hcp='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/hcppipelines'


#Grab all inputs
inputs_blind=$(ls $dir_hcp/sub-*/MNINonLinear/sub-blind*.SmoothedMyelinMap_BC.164k_fs_LR.dscalar.nii)
inputs_sighted=$(ls $dir_hcp/sub-*/MNINonLinear/sub-sighted*.SmoothedMyelinMap_BC.164k_fs_LR.dscalar.nii)

wb_command -cifti-average \
    <cifti-out> $output_blind \
    <cifti-in> $inputs_blind

    
wb_command -cifti-average \
    $output_sighted \
    $inputs_sighted

