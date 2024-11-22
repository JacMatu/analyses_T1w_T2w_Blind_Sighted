#Try to concatenate cifti files with wb_shorcuts

# HELP ON THAT FUNCTION
# wb command -cifti-convert
#https://humanconnectome.org/software/workbench-command/-cifti-convert


code_dir='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src'


#########################################
# TRY GOING FROM NII TO CIFTI [JuBrain] #
#########################################    

#mask_nii='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/JuBrain_ROIs/JuBrain_EVCvOTC.nii'
#ref_cifti='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo/glm_inputs/SmoothedMyelinMaps_BC164k.dscalar.nii'
#ref_cifti=$dir_hcp/sub-blind01/MNINonLinear/sub-blind01.SmoothedMyelinMap_BC.164k_fs_LR.dscalar.nii
##output='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo/glm_inputs/JuBrain_EVCvOTC_DenseTest.dscalar.nii'

#wb_command -cifti-convert -from-nifti \
#    $mask_nii \
#    $ref_cifti \
#    $output

#wb_command -cifti-create-dense-from-template  \
#    -volume-all $mask_nii \
#    -volume CORTEX \
#    $ref_cifti \
#    $output

#######################################
# Try parcelating Glasser MPM [cifti] #
#######################################   

atlas=$code_dir/PALM-stats_demo/MMP_Glasser_Atlas/Q1-Q6_RelatedValidation210.CorticalAreas_dil_Final_Final_Areas_Group_Colors_with_Atlas_ROIs2.32k_fs_LR.dlabel.nii
v1_left=$code_dir/PALM-stats_demo/MMP_Glasser_Atlas/L_V1_test.32k_fs_LR.dscalar.nii
v1_right=$code_dir/PALM-stats_demo/MMP_Glasser_Atlas/R_V1_test.32k_fs_LR.dscalar.nii

#Test labels 
# 1 = R_V1_ROI
# 181 = L_V1_ROI

#MAKE A CIFTI LABEL INTO AN ROI
#   wb_command -cifti-label-to-roi

wb_command -cifti-label-to-roi \
    $atlas \
    $v1_left \
    -name L_V1_ROI

wb_command -cifti-label-to-roi \
    $atlas \
    $v1_right \
    -name R_V1_ROI


#Now try to combine ROIs with MATHS! 

v1_comb=$code_dir/PALM-stats_demo/MMP_Glasser_Atlas/math_R_L_V1_test.32k_fs_LR.dscalar.nii

wb_command -cifti-math \
 'x1 + x2' \
 $v1_comb \
 -var x1 $v1_left \
 -var x2 $v1_right

 #OK now try a single expression directly from atlas! BUT USE .dlabel.nii as an output! 
 
v1_comb=$code_dir/PALM-stats_demo/MMP_Glasser_Atlas/mathATLAS_R_L_V1_test.32k_fs_LR.dlabel.nii

 wb_command -cifti-math \
    'x1 == 1 || x1 == 181' \
    $v1_comb \
    -var x1 $atlas

