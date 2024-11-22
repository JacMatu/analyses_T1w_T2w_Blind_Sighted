#Glasser told be to parcelate myelin map with an atlas into ROIs before palm. let's test it

this_dir='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo_32k/MMP_Glasser_Atlas/parcelation_tests'

myelin_map=$this_dir/sub-blind01.MyelinMap_BC.32k_fs_LR.dscalar.nii

atlas=$this_dir/Q1-Q6_RelatedValidation210.CorticalAreas_dil_Final_Final_Areas_Group_Colors.32k_fs_LR.dlabel.nii

output=$this_dir/test_cifti_parcelation.dscalar.nii

wb_command -cifti-parcellate \
    $myelin_map \
    $atlas \
    1 \
    $output


     #  wb_command -cifti-parcellate
 #     <cifti-in> - the cifti file to parcellate
 #     <cifti-label> - a cifti label file to use for the parcellation
 #     <direction> - which mapping to parcellate (integer, ROW, or COLUMN)
 #     <cifti-out> - output - output cifti file