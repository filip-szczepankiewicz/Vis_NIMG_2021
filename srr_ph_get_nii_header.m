function nii_h_cell = srr_ph_get_nii_header(aspect, n_ims, psize)
% function nii_h_cell = srr_ph_get_nii_header(aspect, n_ims, psize)
% create nii header with relevant geometric info for phantom ims

[rot_angle, voxs] = srr_ph_calc_rotation(aspect, n_ims);

nii_h_cell = cell(n_ims,1);

for n = 1:n_ims

    % set L properties
    h = mdm_nii_h_empty();
    a = rot_angle(n);
    R = [-cos(a / 180 * pi) 0 sin(a / 180 * pi);0 1 0; -sin(a / 180 * pi) 0 -cos(a / 180 * pi)];
    
    quat = rotm2quat(R);
    
    h.quatern_b = quat(2);
    h.quatern_c = quat(3);
    h.quatern_d = quat(4);  

    offsets = R * [psize; 0; -psize];
    h.qoffset_x = -1*offsets(1);
    h.qoffset_y = offsets(2);
    h.qoffset_z = -1*offsets(3);

    h.pixdim(1) = -1;
    h.pixdim(2) = voxs(n,1)*2;
    h.pixdim(3) = 2;
    h.pixdim(4) = voxs(n,2)*2;

    h.dim(2) = double((psize / voxs(n,1)*2)/2);
    h.dim(3) = 1;
    h.dim(4) = double((psize / voxs(n,2)*2)/2);
        
    nii_h_cell{n} = h;
    
end 