#!/usr/bin/env bash

palm_exe=/Users/jacekmatuszewski/Documents/GitHub/PALM/palm

#TESTING PHASE 
#Myelin
output_dir=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/PALM-stats/glm_outputs/TFCE_Anderson_MyelinMaps_Demographic_32k_WholeBrain
mkdir -p $output_dir

cd $output_dir


## ANDERSON UPDATE: The surface provided in -s argument cannot be a cifti mapped file (like the average area file) but has to be a surface file!) 
#So... in `test_TFCE_setup.sh` we have to generate the average area file for each subject and then merge them into one file for each hemisphere.
#Then, we can use these files in the -s SECOND argument. But the first still has to be the SURFACE file!

#Now, does it have to be one file per subject? Or are they all in FS32k space anyway? 

#Here I will test it using surface file from two exepmlary subjects: blind01 and sighted01. 

#Left = sub-blind01.L.midthickness.32k_fs_LR.surf.gii
#Right = sub-sighted01.R.midthickness.32k_fs_LR.surf.gii

#LIST_HEMI=('L' 'R')
LIST_HEMI=('R')

Smooth=('Smoothed') # ('' 'Smoothed')
Res=('32k') # ('164k' '32k')
 
glm_inputs_dir=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/outputs/derivatives/PALM-stats/glm_inputs

for hemi in "${!LIST_HEMI[@]}" ; do

    #Define files
    input_file=${Smooth}MyelinMaps_BC${Res}_data_${LIST_HEMI[$hemi]}.func.gii
    mask_file=Binary_Glasser_VisualCortex_${LIST_HEMI[$hemi]}.func.gii
    surf_file=sub-blind01.${LIST_HEMI[$hemi]}.midthickness.${Res}_fs_LR.surf.gii
    surf_avg=avg_${LIST_HEMI[$hemi]}_area.func.gii
    output=hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_${LIST_HEMI[$hemi]}

    $palm_exe \
        -i $input_file \
        -d design_demo.mat \
        -t conSig_demo.con \
        -T -tfce2D \
        -C 3.1 \
        -m $mask_file \
        -s $surf_file $surf_avg \
        -o $output \
        -fdr  -n 10000


    #just a quick control - does it matter which surface is chosen?
    surf_file=sub-sighted01.${LIST_HEMI[$hemi]}.midthickness.32k_fs_LR.surf.gii
    output=hemi_sighted01_MyelinDemo32_VisCort_Sig_gt_Bl_${LIST_HEMI[$hemi]}
    
    $palm_exe \
        -i $input_file \
        -d design_demo.mat \
        -t conSig_demo.con \
        -T -tfce2D \
        -C 3.1 \
        -m $mask_file \
        -s $surf_file $surf_avg \
        -o $output \
        -fdr  -n 10000
done


## MERGE HEMISPHERE RESULTS FOR A CIIFTI FILE

#Sighted Surf vs Blind Surf
wb_command \
    -cifti-create-dense-from-template \
    MyelinMaps_BC32k.dscalar.nii \
    hemi_blind01_MyelinDemo${Res}_VisCort_Sig_gt_Bl_merged_dpv_tstat_uncp.dscalar.nii \
    -metric CORTEX_LEFT hemi_blind01_MyelinDemo32_VisCort_Sig_gt_Bl_L_dpv_tstat_uncp.gii \
    -metric CORTEX_RIGHT hemi_blind01_MyelinDemo32_VisCort_Sig_gt_Bl_R_dpv_tstat_uncp.gii


wb_command \
    -cifti-create-dense-from-template \
    MyelinMaps_BC32k.dscalar.nii \
    hemi_sighted01_MyelinDemo${Res}_VisCort_Sig_gt_Bl_merged_dpv_tstat_uncp.dscalar.nii \
    -metric CORTEX_LEFT hemi_sighted01_MyelinDemo32_VisCort_Sig_gt_Bl_L_dpv_tstat_uncp.gii \
    -metric CORTEX_RIGHT hemi_sighted01_MyelinDemo32_VisCort_Sig_gt_Bl_R_dpv_tstat_uncp.gii

