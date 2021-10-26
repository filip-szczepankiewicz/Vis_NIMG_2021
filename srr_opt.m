function opt = srr_opt(opt)
% function opt = srr_opt(opt)
%
% Specifies default options

if (nargin < 1), opt.present = 1; end 

opt = msf_ensure_field(opt, 'lambda', 0.05); % set regularization parameter
opt = msf_ensure_field(opt, 'savelonh', 0); % save all lr images on hr grid
opt = msf_ensure_field(opt, 'nii_fn_out', 'srr_out.nii'); % output nii name
opt = msf_ensure_field(opt, 'meas_ind', -1);
opt = msf_ensure_field(opt, 'slice_ind', -1);
opt = msf_ensure_field(opt, 'h2l_fn', '');
opt = msf_ensure_field(opt, 'use_existing_h2l', 1); % set to 0 to force new creation of h2l


% can put any option here
% ...
