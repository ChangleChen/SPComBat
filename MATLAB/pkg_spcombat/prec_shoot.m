function prec_shoot(fn_rp1,fn_rp2,fn_rm)
matlabbatch = {};
matlabbatch{1}.spm.tools.shoot.warp.images = {fn_rp1;fn_rp2}';

matlabbatch{2}.spm.tools.shoot.norm.template(1) = cfg_dep('Run Shooting (create Templates): Template (4)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','template', '()',{5}));
matlabbatch{2}.spm.tools.shoot.norm.data.subjs.deformations(1) = cfg_dep('Run Shooting (create Templates): Deformation Fields', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','def', '()',{':'}));
matlabbatch{2}.spm.tools.shoot.norm.data.subjs.images = {fn_rm}';
matlabbatch{2}.spm.tools.shoot.norm.vox = [NaN NaN NaN];
matlabbatch{2}.spm.tools.shoot.norm.bb = [NaN NaN NaN
                                          NaN NaN NaN];
matlabbatch{2}.spm.tools.shoot.norm.preserve = 0;
matlabbatch{2}.spm.tools.shoot.norm.fwhm = 0;
spm_jobman('run',matlabbatch);