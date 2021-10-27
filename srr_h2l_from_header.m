function h2l_s = srr_h2l_from_header(h_lr, h_hr, opt)
% function h2l_s = srr_h2l_from_header(h_lr, h_hr, opt)
% create h2l from nii fn given a reference header

if (nargin < 1), opt.present = 1; end 

% get reference properties
hr_p = geometerics_from_header(h_hr);
lr_p = geometerics_from_header(h_lr);   

h2l_s = sparse(prod(lr_p.size), prod(hr_p.size));

% loop over hr im
for i = 1:hr_p.size(1)
    for j = 1:hr_p.size(2)
       hr_ind = sub2ind(hr_p.size, i, j);

       % get real world position of hr voxel
       hr_pos = hr_p.fovrot([1,3], [1,3]) * ...
       ([(i-1);(j-1)] .* [hr_p.pixdim_x;-hr_p.pixdim_z]) + ...
       [hr_p.qoffset_x; hr_p.qoffset_z];

       % get lr indices and weights of overlap
       lr_ind = srr_lr_ind_from_pos(hr_pos, lr_p, hr_p, opt); 

       if isempty(lr_ind); continue; end
              
       % fill h2l operator accordingly
       for k = 1:size(lr_ind,1)
            ind_l = sub2ind(lr_p.size, lr_ind(k,1), lr_ind(k,2));
            h2l_s(ind_l, hr_ind) = h2l_s(ind_l, hr_ind) + lr_ind(k,3);
       end

    end
end  
    
end 

function p = geometerics_from_header(h)
   
    p.size  = double([h.dim(2) h.dim(4)]);
    
    b = h.quatern_b; c = h.quatern_c; d = h.quatern_d;
    a = sqrt(1.0-(b*b+c*c+d*d));
    p.fovrot = double(quat2rotm([a b c d]));
    
    p.pixdim_x = double(h.pixdim(2));
    p.pixdim_z = double(h.pixdim(4)); 
    p.area =  double(p.pixdim_x * p.pixdim_z);
    
    p.qoffset_x = double(h.qoffset_x);
    p.qoffset_z = double(h.qoffset_z);
    
    p.cornervecs = double([p.pixdim_x/2 p.pixdim_z/2;
                     -p.pixdim_x/2 p.pixdim_z/2;
                     -p.pixdim_x/2 -p.pixdim_z/2;
                     p.pixdim_x/2 -p.pixdim_z/2]);
end 
