function name = generate_folder_name(peel, gridsize, closesize, elemsize, keep_ratio, vol_factor)
% Generates a string (which depends on arguments used to generate a mesh), to
% be used as folder name for results
% Input:
% - peel: int, how many voxels were eroded from the original mask
% - see unstructured_meshing for details of the other inputs
% Output:
% - name: char with a folder name. The convention used is the initial
% letter of each argument, followed by the value formeted with one decimal
% (except in peel, which is an int). "." are replaced by "-".
%
% Author: Tabita Catalan
formatSpec = 'p%d_g%.1f_c%.1f_e%.1f_k%.1f_v%.1f';
name = sprintf(formatSpec,peel, gridsize, closesize, elemsize, keep_ratio, vol_factor);
name = replace(name,'.','-'); % to avoid format problems
end

