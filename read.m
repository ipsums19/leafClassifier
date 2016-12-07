cd leaf5
imagefiles = dir('*.tif');
leaf5size = length(imagefiles);
I = rgb2gray(imread(imagefiles(1).name));
%imshow(I);
BW = I < 180;
imshow(BW);
figure;
imshow(I);
cd ..