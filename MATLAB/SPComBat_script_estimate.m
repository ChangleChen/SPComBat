%% SP-ComBat
% implement ComBat harmonization at the image level with 3D superpixel parcellation 
% requirement: MATLAB R2016b and above

% original environment for the implementation:
% MATLAB R2022a, SPM (v7771), and CAT12 (v12.8.2)
pkg_dir = '/path/to/the/pkg_spcombat';
addpath(pkg_dir);


%% Preprocessing for ComBat estimation: Step 1: Preprocessing for spatial and signal consistency
mp = '/path/to/the/demo_data';
fn = dir(fullfile(mp,'*.nii')); fn = {fn.name}';
for i=1:numel(fn)
    fn{i} = fullfile(mp,fn{i});
end
prec_ssc(fn,fn{end}); 
% input: filename of preprocessed cross-scanner images (cell array) 
% input: filename of a reference image (string)


%% Preprocessing for ComBat estimation: Step 2: Initial preprocessing & Generate basic deformation field to MNI
pkg_dir = '/path/to/the/pkg_spcombat';
addpath(pkg_dir);

mp = '/path/to/the/demo_data';
fn = dir(fullfile(mp,'rs_*.nii')); fn = {fn.name}';
for i=1:numel(fn)
    fn{i} = fullfile(mp,fn{i});
end
cat12("expert"); close all force;
pause(2);
prec_cat(fn,pkg_dir); % input: filename of cross-scanner images & package directory (cell array)
close all;


%% Preprocessing for ComBat estimation: Step 3: Create intracranial mask and background (rough) mask

mp = '/path/to/the/demo_data';
fn = dir(fullfile(mp,'mrs_*.nii')); fn = {fn.name}';
for i=1:numel(fn)
    fn{i} = fullfile(mp,'mri',[fn{i}]);
end
prec_mask(fn); % input: filename of preprocessed cross-scanner images from the above (cell array)

%% Preprocessing for ComBat estimation: Step 3.5: Perform study- or subject-specific registration (Optional)

%% Preprocessing for ComBat estimation: Step 4: Apply deformation field to preprocessed image and masks (project to MNI)
% the target files include mrs_*.nii, mask_icv_*.nii, and mask_bg_*.nii

mp = '/path/to/the/demo_data';
fn = dir(fullfile(mp,'mri','mrs_*.nii')); fn = {fn.name}';
nat_img = {};
ref_img = {};
y_fn = {};
for i=1:numel(fn)
    nat_img{i} = fullfile(mp,'mri',fn{i});
    ref_img{i} = fullfile(mp,'mri',strrep(fn{i},'mrs_','rmrs_'));
    y_fn{i} = fullfile(mp,'mri',strrep(fn{i},'mrs_','y_rs_'));
end
prec_apply_deform(nat_img,ref_img,y_fn); 
% input: filename of preprocessed cross-scanner images from the above (cell array)
% input: filename of reference images in MNI from CAT12 segmentation (just example) (cell array)
% input: filename of deformation field in MNI from CAT12 segmentation (just example) (cell array)

%% Preprocessing for ComBat estimation: Step 5: Average and rescale the images in the MNI for 3D superpixel parcellation

mp = '/path/to/the/demo_data';
fn = dir(fullfile(mp,'mri','mni_mrs_*.nii')); fn = {fn.name}';
for i=1:numel(fn)
    fn{i} = fullfile(mp,'mri',fn{i});
end
prec_avg_rsl(fn);
% input: filename of preprocessed cross-scanner images from the above

%% Perform SP-ComBat procedure to estimate parametric maps on an individual basis

mp = '/path/to/the/demo_data';
fn = dir(fullfile(mp,'mri','fmni_mrs_*.nii')); fn = {fn.name}';
for i=1:numel(fn)
    fn{i} = fullfile(mp,'mri',fn{i});
end
fn_avg = dir(fullfile(mp,'mri','avg_mni_mrs_*.nii')); fn_avg = {fn_avg.name}';
fn_avg = fullfile(mp,'mri',fn_avg{1});


sp_combat_est(fn,fn_avg,pkg_dir) % the first input arg is a cell array while the second is a string
% input: filename of preprocessed final cross-scanner images in MNI (cell array)
% input: filename of average image (string)













































