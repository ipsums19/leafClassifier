%read image
O = imread('data/leaf1/l1nr017.tif');
I = imresize(rgb2gray(O), 1);
BW = I < 180;

CS = contextShape(BW);

% SE1 = strel('disk', 10);
% E = imopen(BW, SE1);
% E = bwareafilt(E, 1);
% Palito = bwareafilt(logical(BW-E), 1);
% imshow(E);

        
%         % serrated edge
%         SE = strel('disk', 100);
%         E = imopen(BW, SE);
%         IM = BW - E;
%         SE = strel('disk', 2);
%         IM = imerode(IM, SE);
%         IM = bwmorph(IM, 'clean');
%         C = bwconncomp(IM);
%         setFeatures(i, (sum(nFeatures(1:3))+1):sum(nFeatures(1:4))) = C.NumObjects;

        % simmetry
%         BW = imfill(BW, 'holes');
%         h = 1024;
%         w = 514;
%         R = imresize(BW, [h w]);
% 
%         mid = h/2;
%         mid1 = sum(sum(R(1:mid,:)));
%         mid2 = sum(sum(R(mid:h,:)));
%         diff = abs(mid1 - mid2);
%         setFeatures(i, (sum(nFeatures(1:3))+1):sum(nFeatures(1:4))) = diff;
%         
%         mid = w/2;
%         mid1 = sum(sum(R(:,1:mid)));
%         mid2 = sum(sum(R(:,mid:w)));
%         diff = abs(mid1 - mid2);
%         setFeatures(i, (sum(nFeatures(1:4))+1):sum(nFeatures(1:5))) = diff;


