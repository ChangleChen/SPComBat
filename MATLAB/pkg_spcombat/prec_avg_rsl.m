function prec_avg_rsl(input_fn)
for i=1:numel(input_fn)
    [filepath,name,ext] = fileparts(input_fn{i});
    hdr = spm_vol(fullfile(filepath,[strrep(name,'mni_mrs_','mni_mask_bg_mrs_'),ext])); % header
    img_mask = spm_read_vols(hdr); % image
    hdr = spm_vol(input_fn{i}); % header
    img = spm_read_vols(hdr); % image
    img = img.*img_mask;
    vec = reshape(img,numel(img),1);
    img = 1000*((img-prctile(vec,0.1))/(prctile(vec,99)-prctile(vec,0.01))); img(img>=1000) = 1000; img(img<=0) = 0;
    hdr.fname = fullfile(filepath,['f',name,ext]);
    hdr.dt = [16,0];
    spm_write_vol(hdr,img);
end
dim = [size(img),numel(input_fn)];
avg_4d = zeros(dim);
for i=1:numel(input_fn)
    hdr = spm_vol(strrep(input_fn{i},'mni_mrs_','fmni_mrs_')); % header
    avg_4d(:,:,:,i) = spm_read_vols(hdr); % image
end
avg_3d = mean(avg_4d,4);
[filepath,name,ext] = fileparts(input_fn{end});
hdr.fname = fullfile(filepath,['avg_',name,ext]);
hdr.dt = [16,0];
spm_write_vol(hdr,avg_3d);