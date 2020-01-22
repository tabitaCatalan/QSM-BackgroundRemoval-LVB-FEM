clc
close all 
clear 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Importing data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../../iso2mesh/') % This line should be changed, path to iso2mesh
addpath('../data/')
addpath('../')

load Mask_bet;

load msk;               % mask of a brain ROI, with peel = 5
load phs_unwrap.mat;     % phase unwrapped with laplacian unwrapping method.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Erode mask
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Meshing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gridsize = 0.4;
closesize = 0;
elemsize = 1.6;
keep_ratio = 0.6;
vol_factor = 10;
[nodes,faces, elems] = unstructured_meshing(mask, gridsize, closesize, elemsize, keep_ratio, vol_factor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate folder for mesh data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

peel = 0;
folder_name = generate_folder_name(peel, gridsize, closesize, elemsize, keep_ratio, vol_factor);
folder_path = strcat('../results/', folder_name, '/');
mkdir(folder_path)

% generates a file with the folder name
fileID = fopen('folder_name.txt','w');
fprintf(fileID,'%s',folder_name);
fclose(fileID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plotting data of mesh and saving image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
plot_mesh(nodes,faces)
saveas(gcf, strcat(folder_path,'mesh.png'))

figure(2);
subplot 121
hist_surface_area(nodes,faces, 500)
subplot 122
hist_volume_elem(nodes,elems, 500)
saveas(gcf, strcat(folder_path,'hist_area_vol_mesh.png'))


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% interpolation 3D
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[X,Y,Z]=meshgrid(1:size(phs_unwrap,1),1:size(phs_unwrap,2),1:size(phs_unwrap,3));
X=double(X);
Y=double(Y);
Z=double(Z);

phs_unwrap_scalar = interp3(X,Y,Z,phs_unwrap,nodes(:,1),nodes(:,2),nodes(:,3),'linear');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Saving mesh to VTU file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = strcat(folder_path, 'mesh_data');
save_mesh_and_data_to_VTU(nodes, faces, elems, phs_unwrap_scalar, filename)
