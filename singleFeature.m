O = imread('data/paloTest/with/l2nr001.tif');
I = rgb2gray(O);


BW = 1 - imbinarize(I);

imshow(BW);
 SE1 = strel('disk', 10);
        SE2 = strel('disk', 6);
        E = imopen(BW, SE1);
        E = BW - E;
        E = imopen(E, SE2);
        figure; imshow(E);

CC = bwconncomp(BW);
Props = regionprops(CC, 'Area', 'Centroid', 'Extent', 'Eccentricity', 'Solidity');
[A , leaf] = max([Props.Area]);

Centroid = Props(leaf).Centroid;
posx = Centroid(1);
posy = Centroid(2);

line([posy-20,posy+20], [posx, posx]);
line([posy, posy], [posx-20,posx+20]);