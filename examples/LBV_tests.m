% LBV tests

load phs_unwrap;
load Mask_bet;

mask_from_unwrap = 1 - (phs_unwrap == 0);

N = [160 160 160];
spatial_res = [255/240, 255/240, 180/168];
tol = 1e-2; % default
depth = -1; % default
peel = 5;   % #number of voxels to peel from the mask boundary

tic
    phs_lbv_v1 = LBV(phs_unwrap, Mask_bet, N, spatial_res, tol, depth, peel);
toc    

tic
    phs_lbv_v2 = LBV(phs_unwrap, mask_from_unwrap, N, spatial_res, tol, depth, peel);
toc

Mask_lbv_v1 = phs_lbv_v1~=0;
Mask_lbv_v2 = phs_lbv_v2~=0;

%% 

load msk

get_equal_ratio(Mask_lbv_v1, Mask_lbv_v2)
get_equal_ratio(Mask_lbv_v1, msk)
get_equal_ratio(msk, Mask_lbv_v2)
get_equal_ratio(Mask_lbv_v1, erode_mask(Mask_bet,5))
get_equal_ratio(erode_mask(Mask_bet,5), Mask_lbv_v2)
get_equal_ratio(Mask_lbv_v1, erode_mask(mask_from_unwrap,5))
get_equal_ratio(erode_mask(mask_from_unwrap,5), Mask_lbv_v2)




