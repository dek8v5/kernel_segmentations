%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Kernel segmentation for planter plate      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc;
clear;
close all;

img = imread('mosaic_kernel2.png');
img_ori = img;
img = rgb2gray(img);
img = double(img);
img = imgaussfilt(img, 3);

[row, col] = size(img);
Img = reshape(img, [row*col,1]);

rng(2);

segment = kmeans(Img, 2);

segment = reshape(segment, [row, col, 1]);

figure,
subplot(1,2,1)
imshow(segment==1);
title('Img cluster = 1');


subplot(1,2,2)
imshow(segment==2);
title('Img cluster = 2');

mask2 = (segment==1);

imwrite(mask2, 'kernel_segmented.png');

figure,
hold on;
imshow(mask2);
title('Mask');

stats = regionprops('table', mask2,'Centroid','MajorAxisLength','MinorAxisLength');


s = regionprops(mask2, 'Centroid');

hold on
for k = 1:numel(s)
    c = s(k).Centroid;
    text(c(1), c(2), sprintf('%d', k), 'color', 'red', 'fontsize', 7, 'HorizontalAlignment','center','VerticalAlignment', 'middle');
    %text(c(1), c(2), sprintf('*'), 'color', 'red', 'HorizontalAlignment','center','VerticalAlignment', 'middle');
end
hold off

% 1 inches 184 pixels

mask_result = bsxfun(@times,double(img_ori),cast(mask2, 'like', mask2));

imwrite(uint8(mask_result), 'kernel_overlay_mask.png')

writetable(stats, 'stats.csv')
