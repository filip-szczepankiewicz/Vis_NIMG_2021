function hr = srr_recon(h2l, lr_c, hr_size2d, aspect, n_ims, lambda)
% function hr = srr_recon(h2l, lr_c, hr_size2d, aspect, n_ims, lambda)
%
% Reconstructs multiple low resolution images to a high resolution image
% Solves the following equation:
%
% H              =  A                 *      L
% (1 * numel_h)   (numel_h * numel_l)      (numel_l * 1)
%
% with A being contructed from H2L and lambda

hr_c = ((1-lambda)* (h2l.'*h2l) + (lambda * aspect * n_ims * speye(size(h2l,2)))) \ (h2l.'*lr_c);

hr = reshape(hr_c, hr_size2d);

