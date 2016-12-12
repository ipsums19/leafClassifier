close all
I = rgb2gray(imread('data/leaf1/l1nr011.tif'));
%imshow(I);
BW = I < 180;
CC = bwconncomp(BW);
Props = regionprops(CC, 'Area', 'Extent', 'Eccentricity', 'Solidity');
X = cell2mat(struct2cell(Props))';
[x y] = max(X(:,1));
%imshow(R();
%imshow(BW);