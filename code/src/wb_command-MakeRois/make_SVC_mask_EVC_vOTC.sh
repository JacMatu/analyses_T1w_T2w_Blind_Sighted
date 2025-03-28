#!/usr/bin/env bash

#Copyright Jacek Matuszewski

#This scripts uses wb_command and a Glasser atlas in CIFTI files (cortex only, no subcortical structures) to extract ROIs from EVC and vOTC
#and paste them together, converted into dense scalars that can be used as a 'small volume correction' for statistics with MyelinMaps from hcppipelines

#installed wb_command is a requisite

#script assumes a YODA folder structure with code/src + inputs + outputs/derivatives

#SCRIPT FLOW: 
#   1. grab atlas and use a series of hand-piced ROI labels to create a dlabel.nii image for both hemispheres
#   2. change cifti mapping from dlabel.nii to dscalar.nii 

# SPECIFY YOUR MAIN YODA DIR AND SET UP ALL OTHER DIRS 
main_dir=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted

atlas_input=$main_dir/inputs/Glasser_atlas/Q1-Q6_RelatedValidation210.CorticalAreas_dil_Final_Final_Areas_Group_Colors.32k_fs_LR.dlabel.nii

derivatives_output=$main_dir/outputs/derivatives/wb_command-ROIs

#Make ROIs output, don't crash if it already exists
mkdir -p $derivatives_output


##### PREPARE RIGHT HEMISPHERE
echo 'Extracting ROIs from atlas...'

#ROI output
#ROI_label=$derivatives_output/Glasser_VisualCortex_LR.32k_fs_LR.dlabel.nii
ROI_label=$derivatives_output/BinaryTest_Glasser_VisualCortex_LR.32k_fs_LR.dlabel.nii

#Define expression, break across lines for elegance (ROI numbers explained at the bottom of the script)

#Right hemi
#exp='x1==1 || x1==2 || x1==3 || x1==4 || x1==5 || x1==6 || x1==7 || x1==13 || x1==16 '
#exp=$exp+'|| x1==18 || x1==19 || x1==20 || x1==21 || x1==22 || x1==23 || x1==138 || x1==153 '
#exp=$exp+'|| x1==154 || x1==156 || x1==157 || x1==158 || x1==159 || x1 == 160 || x1==163 '
#Left hemi
#exp=$exp+'|| x1==181 || x1==182 || x1==183 || x1==184 || x1==185 || x1==186 || x1==187 || x1==193 '
#exp=$exp+'|| x1==196 || x1==198 || x1==199 || x1==200 || x1==201 || x1 == 202 || x1==203 '
#exp=$exp+'|| x1==318 || x1==332 || x1==333 || x1==334 || x1==336 || x1 == 336 || x1==337 '
#exp=$exp+'|| x1==338 || x1==339 || x1==340 || x1==343'

#Try one huge line but it can't be stored in a variable because the || statements are executed and string is passed as bazilion small strongs 
#exp='x1==1 || x1==2 || x1==3 || x1==4 || x1==5 || x1==6 || x1==7 || x1==13 || x1==16 || x1==18 || x1==19 || x1==20 || x1==21 || x1==22 || x1==23 || x1==138 || x1==153 || x1==154 || x1==156 || x1==157 || x1==158 || x1==159 || x1 == 160 || x1==163 || x1==181 || x1==182 || x1==183 || x1==184 || x1==185 || x1==186 || x1==187 || x1==193 || x1==196 || x1==198 || x1==199 || x1==200 || x1==201 || x1 == 202 || x1==203 || x1==318 || x1==332 || x1==333 || x1==334 || x1==336 || x1 == 336 || x1==338 || x1==339 || x1==340 || x1==343'

#Execute the extraction from atlas
wb_command -cifti-math  \
    'x1==1 || x1==2 || x1==3 || x1==4 || x1==5 || x1==6 || x1==7 || x1==13 || x1==16 || x1==18 || x1==19 || x1==20 || x1==21 || x1==22 || x1==23 || x1==138 || x1==153 || x1==154 || x1==156 || x1==157 || x1==158 || x1==159 || x1 == 160 || x1==163 || x1==181 || x1==182 || x1==183 || x1==184 || x1==185 || x1==186 || x1==187 || x1==193 || x1==196 || x1==198 || x1==199 || x1==200 || x1==201 || x1 == 202 || x1==203 || x1==318 || x1==332 || x1==333 || x1==334 || x1==336 || x1 == 336 || x1==337 || x1==338 || x1==339 || x1==340 || x1==343'   \
    $ROI_label \
    -var x1 $atlas_input

