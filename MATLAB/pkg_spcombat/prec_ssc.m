function prec_ssc(input_fn,ref_fn)
for i = 1:numel(input_fn)
    matlabbatch{1}.spm.spatial.coreg.write.ref = {ref_fn};
    matlabbatch{1}.spm.spatial.coreg.write.source = {input_fn{i}};
    matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
    matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'rs_';

    spm_jobman('run',matlabbatch);

    [filepath,name,ext] = fileparts(input_fn{i});
    hdr = spm_vol(fullfile(filepath,['rs_',name,ext])); % header
    img = spm_read_vols(hdr); % image
    vec = reshape(img,numel(img),1);
    img = 1000*((img-prctile(vec,0.1))/(prctile(vec,99)-prctile(vec,0.01))); img(img>=1000) = 1000; img(img<=0) = 0;
    hdr.dt = [16,0];
    spm_write_vol(hdr,img);
end