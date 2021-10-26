function h2l = srr_h2l_from_s(s, h_hr, opt)
% function h2l = srr_h2l_from_s(s, h_hr, opt)
% finds/builds the h2l operator from a cell array of low-res images saved in s

if (nargin < 1), opt.present = 1; end 

if nargin<2
     h_hr = srr_hr_header_from_lr(mdm_nii_read_header(s{1}.nii_fn));
end 

if exist(opt.h2l_fn, 'file')
    h2lstruct = load(opt.h2l_fn);
    h2l = h2lstruct.h2l;
    return;
end 
        
h2l = [];
for n = 1:length(s)

    h2l_fn = srr_h2l_fn_from_nii_fn(s{n}.nii_fn);
    
    % if h2l doesnt exist, create it
    if ~exist(h2l_fn, 'file') || opt.use_existing_h2l == 0
        
        h_lr = mdm_nii_read_header(s{n}.nii_fn);
        fprintf('Creating h2l operator for image %d out of %d... ', n, length(s));
        h2l_s = srr_h2l_from_header(h_lr, h_hr, opt);
        save(h2l_fn, 'h2l_s');
        disp('Done!')
    else
        
        h2lstruct = load(h2l_fn);
        h2l_s = h2lstruct.h2l_s;
        
        fprintf('Loaded existing h2l operator for image %d out of %d\n', n, length(s));
    end 
    
    h2l = cat(1, h2l, h2l_s);
    
       
end 
end