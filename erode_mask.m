function eroded_mask = erode_mask(mask, peel)
eroded_mask = mask;
for i = 1:peel
    eroded_mask = simple_erode_mask(eroded_mask);
end
end

