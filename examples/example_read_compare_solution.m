% This file shows how to use the solution got by solving laplace equation
% to obtain the phase tissue.
% It assumes that mesh data and solution is stored in a folder inside
% results/, its name stored in folder_name.txt
% 
% Based on the code by Bilgic Berkin at http://martinos.org/~berkin/software.html
% Last modification: Tabita Catalan 2020.01.22

addpath('../data/')
addpath('../')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Load data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load phs_unwrap;

%load mask_p0;
%load mask_p1;
load mask_p5;

%load phs_lbv_p0;
%load phs_lbv_p1;
load phs_lbv_p5;

mask = mask_p5;
phs_lbv = phs_lbv_p5;

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

[X,Y,Z]=meshgrid(1:160,1:160,1:160);
X=double(X);
Y=double(Y);
Z=double(Z);
[pointsNoRedundant, index] = unique(points, 'rows');
phs_harmonic = griddata(points(index,1), points(index,2), points(index,3), harmonic_noise(index), X, Y, Z);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Getting phase from FEM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% change NaN to 0
phs_harmonic(isnan(phs_harmonic))=0;

phs_fem = (phs_unwrap - phs_harmonic).*mask;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Data exploration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
N = [160 160 160];

imagesc3d2(phs_lbv, N/2, 1, [90,90,-90], [-pi,pi], [], 'phs\_lbv')
saveas(gcf, strcat(path,'phs_lbv.png'))
close
imagesc3d2(phs_fem, N/2, 2, [90,90,-90], [-pi,pi], [], 'phs\_fem')
saveas(gcf, strcat(path,'phs_fem.png'))
close
% Comparacion
imagesc3d2(phs_fem - phs_lbv, N/2, 3, [90,90,-90], [-0.5,0.5], [], 'phs\_fem - phs\_lbv')
saveas(gcf, strcat(path,'phs_lbv-phs_fem.png'))
close


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Escaling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load prot;  % header information

TE = prot.alTE * 1e-6;           % sec
B0 = prot.flNominalB0;           % Tesla
gyro = 2*pi*42.58;

phs_scale = TE * gyro * B0;

phs_scale_tissue_LBV = phs_lbv/phs_scale;
phs_scale_tissue_FEM = phs_fem/phs_scale;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 3D Polyfit
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3d polynomial fit to remove transmit phase from LBV
% Roemer coil combination fails to remove B1+ phase and includes some
% contribution from B1- of the body coil 

disp('Fitting 3d polynomial to remove transmit phase')

order = 4;      % degree of 3d polyfit
[phs_tissue_FEM_final, removed_poly_FEM] = remove_transmit_phase(phs_scale_tissue_FEM, mask, order);
[phs_tissue_LBV_final, removed_poly_LBV] = remove_transmit_phase(phs_scale_tissue_LBV, mask, order);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plotting final phase tissue
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imagesc3d2(phs_tissue_LBV_final, N/2, 4, [90,90,-90], [-0.05,0.05], [], 'Final Phase Tissue LBV')
saveas(gcf, strcat(path,'phs_tissue_lbv_final.png'))
close

imagesc3d2(phs_tissue_FEM_final, N/2, 5, [90,90,-90], [-0.05,0.05], [], 'Final Phase Tissue FEM')
saveas(gcf, strcat(path,'phs_tissue_fem_final.png'))
close

% Comparacion
imagesc3d2(phs_tissue_FEM_final - phs_tissue_LBV_final, N/2, 6, [90,90,-90], [-0.05,0.05], [], 'Difference Phase Tissue (FEM - LBV)')
saveas(gcf, strcat(path,'phs_tissue_fem_final-phs_tissue_lbv_final.png'))
close

imagesc3d2(removed_poly_FEM, N/2, 7, [90,90,-90], [-0.05,0.05], [], 'Fitted 3D Polynomial FEM')
saveas(gcf,strcat(path,'removed_poly_FEM.png'))
close

imagesc3d2(removed_poly_LBV, N/2, 8, [90,90,-90], [-0.05,0.05], [], 'Fitted 3D Polynomial LBV')
saveas(gcf,strcat(path,'removed_poly_LBV.png'))
close

imagesc3d2(removed_poly_FEM - removed_poly_LBV, N/2, 9, [90,90,-90], [-0.05,0.05], [], 'Difference of Fitted 3D Polynomials (FEM-LBV)')
saveas(gcf,strcat(path,'removed_poly_FEM-LBV.png'))
close


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Create dipole kernel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load spatial_res;

kernel = dipole_kernel(N, spatial_res);

% display
%kernel_disp = fftshift(mean(abs(kernel), 4));
%mosaic(squeeze(kernel_disp(1+end/2,:,:)), 1, 1, 10, '', [0,2/3]) 
%close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Inversion with TKD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

thre_tkd = 0.19;      % TKD threshold parameter

chi_tkd_FEM = TKD(thre_tkd, N, kernel, phs_tissue_FEM_final, mask);
chi_tkd_LBV = TKD(thre_tkd, N, kernel, phs_tissue_LBV_final, mask);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plotting Results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imagesc3d2(chi_tkd_FEM, N/2, 11, [90,90,-90], [-0.10,0.1], [], 'TKD FEM')
saveas(gcf,strcat(path,'chi_tkd_fem.png'))
close

imagesc3d2(chi_tkd_LBV, N/2, 12, [90,90,-90], [-0.10,0.1], [], 'TKD LBV')
saveas(gcf,strcat(path,'chi_tkd_fem.png'))
close

imagesc3d2(chi_tkd_FEM - chi_tkd_LBV, N/2, 13, [90,90,-90], [-0.10,0.1], [], 'TKD FEM - LBV')
saveas(gcf,strcat(path,'chi_tkd_fem-lbv.png'))
close

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Compute RMS error
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Computing rmse error')
load chi_cosmos;

% creates file to save log, or overwrites it if exists 
log_id = fopen(strcat(path,'rmse.txt'),'w');
fclose(log_id);

diary(convertStringsToChars(strcat(path, 'rmse.txt')))
    rmse_tkd_cosmos_LBV = compute_rmse(chi_tkd_LBV, chi_cosmos)
    rmse_tkd_cosmos_FEM = compute_rmse(chi_tkd_FEM, chi_cosmos)
diary off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plot error with respect to COSMOS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

imagesc3d2(chi_cosmos - chi_tkd_LBV, N/2, 14, [90,90,-90], [-0.1,0.1], [], 'Error LBV')
saveas(gcf,strcat(path,'chi_cosmos-lbv.png'))
close

imagesc3d2(chi_cosmos - chi_tkd_FEM, N/2, 15, [90,90,-90], [-0.1,0.1], [], 'Error FEM')
saveas(gcf,strcat(path,'chi_cosmos-fem.png'))
close
