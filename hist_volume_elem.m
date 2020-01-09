function hist_volume_elem(nodes,elems, bins)
% Plot an histogram of the volumes of the elements of a mesh. It doesn't create
% a new figure.
% Input:
% - nodes: node coordinates of a tetrahedral mesh, 3 columns (x,y,x)
% - faces: triangle node indices, each row is a triangle
% - bins: number of bins, or array with intervales (see histfit function)

elem_volume = elemvolume(nodes(:,1:3),elems);    

h = histfit(elem_volume,bins);
axis square
ax = gca;
ax.XColor = 'k';
ax.YColor = 'k';
ax.FontWeight = 'bold';
ax.FontSize = 12;
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridColor = 'k';
ax.YLabel.String = 'Frequency';
ax.XLabel.String = 'Volume [mm^{3}]';

g = get(h(2));
xdata = g.XData';
ydata = g.YData';
[C,I] = max(ydata);
txt1 = ['\leftarrow ', num2str(xdata(I)),' [mm^{3}]'];
t = text(xdata(I),max(ydata),txt1);
t.Color = 'red';
t.FontWeight = 'bold';
t.FontSize = 12;
end

