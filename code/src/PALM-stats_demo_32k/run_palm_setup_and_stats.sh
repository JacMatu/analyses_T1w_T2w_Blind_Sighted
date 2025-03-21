#!/usr/bin/env bash

#Copyright Jacek Matuszewski

#This scripts uses wb_command to grab all the inputs for GLMs and concatenate them into a 4D file
#Then it prepares all the GLM files required by PALM (design matrix, contrasts etc.)

#installed wb_command is a requisite

#script assumes a YODA folder structure with code/src + inputs + outputs/derivatives

# SPECIFY YOUR MAIN YODA DIR AND SET UP ALL OTHER DIRS 
main_dir=/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted

#WHERE IS YOUR PALM PROGRAM?
palm_exe=/Users/jacekmatuszewski/Documents/GitHub/PALM/palm

dir_hcp=$main_dir/outputs/derivatives/hcppipelines
dir_deriv_stats=$main_dir/outputs/derivatives/PALM-stats
dir_output_ROIs=$main_dir/outputs/derivatives/wb_command-ROIs

dir_glm_inputs=$main_dir/inputs/palm_glm_files



#Define your basic setup
Res='32k'
Smoothed='Smoothed'
Demo='demo' #'demo' or 'basic'
ReverseMask=1 #do you want to run a model in the rest of the brain apart from your mask?

## WHICH PARTS OF THE SCRIPT YOU WANT TO RUN?
#Do you want your derivatives and glm giles set up
glm_setup=1
#Do you want to prepare your CIFTI files for TFCE?
palm_tfce_setup=1
#Do you want to run your PALM stats?
palm_tfce_stats=1
#Do you want to build CIFTI files from your results?
palm_build_cifti=1

#Your GLM output
dir_output_model=$dir_deriv_stats/final_TFCE_${Smoothed}_Demo_${Res}


########## GLM DERIVATIVES SETUP ##########

