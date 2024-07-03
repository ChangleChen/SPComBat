function prec_apply_deform(input_fn,ref_img,y_fn)
for i = 1:numel(input_fn)
    [filepath,name,ext] = fileparts(input_fn{i});
    mask_icv = ['mask_icv_',name,ext];
    mask_bg = ['mask_bg_',name,ext];

    matlabbatch = {};
    matlabbatch{1}.spm.util.defs.comp{1}.def = {y_fn{i}};
    matlabbatch{1}.spm.util.defs.comp{2}.id.space = {ref_img{i}};
    matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {input_fn{i}};
    matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.saveusr = {filepath};
    matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 4;
    matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
    matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
    matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'mni_';
    spm_jobman('run',matlabbatch);

    % for masks
    matlabbatch = {};
    fn_vec = {};
    fn_vec{1,1} = fullfile(filepath,mask_icv);
    fn_vec{2,1} = fullfile(filepath,mask_bg);
    matlabbatch{1}.spm.util.defs.comp{1}.def = {y_fn{i}};
    matlabbatch{1}.spm.util.defs.comp{2}.id.space = {ref_img{i}};
    matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = fn_vec;
    matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.saveusr = {filepath};
    matlabbatch{1}.spm.util.defs.out{1}.pull.interp = 0;
    matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 1;
    matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];
    matlabbatch{1}.spm.util.defs.out{1}.pull.prefix = 'mni_';
    spm_jobman('run',matlabbatch);

end







