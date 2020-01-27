function chi_tkd = TKD(thre_tkd, N, kernel, phs_tissue, mask)
% Input:
% - TKD threshold parameter
% - N:
% - kernel
% - phs_tissue

kernel_inv = zeros(N);
kernel_inv( abs(kernel) > thre_tkd ) = 1 ./ kernel(abs(kernel) > thre_tkd);

chi_tkd = real( ifftn( fftn(phs_tissue) .* kernel_inv ) ) .* mask; 
end