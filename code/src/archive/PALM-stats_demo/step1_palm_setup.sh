#!/bin/bash

#This script sets up the stage for the basic PALM models using hcppipelines CIFTI outputs (myelin maps, thickness) in 164k resolution

##INPUTS - concatenating all images to a 4D file for palm command
# Requires wb_command installed 


#hcppipeline outputs
dir_hcp=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/hcppipelines
output_dir=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo/glm_inputs
glm_files_dir='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo/glm_files'

#SMOOTHED MYELIN MAPS
output=$output_dir/SmoothedMyelinMaps_BC164k.dscalar.nii
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/*.SmoothedMyelinMap_BC.164k_fs_LR.dscalar.nii)

wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 

#UNSMOOTHED MYELIN MAPS
output=$output_dir/MyelinMaps_BC164k.dscalar.nii
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/*.MyelinMap_BC.164k_fs_LR.dscalar.nii)

wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 

# CORTICAL THICKNESS MAPS
output=$output_dir/Thickness_164k.dscalar.nii
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/*.thickness.164k_fs_LR.dscalar.nii)

wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 


##GLM - define your DESIGN MATRIX and DIRECTIONAL CONTRASTS as txt files and convert them to fsl vest format
#Here we defined a BASIC setup, using only group as a factor (2 sample T test with BLIND and SIGHTED)
#and a DEMO setup, including additional demographic covariants: sex & age (not mean-centered!)
#Requires FSL installed

code_dir=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo

#BASIC
Text2Vest $code_dir/glm_files/design_basic.txt $code_dir/glm_files/design_basic.mat
Text2Vest $code_dir/glm_files/conBlind_basic.txt $code_dir/glm_files/conBlind_basic.con
Text2Vest $code_dir/glm_files/conSig_basic.txt $code_dir/glm_files/conSig_basic.con

#DEMO
Text2Vest $code_dir/glm_files/design_demo.txt $code_dir/glm_files/design_demo.mat
Text2Vest $code_dir/glm_files/conBlind_demo.txt $code_dir/glm_files/conBlind_demo.con
Text2Vest $code_dir/glm_files/conSig_demo.txt $code_dir/glm_files/conSig_demo.con