function faces = get_mesh_faces(elems)
n = size(elems, 1);
faces = zeros(n*4, 3);
for i = 1:n
    faces((i-1)*4+1:i*4,:) = sort(nchoosek(elems(i,:), 3),2);
end
faces = unique(faces, 'row');
end