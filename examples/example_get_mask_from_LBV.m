% Script to generate masks with differents peels
% The idea is to be able to compare results between LBV FMG and LBV FEM
% using the same mask

addpath('../data/')
addpath('../')
addpath('../MEDI_toolbox/') % to use get_mask_and_solution_from_LBV
load phs_unwrap;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% peel = 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mask = ~(phs_unwrap == 0);

[mask_p0, phs_lbv_p0] = get_mask_and_solution_from_LBV(phs_unwrap, 0, mask);
save('../data/mask_p0.mat', 'mask_p0');
save('../data/phs_lbv_p0.mat', 'phs_lbv_p0');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% peel = 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[mask_p1,phs_lbv_p1] = get_mask_and_solution_from_LBV(phs_unwrap, 1, mask);
save('../data/mask_p1.mat', 'mask_p1');
save('../data/phs_lbv_p1.mat', 'phs_lbv_p1');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% peel = 5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[mask_p5, phs_lbv_p5] = get_mask_and_solution_from_LBV(phs_unwrap, 5, mask);
save('../data/mask_p5.mat', 'mask_p5');
save('../data/phs_lbv_p5.mat', 'phs_lbv_p5');
