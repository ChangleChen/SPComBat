function sp_one_padding(fn_img)
hdr = spm_vol(fn_img); % header
img = spm_read_vols(hdr); % image
img(img<=0.00001) = 1;
img(isnan(img)) = 1;
spm_write_vol(hdr,img);
end