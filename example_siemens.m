clear

%% save all input dicoms in cell structure

data_dir = 'data\DCM';

d = dir(data_dir);
dcm_dir = setdiff({d([d.isdir]).name},{'.','..'}); % list rotations

for i = 1:length(dcm_dir)
    dcm_dir_cell{i} = [data_dir filesep dcm_dir{i}];
end 

%% convert dicoms to nifti and save in structure s

out_nii_dir = 'data\NII';
mkdir(out_nii_dir);

nii_fn_cell = srr_dicm2nii(dcm_dir_cell, out_nii_dir);

bdelta = 1; %btensor shape
for i = 1:numel(nii_fn_cell)
    s{i} = mdm_s_from_nii(nii_fn_cell{i}, bdelta);
end

%% reconstruct 

out_srr_dir = 'data\SRR';
mkdir(out_srr_dir);

opt_srr.lambda = 0.05; %regularization 
out_srr_fn = sprintf('srr_la%.5g.nii.gz', opt_srr.lambda);

s_out = srr_s_recon(s, out_srr_dir, out_srr_fn, opt_srr);
