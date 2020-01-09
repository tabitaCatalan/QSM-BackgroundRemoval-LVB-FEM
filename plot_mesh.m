function plot_mesh(nodes,faces)
% Plot a mesh. It doesn't generate a Matlab Figure.
% 
% Input:
% - nodes: node list of the triangular surface, 3 columns for x/y/z
% - faces: triangle node indices, each row is a triangle

patch('faces',faces,'Vertices',nodes,'FaceColor','r','EdgeColor','k');
axis vis3d
lighting gouraud
daspect([1,1,1])
axis off
view([-34,-51])
colorbar('off')
end

