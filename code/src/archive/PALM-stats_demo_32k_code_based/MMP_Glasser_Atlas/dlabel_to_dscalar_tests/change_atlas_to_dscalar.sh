#Glasser told be to parcelate myelin map with an atlas into ROIs before palm. let's test it

this_dir='/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/PALM-stats_demo_32k/MMP_Glasser_Atlas/dlabel_to_dscalar_tests'

atlas_label=$this_dir/Glasser_VisualCortex_R.32k_fs_LR.dlabel.nii

atlas_scalar=$this_dir/test_Glasser_VisualCortex_R.32k_fs_LR.dscalar.nii

# Just to see if pasting works!
# 1 = R_V1_ROI
# 2 = R_MST_ROI


#Test 1: CHANGE MAPPING TO SCALAR ALONG ROWS?!
wb_command -cifti-change-mapping \
    $atlas_label \
    'ROW' \
    $atlas_scalar \
    -scalar



#### TESTING FOLLOWING FUNCTIONS FROM wb_command: 

# This should change mapping from labels to scalar?
#wb_command -cifti-change-mapping
#      <data-cifti> - the cifti file to use the data from
#      <direction> - which direction on <data-cifti> to replace the mapping
#      <cifti-out> - output - the output cifti file


# This should create SCALAR outputs which can then be MERGED together? 
# wb_command -cifti-all-labels-to-rois
#      <label-in> - the input cifti label file
#      <map> - the number or name of the label map to use
#      <cifti-out> - output - the output cifti file


#This should be the same but individually for a ROI (should be looped!)
#MAKE A CIFTI LABEL INTO AN ROI
#   wb_command -cifti-label-to-roi
#      <label-in> - the input cifti label file
#      <scalar-out> - output - the output cifti scalar file

#      [-name] - select label by name
#         <label-name> - the label name that you want an roi of

#      [-key] - select label by key
#         <label-key> - the label key that you want an roi of

#      [-map] - select a single label map to use
#         <map> - the map number or name