#### CHANGE MAPPING TO SCALAR 
echo 'Changing cifti mapping to dense scalar...'

#ROI_scalar=$derivatives_output/Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii
ROI_scalar=$derivatives_output/BinaryTest_Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii

wb_command -cifti-change-mapping    \
    $ROI_label  \
    'ROW'   \
    $ROI_scalar \
    -scalar


echo 'Script done, check your new ROI in wb_view!'

#### TRY ONLY V1

ROI_label=$derivatives_output/V1_Glasser_VisualCortex_LR.32k_fs_LR.dlabel.nii

#Define expression, break across lines for elegance (ROI numbers explained at the bottom of the script)

#Right hemi
#exp='x1==1 
#Left hemi
#x1==181 |

#Execute the extraction from atlas
wb_command -cifti-math  \
   'x1==1 || x1==181'   \
    $ROI_label \
    -var x1 $atlas_input

#### CHANGE MAPPING TO SCALAR 
echo 'Changing cifti mapping to dense scalar...'

#ROI_scalar=$derivatives_output/Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii
ROI_scalar=$derivatives_output/V1_Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii

wb_command -cifti-change-mapping    \
    $ROI_label  \
    'ROW'   \
    $ROI_scalar \
    -scalar



#### TRY EVC AND vOTC

##VOTC ()
#Execute the extraction from atlas
ROI_label=$derivatives_output/vOTC_Glasser_VisualCortex_LR.32k_fs_LR.dlabel.nii

wb_command -cifti-math  \
   'x1==18 || x1==20 ||x1==21 ||x1==22||x1==138 ||x1==153 ||x1==160 ||x1==154 ||x1==157 ||x1==163 ||x1==198||x1==200 ||x1==201||x1==202||x1==333||x1==340||x1==334||x1==337||x1==343||x1==318'   \
    $ROI_label \
    -var x1 $atlas_input

echo 'Changing cifti mapping to dense scalar...'

ROI_scalar=$derivatives_output/vOTC_Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii

wb_command -cifti-change-mapping    \
    $ROI_label  \
    'ROW'   \
    $ROI_scalar \
    -scalar


##VOTC ()
#Execute the extraction from atlas
ROI_label=$derivatives_output/EVC_Glasser_VisualCortex_LR.32k_fs_LR.dlabel.nii

wb_command -cifti-math  \
   'x1== 1 || x1== 4 || x1== 5 ||x1== 181 || x1== 184 || x1== 185 '   \
    $ROI_label \
    -var x1 $atlas_input

echo 'Changing cifti mapping to dense scalar...'

ROI_scalar=$derivatives_output/EVC_Glasser_VisualCortex_LR.32k_fs_LR.dscalar.nii

wb_command -cifti-change-mapping    \
    $ROI_label  \
    'ROW'   \
    $ROI_scalar \
    -scalar

echo 'Script done, check your new ROI in wb_view!'



########## ROI LABELS AND NAMES 

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
# 152 = R_V6A_ROI
# 153 = R_VMV1_ROI
# 154 = R_VMV3_RO
# 156 = R_V4t_ROI
# 157 = R_FST_ROI
# 158 = R_V3CD_ROI
# 159 = R_LO3_ROI
# 160 = R_VMV2_RO
# 163 = R_VVC_ROI

#Visual Cortex Labels: LEFT HEMISPHERE
# 181 = L_V1_ROI
# 182 = L_MST_ROI
# 183 = L_V6_ROI
# 184 = L_V2_ROI
# 185 = L_V3_ROI
# 186 = L_V4_ROI  
# 187 = L_V8_ROI
# 193 = L_V3A_ROI
# 196 = L_V7_ROI
# 198 = L_FFC_ROI
# 199 = L_V3B_ROI
# 200 = L_LO1_ROI
# 201 = L_LO2_ROI
# 202 = L_PIT_ROI
# 203 = L_MT_ROI
# 318 = L_PH_ROI
# 332 = L_V6A_ROI
# 333 = L_VMV1_ROI
# 334 = L_VMV3_RO
# 336 = L_V4t_ROI
# 337 = L_FST_ROI
# 338 = L_V3CD_ROI
# 339 = L_LO3_ROI
# 340 = L_VMV2_RO
# 343 = L_VVC_ROI