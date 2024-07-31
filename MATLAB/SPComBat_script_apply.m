%% Apply the estimated parametric maps to perform linear site/scanner effect removal 
%% Average parametric maps to represent the site effects
% this section is assumed all individual parametric maps were stored in the
% same folder and labeled with site indicators. Modify the code to fit to
% your directory.

% NOTE!!: parametric maps should be estimated by a group of traveling
% subjects or pseudo-matched subjects so that the maps would be smooth.
% If the parametric maps are not smooth, it could introduce high-frequency
% noise during the harmonization (that means if you just have few traveling 
% subjects for harmonization, that may encounter some issues. You can apply 
% additional spatial smoothing (like [3 3 3] smooth kernel) to the 
% parametric maps to mitigate this problem.

% here suppose that images from different scanners were labeled with site
% indicators in their filename

mp = '/path/to/the/demo_data';
site_indicator = {'_philips_','_ge_','_prisma_','_trio_'};
% gamma and delta maps are site-specific
for i=1:numel(site_indicator)
    % gamma maps
    fn_para = dir(fullfile(mp,['gs*',site_indicator{i},'*.nii'])); fn_para = {fn_para.name}; fn_para = fullfile(mp,fn_para);
    sp_para_gs_avg(fn_para,site_indicator{i});
    % delta maps
    fn_para = dir(fullfile(mp,['ds*',site_indicator{i},'*.nii'])); fn_para = {fn_para.name}; fn_para = fullfile(mp,fn_para);
    sp_para_ds_avg(fn_para,site_indicator{i});
end
% input: filenames of individual parametric maps (full filename containing directory) (cell array)
% output: avg_gs_*_.nii & avg_ds_*.nii


% average the maps used for standardization (sm* and vp*)
% grand mean maps: subject-specific
fn_para = dir(fullfile(mp,'sm*.nii')); fn_para = {fn_para.name}; fn_para = fullfile(mp,fn_para);
sp_para_sm_avg(fn_para);
% grand variance maps: subject-specific
fn_para = dir(fullfile(mp,'vp*.nii')); fn_para = {fn_para.name}; fn_para = fullfile(mp,fn_para);
sp_para_vp_avg(fn_para);
% input: filenames of individual parametric maps (full filename containing directory) (cell array)
% output: avg_sm_map.nii & avg_vp_map.nii




%% Project average parametric maps and maps used for standardization to the native space
% the background masks are transformed as well
% suppose all images were stored in the same directory
mp = '/path/to/the/demo_data';

fn_img = dir(fullfile(mp,'mrs_*.nii')); fn_img = {fn_img.name}; % the native images
% specify site indicators
site_indicator = {'_philips_','_ge_','_prisma_','_trio_'};


for i = 1:numel(fn_img) % this process is specific to each brain scan
    % input arg: 
    % 1. parametric maps in MNI (gamma, delta, grand mean, and grand variance)
    % 2. masks in MNI
    % 3. the preprocessed images in native (mrs*.nii)
    % 4. forward deformation maps (native -> MNI)
    % 5. output directory

    % NOTE! the parametric maps (gamma and delta) should match to the brain scans that were from the same site during each loop

    % find the site
    indv_img = fn_img{i};
    inx = find(contains(indv_img,site_indicator)==1);
    fn_mni_para = {};
    fn_mni_para{1,1} = 'avg_sm_map.nii';
    fn_mni_para{2,1} = 'avg_vp_map.nii';
    fn_mni_para{3,1} = ['avg_gs',site_indicator{inx},'map.nii'];
    fn_mni_para{4,1} = ['avg_ds',site_indicator{inx},'map.nii'];

    fn_mni_mask = ['mask_bg_',indv_img]; % here we use the whole head images (including skull)
    fn_y_def = ['y_',indv_img(2:end)]; % the forward deformation maps (native to MNI), the code will estimate the inverse one based on this

    % convert relative filename to absolute filename
    fn_mni_para = fullfile(mp,fn_mni_para);
    fn_mni_mask = fullfile(mp,fn_mni_mask);
    fn_nat_img = fullfile(mp,indv_img);
    fn_y_def = fullfile(mp,fn_y_def);

    % convert string to cell array
    fn_mni_mask = {fn_mni_mask};
    fn_nat_img = {fn_nat_img};
    fn_y_def = {fn_y_def};
    saving_dir = {mp}; % the output directory

    sp_min2nat_apply(fn_mni_para,fn_mni_mask,fn_nat_img,fn_y_def,saving_dir); % input should be cell array for each arg
    fprintf('sub: %g done\n',i);
end
delete(fullfile(saving_dir{1},'y_i_inverse_mapping.nii')); % remove inverse deformation to save storage

% output: filename with prefix "nat_*"

%% Perform one-padding for background: specific to delta maps and grand variance maps: ds & vp
mp = '/path/to/the/demo_data';
fn_vp = dir(fullfile(mp,'nat_*avg_vp*.nii')); fn_vp = {fn_vp.name};
fn_ds = dir(fullfile(mp,'nat_*avg_ds*.nii')); fn_ds = {fn_ds.name};
if numel(fn_vp) == numel(fn_ds)
    for i=1:numel(fn_vp)
        sp_one_padding(fullfile(mp,fn_vp{i}));
    end
    for i=1:numel(fn_ds)
        sp_one_padding(fullfile(mp,fn_ds{i}));
    end
else
    disp('File mismatch: ds* and vp*');
end
% input: delta maps and variance maps
% output: maps with one-padding background


%% Perform site effect removal for harmonization
% suppose all files were stored in the same directory
mp = '/path/to/the/demo_data';

fn_img = dir(fullfile(mp,'mrs*.nii')); fn_img = {fn_img.name};
for i = 1:numel(fn_img)
    fn_preimg = fn_img{i}; % preprocessed images
    sub_handle = strrep(fn_preimg,'.nii','');

    % rescaling
    sp_rescale(fullfile(mp,fn_preimg)); % the output will have prefix "f"

    fn_preimg = ['f',fn_preimg];
    fn_sm = dir(fullfile(mp,['nat_*',sub_handle,'*avg_sm*.nii'])); fn_sm = {fn_sm.name}; fn_sm = fn_sm{1};
    fn_vp = dir(fullfile(mp,['nat_*',sub_handle,'*avg_vp*.nii'])); fn_vp = {fn_vp.name}; fn_vp = fn_vp{1};
    fn_gs = dir(fullfile(mp,['nat_*',sub_handle,'*avg_gs*.nii'])); fn_gs = {fn_gs.name}; fn_gs = fn_gs{1};
    fn_ds = dir(fullfile(mp,['nat_*',sub_handle,'*avg_ds*.nii'])); fn_ds = {fn_ds.name}; fn_ds = fn_ds{1};

    fn_mask = dir(fullfile(mp,['nat_*',sub_handle,'*mask_bg*.nii'])); fn_mask = {fn_mask.name}; fn_mask = fn_mask{1};

    % site effect removal
    sp_site_effect_removal(fullfile(mp,fn_preimg),...
        fullfile(mp,fn_sm),...
        fullfile(mp,fn_vp),...
        fullfile(mp,fn_gs),...
        fullfile(mp,fn_ds),...
        fullfile(mp,fn_mask));
    fprintf('sub: %g done\n',i);
end

% input: preprocessed images, parametric maps in the native, and mask in the native
% output: harmonized images in the native (har_*)
