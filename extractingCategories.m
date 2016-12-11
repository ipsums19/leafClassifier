I = rgb2gray(imread('l5nr001.tif'));
BW = I < 180;
SE1 = strel('disk', 10);
SE2 = strel('disk', 6);
E = imopen(BW, SE1);
E = BW - E;
E = imopen(E, SE2);
su = sum(sum(E));
imshow(E);
