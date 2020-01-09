function area = surface_area(nodes,faces)
% Computes the a the area of each triangle of a mesh.
% Input:
% - nodes: node coordinates of a tetrahedral mesh, 3 columns (x,y,x)
% - faces: triangle node indices, each row is a triangle
% Output:
% - area: vector with area of each face
% Autor: Julio Sotelo
% Last modification: Tabita Catalan

% Lenght of sides given two index of vertices: i,j = 1,2,3
legth_triangle_side = @(i,j) sqrt(sum((nodes(faces(:,i),:)-nodes(faces(:,j),:)).^2,2));

d1 = legth_triangle_side(1,2); 
d2 = legth_triangle_side(2,3);
d3 = legth_triangle_side(3,1);

s = (d1+d2+d3)/2; % semiperimeter

area = sqrt(s.*(s-d1).*(s-d2).*(s-d3));    
end

