close all
I = rgb2gray(imread('data/leaf1/l1nr045.tif'));
imshow(I);
BW = I < 180;
%F = imfill(BW, 'holes');
%imshow(BW);

% erocionamos
SE = strel('disk', 100);
E = imopen(BW, SE);

% contar dientes
IM = BW - E; figure; %imshow(IM);
SE = strel('disk', 2);
IM = imerode(IM, SE); %imshow(IM);
%IM = bwmorph(IM, 'clean'); figure; imshow(IM);
C = bwconncomp(IM);
numObjects = C.NumObjects
%imshow(E);
%figure;
%imshow(I);