close all
I = rgb2gray(imread('data/leaf1/l1nr011.tif'));
%imshow(I);
BW = I < 180;
BW = imfill(BW, 'holes');
[height, width] = size(BW);
ratio = height / width;
h = 1024;
w = 514;
R = imresize(BW, [h w]);

mid = w/2;
mid1 = sum(sum(R(:,1:mid)));
mid2 = sum(sum(R(:,mid:w)));
diff = abs(mid1 - mid2);
imshow(R(:,mid:w));
%imshow(BW);