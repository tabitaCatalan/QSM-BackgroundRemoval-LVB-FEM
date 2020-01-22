% This file shows how to use the solution got by solving laplace equation
% to obtain the phase tissue.
% It assumes that mesh data and solution is stored in a folder inside
% results/, its name stored in folder_name.txt
% 
% Based on the code by Bilgic Berkin at http://martinos.org/~berkin/software.html
% Last modification: Tabita Catalan 2020.01.22

addpath('../data/')
addpath('../')
addpath('../MEDI_toolbox/') % to use LBV

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Read solution from VTU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


fileID = fopen('folder_name.txt');
folder_name = fgetl(fileID);
fclose(fileID);

path = "../results/" + folder_name + "/";
filename = 'Solution000001';
tic
  solution = read_solution_from_VTU(path, filename);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Separate data in Matlab variables
%%% solution{1}: data points, components x,y,z
%%% solution{5}: solution
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

points = reshape(solution{1}, [3,length(solution{1})/3]).';
harmonic_noise = solution{5};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Interpolation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Loading data from QSM2016ReconChallenge')

load phs_unwrap; % phase from trans orient processed with Laplacian unwrapping and BET masking (in radians)
load Mask_bet;
load phs_tissue; % tissue phase from transversal orientation (in ppm, normalized by gyro*TE*B0)

[X,Y,Z]=meshgrid(1:160,1:160,1:160);
X=double(X);
Y=double(Y);
Z=double(Z);
[pointsNoRedundant, index] = unique(points, 'rows');
phs_harmonic = griddata(points(index,1), points(index,2), points(index,3), harmonic_noise(index), X, Y, Z);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data and solution exploration 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tol = 1e-2;         % default
depth = -1;         % default
peel = 5;           % no of voxels to peel from the mask boundary
     
tic
    Phase_lbv = LBV(Phase_unwrapped, Mask_bet, N, spatial_res, tol, depth, peel);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data correction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% change NaN to 0
% msk = (~isnan(phs_harmonic)).*msk;
phs_harmonic(isnan(phs_harmonic))=0;

% Escale
load prot;  % header information

TE = prot.alTE * 1e-6;           % sec
B0 = prot.flNominalB0;           % Tesla
gyro = 2*pi*42.58;

phs_scale = TE * gyro * B0;

phs_tissue_FEM = (phs_unwrap - phs_harmonic)/phs_scale;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data and solution exploration 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Plotting results')
N = size(msk);

imagesc3d2(phs_unwrap, N/2, 1, [90,90,-90], [-pi,pi], [], 'Unwrapped Phase')
saveas(gcf,'images/results_01_phase_unwrapped.png')
%close

imagesc3d2(phs_tissue, N/2, 2, [90,90,-90], [-0.05,0.05], [], 'Phase Tissue LBV FMG + 3d polyfit')
saveas(gcf,'images/results_02_phase_tissue_lbv_fmg_poly.png')
%close

imagesc3d2(phs_tissue_FEM.*msk, N/2, 3, [90,90,-90], [-0.05,0.05], [], 'Phase Tissue LBV FEM')
colorbar
caxis('auto')
saveas(gcf,'images/results_03_phase_tissue_lbv_fem.png')
%close
%% 3d polynomial fit to remove transmit phase from LBV
% Roemer coil combination fails to remove B1+ phase and includes some
% contribution from B1- of the body coil 
%%-------------------------------------------------------------------------
disp('Fitting 3d polynomial to remove transmit phase')
Order = 4;      % degree of 3d polyfit


tic
    I_fitted = polyfit3D_NthOrder(phs_tissue_FEM, msk, Order);
toc


% subtract fitted phase
phs_tissue_FEM_final = (phs_tissue_FEM - I_fitted ).* msk;

