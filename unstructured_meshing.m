function [nodes,faces, elems] = unstructured_meshing(mask, gridsize, closesize, elemsize, keep_ratio, vol_factor)
% Creates a unstructured tetrahedral mesh from a mask.
% Implementation is as follows:
%   1. Smooths the mask with a convolution kernel
%   2. Mesh boundary of ROI
%   3. Remeshes the boundary surface using given parameter
%   4. Smooths with a laplacian filter
%   5. Creates mesh from surface using given parameters
% 
% Input:
% - mask: a 3D binary matrix describing the ROI (region of interest).
% - gridsize: resolution for the voxelization of the mesh
% - closesize: if there are openings, set the closing diameter
% - elemsize: the size of the element of the output surface.
% - keep_ratio: percentage of elements being kept after the simplification
% - vol_factor: the max volumen of each element will be 0.12 * vol_factor
%
% Output:
% - nodes: node list of the triangular surface, 3 columns for x/y/z
% - faces: triangle node indices, each row is a triangle
% - elems: element list of the tetrahedral mesh
% 
% Other details:
% -  This function relies in the iso2mesh toolbox, be sure it's in your
%    path before using. 
%
% Author: Julio Sotelo
% Last modification: Tabita Catalan

disp('Smoothing mask...')
smooth_mask = smooth3(mask,'box',3); % smooth with standard convolution kernel (box, size 3)

disp('Getting boundary surface...')
[nodes1, faces1] = mesh_boundary(smooth_mask);

disp('Remeshing surface...')
opt.gridsize  = gridsize; 
opt.closesize = closesize; 
opt.elemsize  = elemsize; 
[newno,newfc] = remeshsurf(nodes1,faces1,opt);
faces2 = newfc(:,1:3); % remove last column (ID)
nodes2 = newno(:,1:3); % remove last column (ID)

disp('Smoothing with laplacian filter...')
conn = meshconn(faces2(:,1:3),size(nodes2,1));
nodes2_5 = smoothsurf(nodes2,[],conn,100,0.9,'laplacianhc', 0.1);
faces3 = faces2(:,1:3);
nodes3 = nodes2_5(:,1:3);

disp('Getting mesh...')
max_vol = 0.12*vol_factor; % 0.12 is the volume of a regular tethahedral of arist 1.
[node,elem,face]=s2m(nodes3(:,1:3),faces3(:,1:3),keep_ratio, max_vol);
faces = face(:,1:3);
nodes = node(:,1:3);
elems = elem(:,1:4);
end

