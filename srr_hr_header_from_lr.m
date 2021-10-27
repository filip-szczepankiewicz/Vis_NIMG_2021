function h_hr = srr_hr_header_from_lr(h_lr)
% function h_hr = srr_hr_header_from_lr(h_lr)

h_hr = h_lr;
tmp = single(h_hr.dim(4))*h_hr.pixdim(4)/(h_hr.pixdim(2));
h_hr.dim(4) = int16(tmp);
h_hr.pixdim(4) = h_lr.pixdim(2);   

end 