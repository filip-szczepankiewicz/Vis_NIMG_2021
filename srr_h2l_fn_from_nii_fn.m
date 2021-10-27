function h2l_fn = srr_h2l_fn_from_nii_fn(nii_fn)
% function h2l_fn = srr_h2l_fn_from_nii_fn(nii_fn)

if (iscell(nii_fn))
    h2l_fn = cellfun(@srr_h2l_fn_from_nii_fn, nii_fn, 'uniformoutput', 0);
    return;
end

[path, name] = msf_fileparts(nii_fn);

h2l_fn = fullfile(path, [name '_h2l.mat']);