if [ $glm_setup -eq 1 ]; then


    echo 'Setting up GLM files...'
    
    #Place for your PALM stats
    mkdir -p $dir_output_model
    #Place for your group-averaged maps for visualization
    mkdir -p $dir_deriv_stats/average_visualizations

    ## smoothed myelin maps - put them directly to your stats dir for palm!
    output=$dir_output_model/${Smoothed}MyelinMaps_BC${Res}.dscalar.nii

    #Grab all inputs in 32k resolution
    echo 'Grabbing input files...'

    inputs=$(ls $dir_hcp/sub-*/MNINonLinear/fsaverage_LR32k/*.${Smoothed}MyelinMap_BC.${Res}_fs_LR.dscalar.nii)

    wb_shortcuts -cifti-concatenate \
        $output \
        $inputs 

    ##GLM - define your DESIGN MATRIX and DIRECTIONAL CONTRASTS as txt files and convert them to fsl vest format
    # Here we defined a BASIC setup, using only group as a factor (2 sample T test with BLIND and SIGHTED)
    #and a DEMO setup, including additional demographic covariants: sex & age (not mean-centered!)
    #Requires FSL installed

    echo 'Converting FSL design files...'

    #GLM files (design matrix and contrasts) - basic or demographic?
    Text2Vest $dir_glm_inputs/design_${Demo}.txt $dir_output_model/design_${Demo}.mat
    Text2Vest $dir_glm_inputs/conBlind_${Demo}.txt $dir_output_model/conBlind_${Demo}.con
    Text2Vest $dir_glm_inputs/conSig_${Demo}.txt $dir_output_model/conSig_${Demo}.con

    echo 'Done!'        
fi

########## PALM TFCE FILES SETUP ##########

if [ $palm_tfce_setup -eq 1 ]; then 

    echo 'Setting up PALM TFCE files...'
    ## Prepare the Visual Cortex Mask for TFCE

    wb_command -cifti-separate $dir_output_ROIs/BinaryTest_Glasser_VisualCortex_LR.32k_fs_LR.dlabel.nii COLUMN \
        -metric CORTEX_LEFT $dir_output_model/Binary_Glasser_VisualCortex_L.func.gii \
        -metric CORTEX_RIGHT $dir_output_model/Binary_Glasser_VisualCortex_R.func.gii

    wb_command -gifti-convert BASE64_BINARY $dir_output_model/Binary_Glasser_VisualCortex_L.func.gii $dir_output_model/Binary_Glasser_VisualCortex_L.func.gii
    wb_command -gifti-convert BASE64_BINARY $dir_output_model/Binary_Glasser_VisualCortex_R.func.gii $dir_output_model/Binary_Glasser_VisualCortex_R.func.gii

    ## Generate an average surface area file for each hemisphere 
    #Split the hemispheres data
    wb_command -cifti-separate \
        $dir_output_model/${Smoothed}MyelinMaps_BC${Res}.dscalar.nii COLUMN \
        -metric CORTEX_LEFT $dir_output_model/${Smoothed}MyelinMaps_BC${Res}_data_L.func.gii \
        -metric CORTEX_RIGHT $dir_output_model/${Smoothed}MyelinMaps_BC${Res}_data_R.func.gii

    # Convert to readable format
    wb_command -gifti-convert BASE64_BINARY $dir_output_model/${Smoothed}MyelinMaps_BC${Res}_data_L.func.gii $dir_output_model/${Smoothed}MyelinMaps_BC${Res}_data_L.func.gii
    wb_command -gifti-convert BASE64_BINARY $dir_output_model/${Smoothed}MyelinMaps_BC${Res}_data_R.func.gii $dir_output_model/${Smoothed}MyelinMaps_BC${Res}_data_R.func.gii

    #List your subjects - probably could be done by reading the directory names in hcppiepelines
    LIST_SUBJECTS=('sub-blind01' 'sub-blind02' 'sub-blind03' 'sub-blind04' 'sub-blind05' 'sub-blind06' 
    'sub-blind07' 'sub-blind08' 'sub-blind09' 'sub-blind10' 'sub-blind11' 'sub-blind12' 'sub-blind13' 'sub-blind14'
    'sub-blind15' 'sub-blind16' 'sub-blind17' 'sub-blind18' 'sub-blind19' 'sub-blind20' 'sub-sighted01' 'sub-sighted02' 'sub-sighted03' 
    'sub-sighted04' 'sub-sighted05' 'sub-sighted06' 'sub-sighted07' 'sub-sighted08' 'sub-sighted09' 
    'sub-sighted10' 'sub-sighted11' 'sub-sighted12' 'sub-sighted13' 'sub-sighted14' 
    'sub-sighted15' 'sub-sighted16' 'sub-sighted17' 'sub-sighted18' 'sub-sighted19' 'sub-sighted20') 


    #Convert surfaces to vertex areas in each subject
    for sub in "${!LIST_SUBJECTS[@]}"; do

        surf_dir=$dir_hcp/${LIST_SUBJECTS[$sub]}/MNINonLinear/fsaverage_LR32k

        wb_command -surface-vertex-areas $surf_dir/${LIST_SUBJECTS[$sub]}.L.midthickness.32k_fs_LR.surf.gii $surf_dir/${LIST_SUBJECTS[$sub]}_L_midthick_va.shape.gii
        wb_command -surface-vertex-areas $surf_dir/${LIST_SUBJECTS[$sub]}.R.midthickness.32k_fs_LR.surf.gii $surf_dir/${LIST_SUBJECTS[$sub]}_R_midthick_va.shape.gii

    done

    L_avg_MERGELIST=""
    R_avg_MERGELIST=""

    # Gather all VA files into lists for averaging 
    for sub in "${!LIST_SUBJECTS[@]}" ; do

        surf_dir=$dir_hcp/${LIST_SUBJECTS[$sub]}/MNINonLinear/fsaverage_LR32k

        L_avg_MERGELIST="${L_MERGELIST} -metric $surf_dir/${LIST_SUBJECTS[$sub]}_L_midthick_va.shape.gii"
        R_avg_MERGELIST="${R_MERGELIST} -metric $surf_dir/${LIST_SUBJECTS[$sub]}_R_midthick_va.shape.gii"

    done
 
    # Merge the average surface area files into final products 
    wb_command -metric-merge $dir_output_model/L_midthick_va.func.gii ${L_avg_MERGELIST}
    wb_command -metric-reduce $dir_output_model/L_midthick_va.func.gii MEAN $dir_output_model/avg_L_area.func.gii
    wb_command -metric-merge $dir_output_model/R_midthick_va.func.gii ${R_avg_MERGELIST}
    wb_command -metric-reduce $dir_output_model/R_midthick_va.func.gii MEAN $dir_output_model/avg_R_area.func.gii   

    echo 'Done!'
fi

########## PALM TFCE STATS ##########
if [ $palm_tfce_stats -eq 1 ]; then 

    echo 'Setting up PALM TFCE stats...'

    LIST_HEMI=('L' 'R')

    cd $dir_output_model

    #Grab the surface files -HARDCODED FOR NOW, IT'S JUST A TEMPLATE SURFACE
    cp $dir_hcp/sub-blind01/MNINonLinear/fsaverage_LR32k/sub-blind01.L.midthickness.32k_fs_LR.surf.gii $dir_output_model
    cp $dir_hcp/sub-blind01/MNINonLinear/fsaverage_LR32k/sub-blind01.R.midthickness.32k_fs_LR.surf.gii $dir_output_model

    for hemi in "${!LIST_HEMI[@]}" ; do
    
        #Define files for palm model with a visual cortex mask
        input_file=${Smoothed}MyelinMaps_BC${Res}_data_${LIST_HEMI[$hemi]}.func.gii
        mask_file=Binary_Glasser_VisualCortex_${LIST_HEMI[$hemi]}.func.gii
        surf_file=sub-blind01.${LIST_HEMI[$hemi]}.midthickness.${Res}_fs_LR.surf.gii
        surf_avg=avg_${LIST_HEMI[$hemi]}_area.func.gii
        output=hemi_${Smoothed}MyelinDemo${Res}_VisCort_${LIST_HEMI[$hemi]}

        echo 'Running palm within the MASK...'

        $palm_exe \
            -i $input_file \
            -d design_demo.mat \
            -t conSig_demo.con \
            -d design_demo.mat \
            -t conBlind_demo.con \
            -T -tfce2D \
            -m $mask_file \
            -s $surf_file $surf_avg \
            -o $output \
            -fdr  -n 10000

        #CHECK FOR REVERSE MASK MODEL?  - LEAVE THAT FOR LATER! 

       # if [ $ReverseMask -eq 1 ]; then 
       # output=hemi_${Smooth}MyelinDemo${Res}_ReverseMask_${LIST_HEMI[$hemi]}

       # echo 'Running palm outside the MASK...'

       # $palm_exe \
       #     -i $input_file \
       #     -d design_demo.mat \
       #     -t conSig_demo.con \
       #     -d design_demo.mat \
       #     -t conBlind_demo.con \
       #     -T -tfce2D \
       #     -reversemasks \
       #     -m $mask_file \
       #     -s $surf_file $surf_avg \
       #     -o $output \
       #     -corrcon \
       #     -fdr  -n 10

       # fi

    done

     
    echo 'Stats Done!'
fi


########## BUILD CIFTI FILES ##########
if [ $palm_build_cifti -eq 1 ]; then

   echo 'Building new CIFTI files to view the results...'
        mkdir -p $dir_output_model/cifti_results

        output_cifti=cifti_${Smoothed}MyelinDemo${Res}_VisCort
        output=hemi_${Smoothed}MyelinDemo${Res}_VisCort
        #Pay attention to the order of contrasts
        # d1 = Sighted > Blind
        # d2 = Blind > Sighted

        #GRAB BOTH VOXEL WISE AND TFCE? 
        LIST_STATS=('dpv' 'tfce')

        #WHICH PVALUE CORRECTIONS DO YOU WANT?
        LIST_PVAL=('uncp' 'fdrp' 'fwep') 

        for stat in "${!LIST_STATS[@]}" ; do
            for pval in "${!LIST_PVAL[@]}" ; do
        wb_command \
            -cifti-create-dense-from-template \
            $dir_output_model/${Smoothed}MyelinMaps_BC${Res}.dscalar.nii \
            $dir_output_model/cifti_results/${output_cifti}_SightedGtBlind_${LIST_STATS[$stat]}_tstat_${LIST_PVAL[$pval]}.dscalar.nii \
            -metric CORTEX_LEFT $dir_output_model/${output}_L_dpv_tstat_${LIST_PVAL[$pval]}_d1.gii \
            -metric CORTEX_RIGHT $dir_output_model/${output}_R_dpv_tstat_${LIST_PVAL[$pval]}_d1.gii

        wb_command \
            -cifti-create-dense-from-template \
            $dir_output_model/${Smoothed}MyelinMaps_BC${Res}.dscalar.nii \
            $dir_output_model/cifti_results/${output_cifti}_BlindGtSighted_${LIST_STATS[$stat]}_tstat_${LIST_PVAL[$pval]}.dscalar.nii \
            -metric CORTEX_LEFT $dir_output_model/${output}_L_dpv_tstat_${LIST_PVAL[$pval]}_d2.gii \
            -metric CORTEX_RIGHT $dir_output_model/${output}_R_dpv_tstat_${LIST_PVAL[$pval]}_d2.gii
        
            done
        done

    echo 'CIFTI files created! Remember to BONF correct them for contrasts and hemispheres if applicable!'
fi