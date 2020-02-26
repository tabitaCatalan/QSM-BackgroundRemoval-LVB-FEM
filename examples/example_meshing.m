% This file shows an example of how to get and unstructured mesh from
% a 3D binary mask and save it to a VTU file.
% Mesh data is stored in a folder inside results/, its name depending on
% the parameters used to generate the mesh (gridsize, closesize, elemsize,
% keep_ratio, vol_factor) and the peel used to erode the mask.
% The folder name is stored in the file folder_name.txt
%
% Author: Julio Sotelo
% Last modification: Tabita Catalan 2020.01.22

clc
close all 
clear 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Importing data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath('../../iso2mesh/') % This line should be changed, path to iso2mesh
addpath('../data/')
addpath('../')

load mask_p0.mat;
load mask_p1.mat;
load mask_p5.mat;
load phs_unwrap.mat;    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Use eroded mask
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mask = mask_p5;

% Be sure to use the right peel
% peel = 0; % if using mask_p0
% peel = 1; % if using mask_p1
peel = 5; % if using mask_p5

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Set mesh parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gridsize = 0.4;
closesize = 0;
elemsize = 1.6;
keep_ratio = 0.6;
vol_factor = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Generate folder for mesh data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

folder_name = generate_folder_name(peel, gridsize, closesize, elemsize, keep_ratio, vol_factor);
folder_path = strcat('../results/', folder_name, '/');
mkdir(folder_path)

% generates a file with the folder name
fileID = fopen('folder_name.txt','w');
fprintf(fileID,'%s',folder_name);
fclose(fileID);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Meshing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% creates file to save log, or overwrites it if exists 
log_id = fopen(strcat(folder_path,'log_mesh.txt'),'w');
fclose(log_id);

% save log 
diary(strcat(folder_path, 'log_mesh.txt'))
tic
[nodes,faces, elems] = unstructured_meshing(mask, gridsize, closesize, elemsize, keep_ratio, vol_factor);
toc;

diary off

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
