% Display different views of the 3D data
%
% Based on the code by Bilgic Berkin at http://martinos.org/~berkin/software.html
% Modified by Carlos Milovic in 2017.03.30
% Last modified by Tabita Catalan in 2020.01.22

function [  ] = imagesc3d2( img, pos, fig_num, rot_deg, scale_fig, avg_size, title_fig, MIP, axis_square )
%
% input:
% img - 3D data to be displayed
% pos - vector defining the point at the center of the three projection planes.
% fig_num -figure number
% rot_deg - rotation of each subfigure
% scale_fig - data range to be displayed (black and white points).
% avg_size - downsample factor in voxels (0 to avoid subsampling)
% title_fig - title
% MIP - Minimum Intensity Proyection (0 disabled)
% axis_square - subfigure proportions. 1 to force square display.
%

if norm(imag(img(:))) > 0
    img = abs(img);
end

if nargin < 2
    pos = round(size(img)/2);
end

if nargin < 3
    fig_num = 1;
end

if nargin < 4
    rot_deg = [0,0,0];
end

if nargin < 5
    scale_fig = [min(img(:)), max(img(:))];
end

if nargin < 6
    avg_size = 0;
end

if nargin < 7
    title_fig = '';
end

if nargin < 8
    MIP = 0;
end

if nargin < 9
    axis_square = 0;
end

Lavg_size = 0;
Ravg_size = 0;

if avg_size > 0
    if mod(avg_size,2)
        % odd
        Lavg_size = (avg_size-1)/2;
        Ravg_size = (avg_size-1)/2;
    else
        % even
        Lavg_size = (avg_size / 2) - 1;
        Ravg_size = (avg_size / 2);
    end
end

figure(fig_num)
if ~MIP
    if axis_square
        figure(fig_num), subplot(131), imagesc( imrotate(squeeze(mean(img(pos(1)-Lavg_size:pos(1)+Ravg_size,:,:),1)), rot_deg(1)), scale_fig ), axis square off, colormap gray
        figure(fig_num), subplot(132), imagesc( imrotate(squeeze(mean(img(:,pos(2)-Lavg_size:pos(2)+Ravg_size,:),2)), rot_deg(2)), scale_fig ), axis square off, colormap gray
        figure(fig_num), subplot(133), imagesc( imrotate(squeeze(mean(img(:,:,pos(3)-Lavg_size:pos(3)+Ravg_size),3), rot_deg(3))), scale_fig ), axis square off, colormap gray
    else
        figure(fig_num), subplot(131), imagesc( imrotate(squeeze(mean(img(pos(1)-Lavg_size:pos(1)+Ravg_size,:,:),1)), rot_deg(1)), scale_fig ), axis image off, colormap gray
        figure(fig_num), subplot(132), imagesc( imrotate(squeeze(mean(img(:,pos(2)-Lavg_size:pos(2)+Ravg_size,:),2)), rot_deg(2)), scale_fig ), axis image off, colormap gray
        figure(fig_num), subplot(133), imagesc( imrotate(squeeze(mean(img(:,:,pos(3)-Lavg_size:pos(3)+Ravg_size),3)), rot_deg(3)), scale_fig ), axis image off, colormap gray
    end
else
    if axis_square
        figure(fig_num), subplot(131), imagesc( imrotate(squeeze(min(img(pos(1)-Lavg_size:pos(1)+Ravg_size,:,:),[],1)), rot_deg(1)), scale_fig ), axis square off, colormap gray
        figure(fig_num), subplot(132), imagesc( imrotate(squeeze(min(img(:,pos(2)-Lavg_size:pos(2)+Ravg_size,:),[],2)), rot_deg(2)), scale_fig ), axis square off, colormap gray
        figure(fig_num), subplot(133), imagesc( imrotate(squeeze(min(img(:,:,pos(3)-Lavg_size:pos(3)+Ravg_size),[],3), rot_deg(3))), scale_fig ), axis square off, colormap gray    
    else
        figure(fig_num), subplot(131), imagesc( imrotate(squeeze(min(img(pos(1)-Lavg_size:pos(1)+Ravg_size,:,:),[],1)), rot_deg(1)), scale_fig ), axis image off, colormap gray
        figure(fig_num), subplot(132), imagesc( imrotate(squeeze(min(img(:,pos(2)-Lavg_size:pos(2)+Ravg_size,:),[],2)), rot_deg(2)), scale_fig ), axis image off, colormap gray
        figure(fig_num), subplot(133), imagesc( imrotate(squeeze(min(img(:,:,pos(3)-Lavg_size:pos(3)+Ravg_size),[],3), rot_deg(3))), scale_fig ), axis image off, colormap gray    
    end
end
% color bar
hp3 = get(subplot(1,3,3),'Position');
colorbar('Position', [hp3(1)+hp3(3)+0.01  hp3(2)  0.1*hp3(3)  hp3(4)])
caxis(scale_fig)
% common title
a = axes;
t1 = title(title_fig, 'color', 'w', 'fontsize', 24);
a.Visible = 'off'; % set(a,'Visible','off');
t1.Visible = 'on'; % set(t1,'Visible','on');
plot([],[])
set(gcf, 'color', 'k')
end

