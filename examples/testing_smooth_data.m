% Created by Tabita Catalan in 2020.01.29

addpath('../data/')
load phs_unwrap;
load mask_p0;
imagesc3d2(phs_unwrap.*mask_p0, N/2, 1, [90,90,-90], [-pi,pi], [], 'phs\_unwrap')

phs_unwrap_smooth = smooth3(phs_unwrap);

imagesc3d2(phs_unwrap_smooth.*mask_p0, N/2, 2, [90,90,-90], [-pi,pi], [], 'phs\_unwrap')