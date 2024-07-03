function prec_mask(input_fn)
for i=1:numel(input_fn)
    [filepath,name,ext] = fileparts(input_fn{i});
    p0_label = fullfile(filepath,['p0',name(2:end),ext]);

    hdr = spm_vol(p0_label); % header
    img = spm_read_vols(hdr); % image
    img = imgaussfilt3(img);
    img(img>0.1) = 1; img(img~=1) = 0;
    
    hdr.dt = [8,0];
    hdr.fname = fullfile(filepath,['mask_icv_',name,ext]);
    spm_write_vol(hdr,img);

    se = strel('sphere',14);
    img_dila = imdilate(img,se);
    hdr.fname = fullfile(filepath,['mask_bg_',name,ext]);
    spm_write_vol(hdr,img_dila);
end