#Voxel
wb_command \
    -cifti-create-dense-from-template \
    SmoothedMyelinMaps_BC32k.dscalar.nii \
    hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_merged_dpv_tstat_fdrp.dscalar.nii \
    -metric CORTEX_LEFT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_L_dpv_tstat_fdrp.gii \
    -metric CORTEX_RIGHT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_R_dpv_tstat_fdrp.gii

wb_command \
    -cifti-create-dense-from-template \
    SmoothedMyelinMaps_BC32k.dscalar.nii \
    hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_merged_dpv_tstat_fwep.dscalar.nii \
    -metric CORTEX_LEFT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_L_dpv_tstat_fwep.gii \
    -metric CORTEX_RIGHT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_R_dpv_tstat_fwep.gii

    wb_command \
    -cifti-create-dense-from-template \
    SmoothedMyelinMaps_BC32k.dscalar.nii \
    hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_merged_dpv_tstat_uncp.dscalar.nii \
    -metric CORTEX_LEFT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_L_dpv_tstat_uncp.gii \
    -metric CORTEX_RIGHT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_R_dpv_tstat_uncp.gii


#TFCE

wb_command \
    -cifti-create-dense-from-template \
    SmoothedMyelinMaps_BC32k.dscalar.nii \
    hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_merged_tfce_tstat_fdrp.dscalar.nii \
    -metric CORTEX_LEFT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_L_tfce_tstat_fdrp.gii \
    -metric CORTEX_RIGHT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_R_tfce_tstat_fdrp.gii

#unsmoothed
wb_command \
    -cifti-create-dense-from-template \
    SmoothedMyelinMaps_BC32k.dscalar.nii \
    hemi_blind01_MyelinDemo${Res}_VisCort_Sig_gt_Bl_merged_tfce_tstat_fdrp.dscalar.nii \
    -metric CORTEX_LEFT hemi_blind01_MyelinDemo${Res}_VisCort_Sig_gt_Bl_L_tfce_tstat_fdrp.gii \
    -metric CORTEX_RIGHT hemi_blind01_MyelinDemo${Res}_VisCort_Sig_gt_Bl_R_tfce_tstat_fdrp.gii


wb_command \
    -cifti-create-dense-from-template \
    SmoothedMyelinMaps_BC32k.dscalar.nii \
    hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_merged_tfce_tstat_fwep.dscalar.nii \
    -metric CORTEX_LEFT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_L_tfce_tstat_fwep.gii \
    -metric CORTEX_RIGHT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_R_tfce_tstat_fwep.gii

wb_command \
    -cifti-create-dense-from-template \
    SmoothedMyelinMaps_BC32k.dscalar.nii \
    hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_merged_tfce_tstat_uncp.dscalar.nii \
    -metric CORTEX_LEFT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_L_tfce_tstat_uncp.gii \
    -metric CORTEX_RIGHT hemi_blind01_${Smooth}MyelinDemo${Res}_VisCort_Sig_gt_Bl_R_tfce_tstat_uncp.gii


#Compare T stats from blind and sighted surfaces
wb_command \
    -cifti-create-dense-from-template \
   MyelinMaps_BC32k.dscalar.nii \
    hemi_blind01_MyelinDemo${Res}_VisCort_Sig_gt_Bl_merged_dpv_tstat.dscalar.nii \
    -metric CORTEX_LEFT hemi_blind01_MyelinDemo32k_VisCort_Sig_gt_Bl_R_dpv_tstat.gii \
    -metric CORTEX_RIGHT hemi_blind01_MyelinDemo32k_VisCort_Sig_gt_Bl_R_dpv_tstat.gii

    wb_command \
    -cifti-create-dense-from-template \
   MyelinMaps_BC32k.dscalar.nii \
    hemi_sighted01_MyelinDemo${Res}_VisCort_Sig_gt_Bl_merged_dpv_tstat.dscalar.nii \
    -metric CORTEX_LEFT hemi_sighted01_MyelinDemo32_VisCort_Sig_gt_Bl_L_dpv_tstat.gii \
    -metric CORTEX_RIGHT hemi_sighted01_MyelinDemo32_VisCort_Sig_gt_Bl_R_dpv_tstat.gii