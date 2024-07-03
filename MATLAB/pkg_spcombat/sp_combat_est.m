function sp_combat_est(input_fn,avg_fn,pkg_dir)

threshold = 10; % threshold based on intensity histgram (specify other values if necessary in your case)
seed = 60000; % initial number of seeds used in superpixel parcellation (specify other values if necessary in your case)


% by defauly, the mask is 121*145*121 in the MNI space, if the dimension
% does not match to your images in the MNI, please resize this mask.
% note: when resizing, please use the nearest neighbor interpolation
mask_mni = fullfile(pkg_dir,'mask_WholeBrain.nii'); 
hdr = spm_vol(mask_mni);
mask_mni = spm_read_vols(hdr);

%%%%%%%%%%%%%%%%%%%%%% superpixel parcellation based on avg image
hdr = spm_vol(avg_fn); % header
img = spm_read_vols(hdr); % image
[L,~] = superpixels3(img, seed); % built-in SLIC version: require MATLAB image processing toolbox
mask = img;
mask(mask>=threshold) = threshold; % intensity based on histgram
mask(mask~=threshold) = 0; mask = mask/threshold;
L = mask.*L.*mask_mni;  % apply additional MNI mask to ensure spatial continuity
L = sp_merge(L,img); % merge small superpixels less than 3*3*3 voxels
el = unique(L);
n_region = numel(unique(L));


%%%%%%%%%%%%%%%%%%%%%% combat estimation: individual level
img4d = {};
for n_scan = 1:numel(input_fn)
    hdr = spm_vol(input_fn{n_scan}); % header
    img4d{1,n_scan} = spm_read_vols(hdr); % image
end

map_sm = zeros(size(img4d{1}));
map_vp = map_sm + 1;
map_gs = {}; map_ds = {};
for nc1 = 1:numel(img4d)
    map_gs{nc1} = map_sm;
    map_ds{nc1} = map_vp;
end


for itr = 1:n_region
    inx = find(L == el(itr));
    if numel(inx) < 50^3 % empirical size given the matrix size 121-145-121
        dat = []; batch = [];
        for itr2 = 1:numel(input_fn)
            d1 = img4d{itr2}; d1 = sp_uni_row(d1(inx));
            if length(d1)<60
                temp_d1 = [];
                while length(temp_d1)<60
                    temp_d1 = [temp_d1,d1];
                end
                d1 = temp_d1;
            end
            dat = [dat,d1];
            batch = [batch,ones(1,numel(d1))*itr2];
        end
        dat = repmat(dat,10,1); % prevent unsolved situation given the closed form solution
        [~,s_hat] = sp_combat(dat, batch, [], 0, 0);
        stand_mean = s_hat.stand_mean;
        var_pooled = s_hat.var_pooled;
        gamma_star = s_hat.gamma_star;
        delta_star = s_hat.delta_star;
        map_sm(inx) = stand_mean(1,1);
        map_vp(inx) = var_pooled(1);

        for itr2 = 1:numel(input_fn)
            temp1 = map_gs{itr2};
            temp1(inx) = gamma_star(itr2,1);

            map_gs{itr2} = temp1;

            temp1 = map_ds{itr2};
            temp1(inx) = delta_star(itr2,1);
            map_ds{itr2} = temp1;
        end

        if mod(itr,500)==0
            fprintf('   Itr: %g\n',itr);
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%% save parametric maps
for n_scan = 1:numel(input_fn)
    temp_gs = map_gs{n_scan};
    temp_gs = sp_para_constrain_gs(temp_gs);
    map_gs{n_scan} = fillmissing(temp_gs,'nearest');

    temp_ds = map_ds{n_scan};
    temp_ds = sp_para_constrain_ds(temp_ds);
    map_ds{n_scan} = fillmissing(temp_ds,'nearest');

    map_vp = sp_para_constrain_ds(map_vp);
    map_vp = fillmissing(map_vp,'nearest');
end

for n_scan = 1:numel(input_fn)
    hdr = spm_vol(input_fn{n_scan}); % header
    hdr.dt = [16,0];
    [filepath,name,ext] = fileparts(input_fn{n_scan});
    hdr.fname = fullfile(filepath,['gs_',name,ext]);
    spm_write_vol(hdr,map_gs{n_scan});
    hdr.fname = fullfile(filepath,['ds_',name,ext]);
    spm_write_vol(hdr,map_ds{n_scan});
end
[filepath,name,ext] = fileparts(avg_fn);
hdr.fname = fullfile(filepath,['sm_',name,ext]);
spm_write_vol(hdr,map_sm);
hdr.fname = fullfile(filepath,['vp_',name,ext]);
spm_write_vol(hdr,map_vp);


