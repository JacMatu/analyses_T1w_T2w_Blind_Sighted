#Try to concatenate cifti files with wb_shorcuts

# HELP ON THAT FUNCTION
# wb_shortcuts -cifti-concatenate

output='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats/SmoothedMyelinMaps_BC164k.dscalar.nii'
dir_hcp='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/hcppipelines'


#Grab all inputs
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/*.SmoothedMyelinMap_BC.164k_fs_LR.dscalar.nii)


wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 

#unsmoothed maps
output='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats/MyelinMaps_BC164k.dscalar.nii'
dir_hcp='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/hcppipelines'


#Grab all inputs
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/*.MyelinMap_BC.164k_fs_LR.dscalar.nii)


wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 


#thickness maps
output='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats/Thickness_164k.dscalar.nii'
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/*.thickness.164k_fs_LR.dscalar.nii)

wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 