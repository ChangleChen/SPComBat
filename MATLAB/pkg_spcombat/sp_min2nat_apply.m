function sp_min2nat_apply(fn_mni_para,fn_mni_mask,fn_nat_img,fn_y_def,saving_dir)
% this is subject-specific process
[~,fn] = fileparts(fn_nat_img);
matlabbatch = {};
matlabbatch{1}.spm.util.defs.comp{1}.inv.comp{1}.def = fn_y_def;
matlabbatch{1}.spm.util.defs.comp{1}.inv.space = fn_nat_img;
matlabbatch{1}.spm.util.defs.out{1}.savedef.ofname = 'i_inverse_mapping';
matlabbatch{1}.spm.util.defs.out{1}.savedef.savedir.saveusr = saving_dir;
matlabbatch{1}.spm.util.defs.out{2}.pull.fnames = fn_mni_para;
matlabbatch{1}.spm.util.defs.out{2}.pull.savedir.savepwd = 1;
matlabbatch{1}.spm.util.defs.out{2}.pull.interp = 4;
matlabbatch{1}.spm.util.defs.out{2}.pull.mask = 1;
matlabbatch{1}.spm.util.defs.out{2}.pull.fwhm = [0 0 0];
matlabbatch{1}.spm.util.defs.out{2}.pull.prefix = ['nat_',fn,'_'];
matlabbatch{1}.spm.util.defs.out{3}.pull.fnames = fn_mni_mask;
matlabbatch{1}.spm.util.defs.out{3}.pull.savedir.savepwd = 1;
matlabbatch{1}.spm.util.defs.out{3}.pull.interp = 0;
matlabbatch{1}.spm.util.defs.out{3}.pull.mask = 1;
matlabbatch{1}.spm.util.defs.out{3}.pull.fwhm = [0 0 0];
matlabbatch{1}.spm.util.defs.out{3}.pull.prefix = ['nat_',fn,'_'];
spm_jobman('run',matlabbatch);
end