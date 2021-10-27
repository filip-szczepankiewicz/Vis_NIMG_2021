function [rot_angle, voxs] = srr_ph_calc_rotation(aspect, n_ims)
% gives the angle of rotation and voxel ratios and number of 
% needed LR images for a given aspect ratio

drot = 180 / n_ims;

rot_angle = [];
voxs = [];

for i = 1:n_ims
    degrees = (i-1)*drot;

    if degrees <= 45
        rot_angle(i) = degrees;
        voxs(i,:) = [1 aspect];

    elseif degrees > 45 && degrees <= 135 
        rot_angle(i) = degrees - 90;
        voxs(i,:) = [aspect 1];           

    elseif degrees > 135 && degrees <= 180 
        rot_angle(i) = degrees - 180;
        voxs(i,:) = [1 aspect];    
    end 

end