function interpolated_data = interpolate_to_mesh_nodes(data, nodes)
% Interpolates data to the nodes of a mesh
% Input:
% - data:
% - nodes: node list of the triangular surface, 3 columns for x/y/z
%
% Output:
% - interpolated_data: each row is the interpolated data in node
[X,Y,Z]=meshgrid(1:size(data,1),1:size(data,2),1:size(data,3));
X=double(X);
Y=double(Y);
Z=double(Z);

interpolated_data = interp3(X,Y,Z,data,nodes(:,1),nodes(:,2),nodes(:,3),'linear');
end

