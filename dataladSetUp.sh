#!/usr/bin/env bash

root_dir=${PWD}
raw_dir=${root_dir}/inputs/raw
derivatives_dir=${root_dir}/outputs/derivatives
hcp_dir=${derivatives_dir}/hcppipelines
roi_dir=${derivatives_dir}/wb_command-ROIs
stats_dir=${derivatives_dir}/PALM-stats

# get url of the gin repos from config
source dataladConfig.sh

# install raw dataset
datalad install -d . -s "${URL_RAW}" "${raw_dir}"

# create the derivatives universe of classic sub-subdatasets ()
# . outputs
# └── derivatives
#     ├── bidspm-preproc
#     └── bidspm-stats

datalad create -d . "${derivatives_dir}"

if [ ! -z "${GIN_BASENAME}" ]; then
    cd "${derivatives_dir}"
    datalad create-sibling-gin -d . -s origin --access-protocol ssh --private --credential JacMat_gin_token cpp_brewery/"${GIN_BASENAME}"-derivatives 
    #datalad sibling add --name origin --url "${URL_DER} 
    cd "${root_dir}"
    datalad subdatasets --set-property url git@gin.g-node.org:/cpp_brewery/"${GIN_BASENAME}"-derivatives.git "${derivatives_dir}"
fi

cd "${derivatives_dir}"

# HCPPIPELINES IN DERIVATIVES
datalad create -d . "${hcp_dir}"

if [ ! -z "${GIN_BASENAME}" ]; then
    cd "${hcp_dir}"
    datalad create-sibling-gin -d . -s origin --access-protocol ssh --private --credential JacMat_gin_token cpp_brewery/"${GIN_BASENAME}"-derivatives-hcppipelines
    cd "${derivatives_dir}"
    datalad subdatasets --set-property url git@gin.g-node.org:/cpp_brewery/"${GIN_BASENAME}"-derivatives-hcppipelines.git hcppipelines
fi

datalad create -d . "${roi_dir}"

if [ ! -z "${GIN_BASENAME}" ]; then
    cd "${roi_dir}"
    datalad create-sibling-gin -d . -s origin --access-protocol ssh --private  cpp_brewery/"${GIN_BASENAME}"-derivatives-wb_command-ROIs
    cd "${derivatives_dir}"
    datalad subdatasets --set-property url git@gin.g-node.org:/cpp_brewery/"${GIN_BASENAME}"-derivatives-wb_command-ROIs wb_command-ROIs
fi

cd "${derivatives_dir}"

datalad create -d . "${stats_dir}"

if [ ! -z "${GIN_BASENAME}" ]; then
    cd "${stats_dir}"
    datalad create-sibling-gin -d . -s origin --access-protocol ssh --private  cpp_brewery/"${GIN_BASENAME}"-derivatives-PALM-stats
    cd "${derivatives_dir}"
    datalad subdatasets --set-property url git@gin.g-node.org:/cpp_brewery/"${GIN_BASENAME}"-derivatives-PALM-stats.git PALM-stats

fi


cd "${derivatives_dir}"

datalad push --to origin -r

cd "${root_dir}"

datalad save -m "add code and folders to set subdatasets"

datalad push --to origin

echo "############################"
echo "# DATALAD IS READY TO WORK #"
echo "############################"
