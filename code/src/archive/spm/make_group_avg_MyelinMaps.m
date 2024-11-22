% This scripts takes volumetric MyelinMaps (T1w/T2w) outputed by
% hcppipelines PostSurfer pipeline and averages them across groups (blind &
% sighted) for qualitative overview of myelin distribution.


% try with cifti-matlab toolbox!
% https://github.com/Washington-University/cifti-matlab

clc
clear

addpath('/Users/jacekmatuszewski/Documents/GitHub/cifti-matlab');

this_dir = '/Volumes/Slim_Reaper/Projects/analyses_T1w_T2w_Blind_Sighted/code/src/spm';
opt.dir.root = fullfile(this_dir, '..', '..', '..');

opt.dir.deriv = fullfile(opt.dir.root, 'outputs', 'derivatives');
opt.dir.hcp = fullfile(opt.dir.deriv, 'hcppipelines');
opt.dir.spm = fullfile(opt.dir.deriv, 'spm-stats');

opt.dir.output = fullfile(opt.dir.hcp,'derivatives','group_maps'); 

opt.group = {'blind','sighted'};

opt.subNum = {'01', '02','03','04','05',...
   '06','07','08','09','10','11','12',...
   '13','14','15','16','17','18','19','20'}; 

%smoothed CIFTI MAP
smMyelinMapFName = 'SmoothedMyelinMap_BC.164k_fs_LR.dscalar.nii';
MyelinMapFName = 'MyelinMap_BC.164k_fs_LR.dscalar.nii';

%Number of vertices in your CIFTI file (prealocation only)
% 164k, both hemispheres
NVertices = 298261;

for iGr = 1:numel(opt.group)
    
    %prepare subject names
    opt.subjects = {};
    opt.subjects = [opt.subjects, strcat(opt.group{iGr}, opt.subNum)];
    
    
    %get MyelinMap files
    %maps = cellstr(spm_select('FPListRec', opt.dir.hcp, ['sub-',opt.group{iGr},'a*','.',MyelinMapFName]));
    sm_maps = cellstr(spm_select('FPListRec', opt.dir.hcp, ['sub-',opt.group{iGr},'.*','.',smMyelinMapFName]));
    
    %pre-alocate
    group_cifti_temp = zeros(NVertices,numel(sm_maps));

    for iSub = 1:numel(opt.subjects)

        %Load subject cifti file
        sub_cifti_temp = cifti_read(sm_maps{iSub});

        %Add cifti data to the group array
        group_cifti_temp(:,iSub) = sub_cifti_temp.cdata;

    end

    %Compute average in each ROW (vertex)
    group_cifti_avg = mean(group_cifti_temp,2);
    
    %this just copies the struct from a subject-level cifti, probably
    %bad...
    group_cifti_to_write = sub_cifti_temp;
    group_cifti_to_write.cdata = group_cifti_avg;
    
    %Save the group average as new cifti 
    fname = [opt.group{iGr},'_MATLAB_AVG_','SmoothedMyelinMap_BC_164k_fs_LR.dscalar.nii'];
    cifti_write(group_cifti_to_write, fname);
    
    %Move the file to deriv/group_maps?
    movefile(fname, fullfile(opt.dir.output, fname), 'f');
    
end


%Most basic cifti reading and writing example
%mycifti = cifti_read(fullfile(opt.dir.hcp,'/sub-blind01/MNINonLinear/sub-blind01.SmoothedMyelinMap_BC.164k_fs_LR.dscalar.nii'));
%mycifti = cifti_read('something.dscalar.nii');
%mycifti.cdata = sqrt(mycifti.cdata);
%cifti_write(mycifti, 'sqrt.dscalar.nii');

%% Try to compute raw difference (subtractions)

blind_avg = cifti_read(fullfile(opt.dir.output, 'blind_MATLAB_AVG_SmoothedMyelinMap_BC_164k_fs_LR.dscalar.nii'));
sig_avg = cifti_read(fullfile(opt.dir.output, 'sighted_MATLAB_AVG_SmoothedMyelinMap_BC_164k_fs_LR.dscalar.nii'));

bl_gt_sig = blind_avg; 
sig_gt_bl = sig_avg; 

bl_gt_sig.cdata = (blind_avg.cdata-sig_avg.cdata);
sig_gt_bl.cdata = (sig_avg.cdata-blind_avg.cdata);

cifti_write(bl_gt_sig, 'yolo_bl_gt_sig.dscalar.nii');
cifti_write(sig_gt_bl, 'yolo_sig_gt_bl.dscalar.nii');