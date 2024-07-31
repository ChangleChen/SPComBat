function sp_rescale(fn_img)
[filepath,name,ext] = fileparts(fn_img);
hdr = spm_vol(fn_img); % header
img = spm_read_vols(hdr); % image
vec = reshape(img,numel(img),1);
img = 1000*((img-prctile(vec,0.1))/(prctile(vec,99)-prctile(vec,0.1))); img(img>=1000) = 1000; img(img<=0) = 0;
hdr.fname = fullfile(filepath,['f',name,ext]);
hdr.dt = [16,0];
spm_write_vol(hdr,img);
end