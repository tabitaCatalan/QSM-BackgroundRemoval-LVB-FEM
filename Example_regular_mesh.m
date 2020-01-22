clc
close all 
clear
addpath('data/')

tic
load msk.mat
load phs_unwrap.mat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% metodo que programe usando un cubo de referencia obtenido con 
% delaunayTriangulation
% aca genere una grilla completa de elementos tetrahedricos
% regulares, 6 elementos cada 8 nodos vecinos (ver grilla de referencia)

% msk = ones(2,3,4);
% msk(1,1,1) = 0;
% msk(2,1,1) = 0;
% msk(2,1,2) = 0;
% msk(2,3,4) = 0;
SEG = msk;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% connectividad inicial de la matriz completa
[x,y,z] = meshgrid(0:size(SEG,1)-1,0:size(SEG,2)-1,0:size(SEG,3)-1); % grid of a cube
nodes = [x(:),y(:),z(:)];
points_id = (1:size(x(:),1))';
points_id_m = reshape(points_id,[size(x,1) size(x,2) size(x,3)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m1 = points_id_m(1:size(x,1)-1,1:size(x,2)-1,1:size(x,3)-1);
m2 = points_id_m(1:size(x,1)-1,1:size(x,2)-1,1:size(x,3)-1) + 1;
m3 = points_id_m(1:size(x,1)-1,1:size(x,2)-1,1:size(x,3)-1) + points_id_m(end,1,1);
m4 = points_id_m(1:size(x,1)-1,1:size(x,2)-1,1:size(x,3)-1) + points_id_m(end,1,1) + 1;
m5 = points_id_m(1:size(x,1)-1,1:size(x,2)-1,1:size(x,3)-1) + max(max(points_id_m(:,:,1)));
m6 = points_id_m(1:size(x,1)-1,1:size(x,2)-1,1:size(x,3)-1) + max(max(points_id_m(:,:,1))) + 1;
m7 = points_id_m(1:size(x,1)-1,1:size(x,2)-1,1:size(x,3)-1) + max(max(points_id_m(:,:,1))) + points_id_m(end,1,1);
m8 = points_id_m(1:size(x,1)-1,1:size(x,2)-1,1:size(x,3)-1) + max(max(points_id_m(:,:,1))) + points_id_m(end,1,1) + 1;
conn_ini = [m1(:),m2(:),m3(:),m4(:),m5(:),m6(:),m7(:),m8(:)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%esta linea es mia
SEG = permute(SEG, [2,1,3]);

SS = SEG(:);
s1 = SS(conn_ini(:,1));
s2 = SS(conn_ini(:,2));
s3 = SS(conn_ini(:,3));
s4 = SS(conn_ini(:,4));
s5 = SS(conn_ini(:,5));
s6 = SS(conn_ini(:,6));
s7 = SS(conn_ini(:,7));
s8 = SS(conn_ini(:,8));
conn_ini_s = [s1(:),s2(:),s3(:),s4(:),s5(:),s6(:),s7(:),s8(:)];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% grilla de referencia 2x2x2 este es el patron que usare para cada conexion
% de 8 nodos
d1 = [0 1];
[x1,y1,z1] = meshgrid(d1,d1,d1); % grid of a cube
points1 = [x1(:),y1(:),z1(:)];
points_id1 = (1:size(x1(:),1))';
points_id1_m = reshape(points_id1,[size(x1,1) size(x1,2) size(x1,3)]);
DT = delaunayTriangulation(points1);
ex_elem = DT.ConnectivityList(:);

% grilla de referencia cada 8 nodos vecinos
%figure,
%tetramesh(DT);
%camorbit(20,0)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cambio de coordenadas con respecto a la referencia
new_elem_con = zeros(size(conn_ini,1),size(ex_elem,1))';
new_elem_con_s = zeros(size(conn_ini,1),size(ex_elem,1))';

for n = 1:size(ex_elem,1)
    new_elem_con(n,:) = conn_ini(:,ex_elem(n))';
    new_elem_con_s(n,:) = conn_ini_s(:,ex_elem(n))';
end

%%
A = reshape(new_elem_con,[size(new_elem_con,1),1,size(new_elem_con,2)]);
%new_elem_con_m = reshape(new_elem_con,[size(DT.ConnectivityList,1),size(DT.ConnectivityList,2),size(new_elem_con,2)]);
new_elem_con_m = reshape(A,[size(DT.ConnectivityList,1),size(DT.ConnectivityList,2),size(new_elem_con,2)]);
new_elem_con_m_s = reshape(reshape(new_elem_con_s,[size(new_elem_con_s,1),1,size(new_elem_con_s,2)]),[size(DT.ConnectivityList,1),size(DT.ConnectivityList,2),size(new_elem_con_s,2)]);
%%   
id_sum = squeeze(sum(sum(new_elem_con_m_s))); % squeeze elimina dimensiones 1
%%
id_e = double(id_sum==(size(new_elem_con_m_s,1)*size(new_elem_con_m_s,2))); % esto me asegura que hayan 8 nodos conectados
% id_e vale 1 en los cubos llenos
%%
new_elem_con_m_new = new_elem_con_m(:,:,id_e==1);
%%
elem = [reshape(squeeze(new_elem_con_m_new(:,1,:)),[size(new_elem_con_m_new,1)*size(new_elem_con_m_new,3),1]),...
        reshape(squeeze(new_elem_con_m_new(:,2,:)),[size(new_elem_con_m_new,1)*size(new_elem_con_m_new,3),1]),...
        reshape(squeeze(new_elem_con_m_new(:,3,:)),[size(new_elem_con_m_new,1)*size(new_elem_con_m_new,3),1]),...
        reshape(squeeze(new_elem_con_m_new(:,4,:)),[size(new_elem_con_m_new,1)*size(new_elem_con_m_new,3),1])];


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% aca reordeno los nodos
%elem_n = elem(:);
%nodes = nodes(unique(elem(:)),:); % Esto es raro...
%elem_sorted = unique(elem(:)); % nodos sin repetir ordenados
%nodes_n_id = (1:size(nodes,1))';
%elem_f = zeros(size(elem_n));
%for n=1:length(elem_sorted)
%    elem_f(elem_n==elem_sorted(n))=n;
%end

[sorted_nodes, ia, ic] = unique(elem);
new_elem = reshape(ic, size(elem));
new_index = 1:size(sorted_nodes,1);
%elem = reshape(elem_f,[size(elem,1),size(elem,2)]);
%%
new_nodes = nodes(sorted_nodes,:);

% reordenar
new_nodes = new_nodes(:,[2,1,3]);

toc
%%
%new_elem=meshreorient(new_nodes,new_elem);

%new_faces = get_mesh_faces(new_elem);
%%
%[new_nodes2,new_faces2]=surfreorient(new_nodes,new_faces);




[X,Y,Z]=meshgrid(1:size(phs_unwrap,1),1:size(phs_unwrap,2),1:size(phs_unwrap,3));
X=double(X);
Y=double(Y);
Z=double(Z);

phs_unwrap_scalar = interp3(X,Y,Z,phs_unwrap,new_nodes(:,1),new_nodes(:,2),new_nodes(:,3),'linear');

tic
save_mesh_to_VTU(new_nodes, new_elem, phs_unwrap_scalar, 'regular_mesh')
toc

%save_mesh_and_data_to_VTU(new_nodes, new_faces, new_elem, phs_unwrap_scalar, 'results/test_mesh')
