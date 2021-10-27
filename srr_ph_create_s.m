function s = srr_ph_create_s(out_dir, out_fn, opt)
% function s = srr_ph_create_s(out_dir, out_fn, opt)
% get s structure for a numerical shepp-logan phantom

if (nargin < 3); opt.present = 1; end
opt = srr_ph_opt(opt);

aspect = opt.aspect;
n_ims = opt.n_ims;
psize = opt.psize;
noisestd = opt.noisestd;
signal = opt.signal;

% create lr headers/hr headers
nii_h_cell = srr_ph_get_nii_header(aspect, n_ims, psize);

% get h2l operator 
h2l_fn = srr_h2l_fn_from_ph_opt(opt);
if exist(h2l_fn, 'file')  && opt.use_existing_h2l == 1
    h2lstruct = load(h2l_fn);
    h2l = h2lstruct.h2l;
elseif opt.h2l_fn ~= 0
    h2lstruct = load(opt.h2l_fn);
    h2l = h2lstruct.h2l;
else %create if doesnt exists
    h2l = [];
    for n = 1:n_ims
        
        nii_fn = fullfile(out_dir, [out_fn sprintf('_rot%d.nii.gz', n)]);
        h_hr = srr_hr_header_from_lr(nii_h_cell{1});
        
        fprintf('Creating h2l operator for image %d out of %d... ', n, n_ims);
        h2l_s = srr_h2l_from_header(nii_h_cell{n}, h_hr, opt);
        disp('Done!')
        
        save(srr_h2l_fn_from_nii_fn(nii_fn), 'h2l_s');
        h2l = cat(1, h2l, h2l_s);
    end 
    save(h2l_fn, 'h2l', 'opt');
end 

% get hr object
[~, e] = srr_ph_create(psize);
e(:,1) = signal;
hr_ph = srr_ph_create(psize,e);

if opt.save_hrref == 1
    hr_ph_nii(:,1,:,1) = hr_ph;
    mdm_nii_write(hr_ph_nii, fullfile(out_dir, 'hr_ref.nii.gz'));
end


% create lr niftis
for n = 1:n_ims
    
    h = nii_h_cell{n};
    
    sz = size(h2l, 1) / n_ims;
    h2l_s = h2l(((n-1)*sz + 1 : n*sz), :);
    
    % create lr phantom   
    lr_noise = h2l_s * hr_ph(:) + noisestd*randn(prod([h.dim(2) h.dim(4)]),1) + 1i*noisestd*randn(prod([h.dim(2) h.dim(4)]),1);
        
    lr_ph = zeros(h.dim(2), 1, h.dim(4),1);
    lr_ph(:,1,:,1) = abs(reshape(lr_noise, [h.dim(2) h.dim(4)]));
    
    % save lr nii and empty xps
    nii_fn = fullfile(out_dir, [out_fn sprintf('_rot%d.nii.gz', n)]);
    mdm_nii_write(lr_ph, nii_fn, h);
    
    xps_fn = mdm_xps_fn_from_nii_fn(nii_fn);
    xps = mdm_xps_from_bt([0 0 0 0 0 0]);
    mdm_xps_save(xps, xps_fn);    
    
    s{n}.nii_fn = nii_fn;
    s{n}.xps = xps;
end 





