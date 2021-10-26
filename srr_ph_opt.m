function opt = srr_ph_opt(opt)
% function opt = srr_phantom_opt(opt)
%
% Specifies default options for phantom creation

if (nargin < 1); opt.present = 1; end % not sure what this does

opt = msf_ensure_field(opt, 'psize', 108); % 2d phantom size in voxels
opt = msf_ensure_field(opt, 'aspect', 3); % aspect ratio
opt = msf_ensure_field(opt, 'n_ims', 5); % nr of low-res rotations
opt = msf_ensure_field(opt, 'signal', [0.5 1.0 2.0 0.8 1.8 0.8 1.1 0.7 1.2 2.0]);
opt = msf_ensure_field(opt, 'noisestd', 0); % noise std
opt = msf_ensure_field(opt, 'save_hrref', 1); % save the original HR phantom
opt = msf_ensure_field(opt, 'h2l_fn', 0); % 
opt = msf_ensure_field(opt, 'h2l_path', pwd); 
opt = msf_ensure_field(opt, 'h2l_folder', 'ph_saved_h2l'); 
opt = msf_ensure_field(opt, 'use_existing_h2l', 1); % set to 0 to force new creation of h2l
