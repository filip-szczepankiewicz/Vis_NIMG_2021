clear

%% create shepp logan phantom data

out_nii_dir = 'data\shepplogan';
mkdir(out_nii_dir);

out_nii_fn = 'shepplogan_ph'; 

opt.psize = 108; %phantom size
opt.aspect = 3; %aspect factor
opt.n_ims = 5; %nr low-res rotations
opt.noisestd = 0.05; 

s = srr_ph_create_s(out_nii_dir, out_nii_fn, opt);


%% reconstruct 

out_srr_dir = 'data\shepplogan\SRR';
mkdir(out_srr_dir);

opt_srr.lambda = 0.05; %regularization 
out_srr_fn = sprintf('srr_la%.5g.nii.gz', opt_srr.lambda);

s_out = srr_s_recon(s, out_srr_dir, out_srr_fn, opt_srr);


