function h2l_s = srr_h2ls_from_h2l(h2l, ninputims, i)
% function h2l_s = srr_h2ls_from_h2l(h2l, ninputims, i)
% outputs single h2l_s from h2l

sz = size(h2l, 1) / ninputims;
h2l_s = h2l(((i-1)*sz + 1 : i*sz), :);

end