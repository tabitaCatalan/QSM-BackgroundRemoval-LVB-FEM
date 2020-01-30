% Quiero saber si la componente removida tiene laplaciano 0
laplacian = del2(removed_poly_FEM);
N = [160 160 160];
%%
imagesc3d2(laplacian.*mask, N/2, 1, [90,90,-90], [-0.0001,0.0001], [], 'laplacian')
%%
imagesc3d2(removed_poly_FEM.*mask, N/2, 2, [90,90,-90], [-0.1,0.1], [], 'removed poly')
%%
