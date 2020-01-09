function [nodes, faces] = mesh_boundary(mask)
% Finds boundary of ROI (region of interest) defined by a mask, finding
% isosurface at value 0.5 (mask is binary)
% Input:
% - mask: a 3D binary matrix describing the ROI.
%
% Output:
% - nodes: node list of the triangular surface, 3 columns for x/y/z
% - faces: triangle node indices, each row is a triangle
%
% Other details:
% -  This function relies in the iso2mesh toolbox, be sure it's in your
%    path before using. 
%
% Author: Julio Sotelo
% Last modification: Tabita Catalan

[xd,yd,zd]=meshgrid(1:size(mask,1),1:size(mask,2),1:size(mask,3));
fv = isosurface(xd,yd,zd,mask,.5); % computes isosurface the value .5
nodes = fv.vertices;
faces = fv.faces;
end

