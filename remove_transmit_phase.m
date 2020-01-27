function [phs_corrected, poly_fitted] = remove_transmit_phase(phs_tissue, mask, order)
% 3D polynomial fit to remove transmit phase from LBV
% Input:
% - phase_tissue:
% - order: degree of 3d polyfit

tic
    poly_fitted = polyfit3D_NthOrder(phs_tissue, mask, order);
toc

% subtract fitted phase
phs_corrected = (phs_tissue - poly_fitted ).* mask;
end