%%
disp('Plotting corrected results')
imagesc3d2(phs_tissue_FEM_final, N/2, 4, [90,90,-90], [-0.05,0.05], [], 'Remove Tx phase: normalized field map')
set(gcf, 'color', [1,1,1]*0.15), colorbar, set(gca, 'fontsize', 32)
caxis('auto')
saveas(gcf,'images/results_04_phase_tissue_lbv_fem_3dpoly.png')
%close

imagesc3d2(I_fitted.*msk, N/2, 5, [90,90,-90], [-0.05,0.05], [], 'Removed component')
set(gcf, 'color', [1,1,1]*0.15), colorbar, set(gca, 'fontsize', 32)
caxis('auto')
saveas(gcf,'images/results_05_removed_component.png')
%close


%% create dipole kernel
%%-------------------------------------------------------------------------
disp('Getting susceptibility with TKD')
load spatial_res;

[ky,kx,kz] = meshgrid(-N(1)/2:N(1)/2-1, -N(2)/2:N(2)/2-1, -N(3)/2:N(3)/2-1);

kx = (kx / max(abs(kx(:)))) / spatial_res(1);
ky = (ky / max(abs(ky(:)))) / spatial_res(2);
kz = (kz / max(abs(kz(:)))) / spatial_res(3);

k2 = kx.^2 + ky.^2 + kz.^2;


R_tot = eye(3);     % orientation matrix for transverse acquisition


kernel = fftshift( 1/3 - (kx * R_tot(3,1) + ky * R_tot(3,2) + kz * R_tot(3,3)).^2 ./ (k2 + eps) );    


kernel_disp = fftshift(mean(abs(kernel), 4));
mosaic(squeeze(kernel_disp(1+end/2,:,:)), 1, 1, 6, '', [0,2/3])

 

%%-------------------------------------------------------------------------
%% TKD recon
%%-------------------------------------------------------------------------


thre_tkd = 0.19;      % TKD threshold parameter


kernel_inv = zeros(N);
kernel_inv( abs(kernel) > thre_tkd ) = 1 ./ kernel(abs(kernel) > thre_tkd);


chi_tkd_FEM = real( ifftn( fftn(phs_tissue_FEM_final) .* kernel_inv ) ) .* msk; 
chi_tkd = real( ifftn( fftn(phs_tissue) .* kernel_inv ) ) .* msk; 

disp('Ploting results')
%%
imagesc3d2(chi_tkd, N/2, 7, [90,90,-90], [-0.10,0.14], [], 'TKD LBV')
colorbar
caxis('auto')
saveas(gcf,'images/results_06_chi_tkd_lbv_fmg.png')
%close

imagesc3d2(chi_tkd_FEM, N/2, 8, [90,90,-90], [-0.10,0.14], [], 'TKD FEM')
colorbar
caxis('auto')
saveas(gcf,'images/results_07_chi_tkd_lbv_fem.png')
%close

disp('Images were stored in images/')
%% compute error
disp('Computing rmse error')
load chi_cosmos;
rmse_tkd_cosmos = compute_rmse(chi_tkd, chi_cosmos)
rmse_tkd_cosmos_FEM = compute_rmse(chi_tkd_FEM, chi_cosmos)
%%
imagesc3d2(chi_cosmos - chi_tkd_FEM, N/2, 9, [90,90,-90], [-0.1,0.1], [], 'Error LBV')
colorbar
caxis('auto')
saveas(gcf,'images/results_08_chi_cosmos-lbv.png')

imagesc3d2(chi_cosmos - chi_tkd, N/2, 10, [90,90,-90], [-0.1,0.1], [], 'Error FEM')
colorbar
caxis('auto')
saveas(gcf,'images/results_09_chi_cosmos-fem.png')
%%
imagesc3d2(chi_tkd - chi_tkd_FEM, N/2, 11, [90,90,-90], [-0.1,0.1], [], 'LBV - FEM')
colorbar
caxis('auto')
saveas(gcf,'images/results_10_chi_lbv-fem.png')
