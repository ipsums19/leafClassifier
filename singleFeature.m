%read image
O = imread('data/leaf15/l15nr017.tif');
I = imresize(rgb2gray(O), 1);
% binarization
BW = I > 180;
[rows, cols] = size(BW);

% get shape
BW = bwmorph(BW, 'remove') ;
% remove margin shape
mg = 10;
BW(1:mg, :) = 0;
BW((rows-mg):rows, :) = 0;
BW(:, 1:mg) = 0;
BW(:, (cols-mg):cols) = 0;
% get leaf shape
BW = bwareafilt(BW, 1);
% get props
CC = bwconncomp(BW);
P = regionprops(CC, 'area', 'BoundingBox');
BB = P.BoundingBox;

imshow(BW);
rectangle('Position', [BB(1),BB(2),BB(3),BB(4)], 'EdgeColor','r','LineWidth',2 );

% starting position
posx = int16(BB(2));
[ x, posy] = max(BW(posx, :)) ;
line([posy-20,posy+20], [posx, posx]);
line([posy, posy], [posx-20,posx+20]);
BW(posx:(posx+10), (posy-1)) = 0;
BW(posx, posy) = 0;
% lists of point
V = BW; 
imshow(V);
listTest = zeros(P.Area, 2);
import java.util.LinkedList
q = LinkedList();
q.add(posx);
q.add(posy);
i = 1;
while  ~ q.isEmpty()
    px = q.remove();
    py = q.remove();   
    listTest(i, 1) = px;
    listTest(i, 2) = py;
    i = i+1 ;
    % harcode neightbours 
    z = [1, 0 ; 1 ,1 ; 0 ,1 ; -1, 0 ; -1 ,-1 ; 0 ,-1 ; 1, -1; -1, 1];
    for j = 1:8
        npx = px + z(j, 1);
        npy = py + z(j, 2);
        if V(npx , npy) > 0
            V(npx, npy) = 0;
            q.add(npx);
            q.add(npy);
        end
    end     
    
end

% list of 1024 point
nPoints = 1024;
offset = P.Area / nPoints;
points = zeros(nPoints,2);
for i = 1:(nPoints)
    indx = int16(i*offset);
    points(i, :) = listTest(indx, :);
end

% normalize
mins = min(points);
maxs = max(points);
points = [ points(:, 2) - mins(2), abs(points(:, 1) - maxs(1))];
maxs = max(points);
points = [points(:, 1)/maxs(1) , points(:, 2)/maxs(2)];

% points
binEdges = logspace(log10(1/2^5),0,5);
% log polar point
for i = 1:nPoints
    point = points(i, :);
    [theta, rho] = cart2pol(points(:, 1)-point(1), points(:, 2)-point(2));
    theta = floor(theta / (pi / 6) + 6) + 1;
    for k = 1:5
        rho(rho < binEdges(k)) = k;
    end    
	accumarray([theta(:), rho(:)], 1);   
end



