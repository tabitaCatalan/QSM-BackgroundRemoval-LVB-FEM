clc
close all 
clear 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Importing data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../../iso2mesh/') % This line must be chaged, path to iso2mesh
addpath('../data/')
addpath('../')

load msk;
load phs_unwrap.mat

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Meshing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gridsize = 5;
closesize = 0;
elemsize = 20;
keep_ratio = 0.7;
vol_factor = 10;
[nodes,faces, elems] = unstructured_meshing(msk, gridsize, closesize, elemsize, keep_ratio, vol_factor);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate folder for mesh data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder_name = generate_folder_name(gridsize, closesize, elemsize, keep_ratio, vol_factor);
folder_path = strcat('../results/', folder_name, '/');
mkdir folder_path

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Plotting data of mesh and saving image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);
plot_mesh(nodes,faces)

figure(2);
subplot 121
hist_surface_area(nodes,faces, 500)
subplot 122
hist_volume_elem(nodes,elems, 500)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Saving mesh to VTU file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

save_mesh_and_data_to_VTU(nodes, faces, elems, phs_unwrap, '../results')
