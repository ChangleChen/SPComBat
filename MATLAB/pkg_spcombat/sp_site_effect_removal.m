function sp_site_effect_removal(fn_img,fn_sm,fn_vp,fn_gs,fn_ds,fn_mask)
[filepath,name,ext] = fileparts(fn_img);

% load the preprocessed image
hdr = spm_vol(fn_img);
img_pre = spm_read_vols(hdr);

% load parametric maps
hdr1 = spm_vol(fn_sm);
img_sm = spm_read_vols(hdr1);
hdr1 = spm_vol(fn_vp);
img_vp = spm_read_vols(hdr1);

hdr1 = spm_vol(fn_gs);
img_gs = spm_read_vols(hdr1);
hdr1 = spm_vol(fn_ds);
img_ds = spm_read_vols(hdr1);

% load the head mask
hdr1 = spm_vol(fn_mask);
img_mask = spm_read_vols(hdr1);


h_dat = (img_pre - img_sm)./sqrt(img_vp); h_dat(isinf(h_dat)|isnan(h_dat)) = 0;
h_dat = (h_dat - img_gs)./sqrt(img_ds); h_dat(isinf(h_dat)|isnan(h_dat)) = 0;
h_dat = h_dat.*sqrt(img_vp) + img_sm; h_dat(isinf(h_dat)|isnan(h_dat)) = 0;
h_dat = h_dat.*img_mask;
% remove extreme values along boundaries
vec = reshape(h_dat,numel(h_dat),1);
h_dat = 1000*((h_dat-prctile(vec,1))/(prctile(vec,99)-prctile(vec,1))); h_dat(h_dat>=1000) = 1000; h_dat(h_dat<=0) = 0;
hdr.fname = fullfile(filepath,['har_',name,ext]);
spm_write_vol(hdr,h_dat);
end