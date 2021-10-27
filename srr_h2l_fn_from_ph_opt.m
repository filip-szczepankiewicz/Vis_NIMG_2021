function h2l_fn = srr_h2l_fn_from_ph_opt(opt)
% function h2l_fn = srr_h2l_fn_from_phantomopt(opt)

if (nargin < 1); opt.present = 1; end
opt = srr_ph_opt(opt);

path = fullfile(opt.h2l_path, opt.h2l_folder);

if ~exist(path); mkdir(path); end

name = sprintf('ph%d_nrot%d_asp%s', opt.psize, opt.n_ims, num2str(opt.aspect));

h2l_fn = fullfile(path, [name '_h2l.mat']);