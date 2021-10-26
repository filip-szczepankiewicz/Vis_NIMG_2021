function lr_ind = srr_lr_ind_from_pos(hr_pos, lr_p, hr_p, opt)
% function lr_ind = srr_lr_ind_from_pos(hr_pos, lr_p, hr_p, opt)

if (nargin < 1), opt.present = 1; end 

lr_ind = []; 

% search for lr index closest to pos
lr_ind_init = (lr_p.fovrot([1,3], [1,3]) \ (hr_pos - ...
               [lr_p.qoffset_x ; lr_p.qoffset_z])) ./ ...
               [lr_p.pixdim_x; -lr_p.pixdim_z];              

i_init = floor(lr_ind_init(1)) + 1;
j_init = floor(lr_ind_init(2)) + 1;

% get coordinates of hr
hr_pos_x = [hr_pos(1) + hr_p.pixdim_x/2, hr_pos(1) + hr_p.pixdim_x/2, ...
               hr_pos(1) - hr_p.pixdim_x/2, hr_pos(1) - hr_p.pixdim_x/2];
hr_pos_z = [hr_pos(2) + hr_p.pixdim_z/2, hr_pos(2) - hr_p.pixdim_z/2, ...
               hr_pos(2) - hr_p.pixdim_z/2, hr_pos(2) + hr_p.pixdim_z/2];

hr_shape = polyshape(hr_pos_x, hr_pos_z, 'Simplify', true);

% visualize shape
% figure(1); clf; plot(hr_shape); hold on;

% create a list of possible voxel index combinations contributing
i_vec = [i_init i_init-1 i_init+1 i_init-2 i_init+2];
j_vec = [j_init j_init-1 j_init+1 j_init-2 j_init+2];

[A,B] = meshgrid(i_vec,j_vec);
possible_indices =reshape(cat(2,A',B'),[],2);

c = 1;
f = 1;

% loop through the list to find the overlap for each possible voxel
fraction = 0; 
while single(sum(fraction)) < 0.999999 && c < size(possible_indices,1)+1 

    i = possible_indices(c,1);
    j = possible_indices(c,2);

    % check if out of boundaries
    if (i < 1 || i > lr_p.size(1)); c = c+1; continue; end
    if (j < 1 || j > lr_p.size(2)); c = c+1; continue; end

    % calculate lr position from indices
    lr_pos = lr_p.fovrot([1,3], [1,3]) * ([(i-1);(j-1)] .* ...
        [lr_p.pixdim_x ; -lr_p.pixdim_z])  + ...
        [lr_p.qoffset_x ; lr_p.qoffset_z];

    lr_cornerpos = [(lr_pos + lr_p.fovrot([1,3], [1,3]) * lr_p.cornervecs(1,:)') ...
                (lr_pos + lr_p.fovrot([1,3], [1,3]) * lr_p.cornervecs(2,:)') ... 
                (lr_pos + lr_p.fovrot([1,3], [1,3]) * lr_p.cornervecs(3,:)') ... 
                (lr_pos + lr_p.fovrot([1,3], [1,3]) * lr_p.cornervecs(4,:)')];

    lr_pos_x = lr_cornerpos(1,:);
    lr_pos_z = lr_cornerpos(2,:);

    lr_shape = polyshape(lr_pos_x, lr_pos_z, 'Simplify', true);

    % visualize shape
    % plot(lr_shape); 

    % check overlap between lr and hr voxel
    fraction(c) = area(intersect(hr_shape,lr_shape)) / hr_p.area;

    if fraction(c) ~= 0
        lr_ind(f,:) = [i j fraction(c)];
        f = f + 1;
    end       

    c = c + 1;

end
    
end 