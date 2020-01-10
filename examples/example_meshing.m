clc
close all 
clear 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Importing data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../../iso2mesh/') % This line should be changed, path to iso2mesh
addpath('../data/')
addpath('../')

load msk;               % mask of a brain ROI, with peel = 5
load phs_unwrap.mat     % phase unwrapped with laplacian unwrapping method.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Meshing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gridsize = 1;
closesize = 0;
elemsize = 1;
keep_ratio = 0.4;
vol_factor = 30;
[nodes,faces, elems] = unstructured_meshing(msk, gridsize, closesize, elemsize, keep_ratio, vol_factor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate folder for mesh data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

peel = 5;
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
%%% Saving mesh to VTU file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filename = strcat(folder_path, 'mesh_data');
save_mesh_and_data_to_VTU(nodes, faces, elems, phs_unwrap, filename)
