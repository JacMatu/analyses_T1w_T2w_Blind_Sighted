#Try to concatenate cifti files with wb_shorcuts

# HELP ON THAT FUNCTION
# wb command -cifti-convert
#https://humanconnectome.org/software/workbench-command/-cifti-convert


code_dir='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src'

atlas=$code_dir/PALM-stats_demo/MMP_Glasser_Atlas/Q1-Q6_RelatedValidation210.CorticalAreas_dil_Final_Final_Areas_Group_Colors_with_Atlas_ROIs2.32k_fs_LR.dlabel.nii


#SECTIONS FOR VISUAL CORTEX + VOTC: 
# 1 2 3 4 13

#Visual Cortex Labels: RIGHT HEMISPHERE
# 1 = R_V1_ROI
# 2 = R_MST_ROI
# 3 = R_V6_ROI
# 4 = R_V2_ROI
# 5 = R_V3_ROI
# 6 = R_V4_ROI  
# 7 = R_V8_ROI
# 13 = R_V3A_ROI
# 16 = R_V7_ROI
# 18 = R_FFC_ROI
# 19 = R_V3B_ROI
# 20 = R_LO1_ROI
# 21 = R_LO2_ROI
# 22 = R_PIT_ROI
# 23 = R_MT_ROI
# 138 = R_PH_ROI
# 153 = R_VMV1_ROI
# 154 = R_VMV3_RO
# 156 = R_V4t_ROI
# 157 = R_FST_ROI
# 158 = R_V3CD_ROI
# 159 = R_LO3_ROI
# 160 = R_VMV2_RO
# 163 = R_VVC_ROI


#'x1==1 || x1==2 || x1==3 || x1==4 || x1==5 || x1==6 || x1==7 || x1==13 || x1==16 || x1==18 || x1==19 || x1==20 || x1==21 || x1==22 || x1==23 || x1==138 || x1 == 153 || x1 == 154 || x1==156 || x1==157 || x1==158 || x1==159 || x1 == 160 || x1==163'

# 181 = L_V1_ROI



 #OK now try a single expression directly from atlas! BUT USE .dlabel.nii as an output! 
 
VisCortMask_R=$code_dir/PALM-stats_demo/MMP_Glasser_Atlas/Glasser_VisualCortex_R.32k_fs_LR.dlabel.nii

 wb_command -cifti-math \
    'x1==1 || x1==2 || x1==3 || x1==4 || x1==5 || x1==6 || x1==7 || x1==13 || x1==16 || x1==18 || x1==19 || x1==20 || x1==21 || x1==22 || x1==23 || x1==138 || x1 == 153 || x1 == 154 || x1==156 || x1==157 || x1==158 || x1==159 || x1 == 160 || x1==163' \
    $VisCortMask_R \
    -var x1 $atlas





########## INDIVIDUAL ROIS + PASTING THEM WITH MATH ##########
#MAKE A CIFTI LABEL INTO AN ROI - only works indivually per ROI and then they have to be pasted together...
#   wb_command -cifti-label-to-roi

#wb_command -cifti-label-to-roi \
#    $atlas \
#    $v1_left \
#    -name L_V1_ROI

#wb_command -cifti-label-to-roi \
#    $atlas \
#    $v1_right \
#    -name R_V1_ROI


#Now try to combine ROIs with MATHS! 

#v1_comb=$code_dir/PALM-stats_demo/MMP_Glasser_Atlas/math_R_L_V1_test.32k_fs_LR.dscalar.nii

#wb_command -cifti-math \
# 'x1 + x2' \
# $v1_comb \
# -var x1 $v1_left \
# -var x2 $v1_right