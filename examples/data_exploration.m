addpath('../data/')
addpath('../')

load msk;           % brain mask => obtained by eroding the BET mask by 5 voxels (by setting peel=5 in LBV)
load Mask_bet;      % brain mask from BET
load phs_unwrap;    % phase from trans orient processed with Laplacian unwrapping and BET masking (in radians)
load mask_p0;
load mask_p1;
load mask_p5;
load phs_lbv_p0;
load phs_lbv_p1;
load phs_lbv_p5;

eroded5 = erode_mask(Mask_bet, 5);
N = size(Mask_bet);

imagesc3d2(mask_p0, N/2, 1, [90,90,-90], [0,1], [], 'mask\_p0')

imagesc3d2(mask_p1, N/2, 2, [90,90,-90], [0,1], [], 'mask\_p1')

imagesc3d2(mask_p5, N/2, 3, [90,90,-90], [0,1], [], 'mask\_p5')
%%
imagesc3d2(phs_lbv_p0, N/2, 4, [90,90,-90], [-pi,pi], [], 'phs\_lbv\_p0')
imagesc3d2(phs_lbv_p1, N/2, 5, [90,90,-90], [-pi,pi], [], 'phs\_lbv\_p1')
imagesc3d2(phs_lbv_p5, N/2, 6, [90,90,-90], [-pi,pi], [], 'phs\_lbv\_p5')

%%

imagesc3d2(eroded5, N/2, 4, [90,90,-90], [0,1], [], 'Mask\_bet eroded, peel = 5')

imagesc3d2(Mask_bet - eroded5, N/2, 5, [90,90,-90], [-1,1], [], 'Mask\_bet - eroded by peel=5 Mask\_bet')

imagesc3d2(msk - eroded5, N/2, 6, [90,90,-90], [-1,1], [], 'msk - eroded by peel=5 Mask\_bet')

imagesc3d2(phs_unwrap, N/2, 7, [90,90,-90], [-pi,pi], [], 'phase\_unwrap')

