function  hist_surface_area(nodes,faces, bins)
% Plot an histogram of the areas of the faces of a mesh. It doesn't create
% a new figure.
% Input:
% - nodes: node coordinates of a tetrahedral mesh, 3 columns (x,y,x)
% - faces: triangle node indices, each row is a triangle
% - bins: number of bins, or array with intervales (see histfit function)

area = surface_area(nodes, faces);

h = histfit(area,bins);
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
ax.XLabel.String = 'Area [mm^{2}]';

g = get(h(2));
xdata = g.XData';
ydata = g.YData';
[C,I] = max(ydata);
txt1 = ['\leftarrow ', num2str(xdata(I))];
t = text(xdata(I),max(ydata),txt1);
t.Color = 'red';
t.FontWeight = 'bold';
t.FontSize = 12;
end

