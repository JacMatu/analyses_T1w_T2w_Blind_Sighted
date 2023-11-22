#Just some stuff to copy files
cd /mnt/DATA/jacmatu/Projects/Myelin_Blind_Sighted/T1w_T2w_HCPPipelines/outputs/derivatives/hcppipelines/
outputs=${PWD}

cd /mnt/DATA/jacmatu/Datalad/analyses_T1w_T2w_HCPPipelines-derivatives/hcppipelines
cp -r $outputs/sub-blind01 . 

#Remember to change the owner of docker-made dirs before pushing it with git-annex/datalad! 
# -hR makes it recursive for all subfiles! 
sudo chown -hR jacmatu ./sub-blind01


### GIN x DATALAD x MONSTER x DOCKER 
# DATALAD text2git works well with BIDS stuff, but not with docker stuff! 
# datalad has to be set up a bit differently here! 
# do not use -c text2git configuration during datalad create
# create the outputs of hcppipelines
# CAUTION! If not working with bids, do not use -c text2git! 
#datalad create --force -d .  "${hcppipelines_dir}" 


#datalad push --to origin -f all #forces push even if remote and local histories are different
# when running datalad save or push you can use the -J aregument followed by a number to decide how many parallel "jobs" should be running at house


## WORKING WITH SUBMODULES/SUBDATASETS
# after changes to child repo push there
# then, go to parent repo, save the child and push to parent
# then, go to another parent and save that sub-child AGAIN
#   BECAUSE REPOS TRACK SPECIFIC VERIONS (COMMITS) OF SUBMODULES/SUBDATASETS! 
#   AND YOU HAVE TO UPDATE THESE VERSIONS IN THE PARENT REPOS EVERY TIME YOU MAKE A BIG CHANGE!