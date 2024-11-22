#!/bin/bash

#This script sets up the stage for the basic PALM models using hcppipelines CIFTI outputs (myelin maps, thickness) in 32k resolution

##INPUTS - concatenating all images to a 4D file for palm command
# Requires wb_command installed 


#hcppipeline outputs
dir_hcp=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/hcppipelines
dir_code=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo_32k

glm_inputs_dir=$dir_code/glm_inputs
glm_files_dir=$dir_code/glm_files

#make dirs but don't crash if they already exist
mkdir -p $glm_inputs_dir
mkdir -p $glm_files_dir

echo 'Grabbing input files...'

## unsmoothed myelin maps
output=$glm_inputs_dir/MyelinMaps_BC32k.dscalar.nii

#Grab all inputs
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/fsaverage_LR32k/*.MyelinMap_BC.32k_fs_LR.dscalar.nii)

wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 


#corr thickness maps
output=$glm_inputs_dir/corrThickness_32k.dscalar.nii
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/fsaverage_LR32k/*.corrThickness.32k_fs_LR.dscalar.nii)

wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 


##GLM - define your DESIGN MATRIX and DIRECTIONAL CONTRASTS as txt files and convert them to fsl vest format
#Here we defined a BASIC setup, using only group as a factor (2 sample T test with BLIND and SIGHTED)
#and a DEMO setup, including additional demographic covariants: sex & age (not mean-centered!)
#Requires FSL installed

echo 'Converting FSL design files...'

#BASIC
Text2Vest $glm_files_dir/design_basic.txt $glm_files_dir/design_basic.mat
Text2Vest $glm_files_dir/conBlind_basic.txt $glm_files_dir/conBlind_basic.con
Text2Vest $glm_files_dir/conSig_basic.txt $glm_files_dir/conSig_basic.con

#DEMO
Text2Vest $glm_files_dir/design_demo.txt $glm_files_dir/design_demo.mat
Text2Vest $glm_files_dir/conBlind_demo.txt $glm_files_dir/conBlind_demo.con
Text2Vest $glm_files_dir/conSig_demo.txt $glm_files_dir/conSig_demo.con

echo 'Done!'