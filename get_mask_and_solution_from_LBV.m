function [new_mask, phs_lbv] = get_mask_and_solution_from_LBV(phase_unwrapped, peel, original_mask)
% Input:
% - peel: number of voxels to peel from the mask boundary
N = [160 160 160];
spatial_res = [255/240, 255/240, 180/168];
tol = 1e-2; % default
depth = -1; % default

phs_lbv = LBV(phase_unwrapped, original_mask, N, spatial_res, tol, depth, peel);
new_mask = phs_lbv~=0;
end