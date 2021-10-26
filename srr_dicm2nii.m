function [nii_fn_cell, dcm_fn_cell] = srr_dicm2nii(dcm_folder_cell, odir)
% function [nii_fn_cell, dcm_fn_cell] = srr_dicm2nii(dcm_folder_cell, odir)
%
% input
% dcm_folder_cell - is a cell array of folders that contain dicom files.
% odir            - is a folder where output is stored
%
% output saves .nii.gz .bval .bvec and a header structure
%
% Code is based on DICM2NII
% http://www.mathworks.com/matlabcentral/fileexchange/42997
% To cite the work and for more detail about the conversion, check the paper at
% http://www.sciencedirect.com/science/article/pii/S016502701630007

% Convert dicom to nifti
for i = 1:length(dcm_folder_cell)
    dicm2nii(dcm_folder_cell{i}, odir);
end

% Since dicm2nii does not output the resulting filenames, we find them by
% using the dcmHeader structure.
load([odir filesep 'dcmHeaders.mat']);

fn = fieldnames(h);

for i = 1:numel(fn)
    nii_fn_cell{i} = [odir filesep fn{i} '.nii.gz'];
    dcm_fn_cell{i} = h.(fn{i}).Filename;
end