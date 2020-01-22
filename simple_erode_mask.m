function eroded_mask = simple_erode_mask(mask)
% Erodes a 3D binary matrix by changing ones from the boundary to zeros.
% It consider periodic conditions.
% Input:
% - mask: 3D binary matrix to be eroded.
mask1 = mask([2:end, 1],:,:);
mask2 = mask([end,1:end-1],:,:);
mask3 = mask(:,[2:end, 1],:);
mask4 = mask(:,[end,1:end-1],:);
mask5 = mask(:,:,[2:end, 1]);
mask6 = mask(:,:,[end,1:end-1]);
eroded_mask = ((mask1 + mask2 + mask3 + mask4 + mask5 + mask6)/6 >= 1);
end