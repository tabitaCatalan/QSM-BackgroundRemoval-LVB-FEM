function save_mesh_and_data_to_VTU(nodes, faces, elems, point_data, filename)
% Writes a VTU file with data to construct a mesh 
% Input:
% - nodes:  node coordinates of the tetrahedral mesh, 3 columns (x,y,x)
% - faces: triangle node indices, each row is a triangle
% - elems: element list of the tetrahedral mesh
% - point_data
% - filename: without extension. It can include an existing folder of destination; if
%   it doesn't, file is saved in current directory.
%   Example: 'mesh' or 'data/mesh'.
% 
% Author: Julio Sotelo
% Last modification: Tabita Catalan
elem_n = elems-1;
faces_n = faces-1;
nodes_n = nodes;
ID_nodes = (1:size(nodes_n,1))';
tetra = elem_n;
cell_type1 = zeros(1,size(elem_n,1))'+10;
cell_ID1 = ((1:length(tetra(:,1)))*4)';
tria = faces_n;
cell_type2 = zeros(1,size(faces_n,1))'+5;
cell_ID2 = ((1:length(tria(:,1)))*3)'+ cell_ID1(end);

nodevol = squeeze(nodevolume(nodes_n,elems));
file = strcat(filename, '.vtu');
fileID = fopen(file, 'w');
fprintf(fileID,'%s\n','<?xml version="1.0"?>');
fprintf(fileID,'%s\n','<VTKFile type="UnstructuredGrid"  version="0.1"  >');
fprintf(fileID,'%s\n','<UnstructuredGrid>');
fprintf(fileID,'%s\n',['<Piece  NumberOfPoints="',num2str(length(nodes_n(:,1))),'" NumberOfCells="',num2str(length(elem_n(:,1)) + length(faces_n(:,1))),'">']);
fprintf(fileID,'%s\n','<Points>');
fprintf(fileID,'%s\n','<DataArray  type="Float64"  NumberOfComponents="3"  format="ascii">');
fprintf(fileID,'%f %f %f\n',nodes_n');
fprintf(fileID,'%s\n','</DataArray>');
fprintf(fileID,'%s\n','</Points>');
fprintf(fileID,'%s\n','<Cells>');
fprintf(fileID,'%s\n','<DataArray  type="UInt32"  Name="connectivity"  format="ascii">');
fprintf(fileID,'%d %d %d %d\n',tetra');
fprintf(fileID,'%d %d %d\n',tria');
fprintf(fileID,'%s\n','</DataArray>');
fprintf(fileID,'%s\n','<DataArray  type="UInt32"  Name="offsets"  format="ascii">');
fprintf(fileID,'%d\n',cell_ID1');
fprintf(fileID,'%d\n',cell_ID2');
fprintf(fileID,'%s\n','</DataArray>');
fprintf(fileID,'%s\n','<DataArray  type="UInt8"  Name="types"  format="ascii">');
fprintf(fileID,'%d\n',cell_type1');
fprintf(fileID,'%d\n',cell_type2');
fprintf(fileID,'%s\n','</DataArray>');
fprintf(fileID,'%s\n','</Cells>');
name1 = 'Scalars="Node Volume [m$^3$]"';
name2 = 'Vectors=""';
name3 = 'Tensor=""';
fprintf(fileID,'%s\n','<PointData ',name1,' ',name2,' ',name3,'>');
fprintf(fileID,'%s\n','<DataArray  type="Float64"  Name="Node Volume [m$^3$]"  NumberOfComponents="1" format="ascii">');
fprintf(fileID,'%f\n',squeeze(nodevol(:,1))');
fprintf(fileID,'%s\n','</DataArray>');
fprintf(fileID,'%s\n','<DataArray  type="Float64"  Name="ID nodes[#]"  NumberOfComponents="1" format="ascii">');
fprintf(fileID,'%f\n',squeeze(ID_nodes(:,1))');
fprintf(fileID,'%s\n','</DataArray>');
fprintf(fileID,'%s\n','<DataArray  type="Float64"  Name="Phs unwrap"  NumberOfComponents="1" format="ascii">');
fprintf(fileID,'%f\n',squeeze(point_data(:,1))');
fprintf(fileID,'%s\n','</DataArray>');
fprintf(fileID,'%s\n','</PointData>');
fprintf(fileID,'%s\n','</Piece>');
fprintf(fileID,'%s\n','</UnstructuredGrid>');
fprintf(fileID,'%s\n','</VTKFile>');
disp('File ready!')
end

