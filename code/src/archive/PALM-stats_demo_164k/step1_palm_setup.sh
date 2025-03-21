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

glm_inputs_dir=$main_dir/inputs/palm_glm_files
glm_inputs_deriv=$dir_output_stats/glm_inputs
glm_files_dir=$dir_output_stats/glm_files

#prepare for future steps
mkdir -p $dir_output_stats/average_visualizations
mkdir -p $dir_output_stats/glm_outputs

#make dirs but don't crash if they already exist
mkdir -p $glm_inputs_deriv
mkdir -p $glm_files_dir

echo 'Grabbing input files...'

## unsmoothed myelin maps
output=$glm_inputs_deriv/MyelinMaps_BC164k.dscalar.nii

#Grab all inputs in 32k resolution
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/*.MyelinMap_BC.164k_fs_LR.dscalar.nii)

wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 


## smoothed myelin maps
output=$glm_inputs_deriv/SmoothedMyelinMaps_BC164k.dscalar.nii

#Grab all inputs in 32k resolution
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/*.SmoothedMyelinMap_BC.164k_fs_LR.dscalar.nii)

wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 


#corr thickness maps
output=$glm_inputs_deriv/corrThickness_164k.dscalar.nii
inputs=$(ls $dir_hcp/sub-*/MNINonLinear/*.corrThickness.164k_fs_LR.dscalar.nii)

wb_shortcuts -cifti-concatenate \
    $output \
    $inputs 


##GLM - define your DESIGN MATRIX and DIRECTIONAL CONTRASTS as txt files and convert them to fsl vest format
#Here we defined a BASIC setup, using only group as a factor (2 sample T test with BLIND and SIGHTED)
#and a DEMO setup, including additional demographic covariants: sex & age (not mean-centered!)
#Requires FSL installed

echo 'Converting FSL design files...'

#BASIC
Text2Vest $glm_inputs_dir/design_basic.txt $glm_inputs_deriv/design_basic.mat
Text2Vest $glm_inputs_dir/conBlind_basic.txt $glm_inputs_deriv/conBlind_basic.con
Text2Vest $glm_inputs_dir/conSig_basic.txt $glm_inputs_deriv/conSig_basic.con

#DEMO
Text2Vest $glm_inputs_dir/design_demo.txt $glm_inputs_deriv/design_demo.mat
Text2Vest $glm_inputs_dir/conBlind_demo.txt $glm_inputs_deriv/conBlind_demo.con
Text2Vest $glm_inputs_dir/conSig_demo.txt $glm_inputs_deriv/conSig_demo.con

echo 'Done!'