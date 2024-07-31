function sp_para_sm_avg(fn_para)
img4d = [];
for j=1:numel(fn_para)
    hdr = spm_vol(fn_para{j}); % header
    img4d(:,:,:,j) = spm_read_vols(hdr); % image
end
img4d = squeeze(mean(img4d,4,'omitnan'));
img4d(isnan(img4d)) = 0; % grand mean map
mp = fileparts(fn_para{j});
hdr.fname = fullfile(mp,'avg_sm_map.nii');
hdr.dt = [16,0];
spm_write_vol(hdr,img4d);
end