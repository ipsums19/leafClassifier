
function [pointsCS] = contextShape(BW)
    
    % Size of the image
    [rows, cols] = size(BW);

    % Get shape using morph
    BW = bwmorph(BW, 'remove') ;
    % Rremove margin in the image
    mg = 10;
    BW(1:mg, :) = 0;
    BW((rows-mg):rows, :) = 0;
    BW(:, 1:mg) = 0;
    BW(:, (cols-mg):cols) = 0;
    % Get only the leaf shape
    BW = bwareafilt(BW, 1);
    % Get properties of the shape
    CC = bwconncomp(BW);
    P = regionprops(CC, 'Area', 'BoundingBox');
    BB = P.BoundingBox;
    
    % Get the initial point, it would be for all images the same
    % we take the top an centered point of the shape
    posx = int16(BB(2));
    [ x, posy] = max(BW(posx, :)) ;
    % cut the shape to in the future loop the shape in the same way allways
    BW(posx:(posx+10), (posy-1)) = 0;
    BW(posx, posy) = 0;
    
    % Create an ordered list of points of the shape
    import java.util.LinkedList
    Visited = BW; 
    orderedList = zeros(P.Area, 2);
    Queue = LinkedList();
    Queue.add(posx);
    Queue.add(posy);
    i = 1;
    while  ~ Queue.isEmpty()
        % Take first element and save it in the orderd list
        px = Queue.remove();
        py = Queue.remove();   
        orderedList(i, 1) = px;
        orderedList(i, 2) = py;
        i = i+1 ;
        % Loop the pixels of the shape of the leaf, trough the neighbours
        z = [1, 0 ; 1 ,1 ; 0 ,1 ; -1, 0 ; -1 ,-1 ; 0 ,-1 ; 1, -1; -1, 1];
        for j = 1:8
            npx = px + z(j, 1);
            npy = py + z(j, 2);
            if Visited(npx , npy) > 0
                Visited(npx, npy) = 0;
                Queue.add(npx);
                Queue.add(npy);
            end
        end     

    end

    % Take only 1024 points of the shape
    nPoints = 1024;
    offset = P.Area / nPoints;
    points = zeros(nPoints,2);
    for i = 1:(nPoints)
        indx = int16(i*offset);
        points(i, :) = orderedList(indx, :);
    end

    % changes the origin and y axis coords
    mins = min(points);
    maxs = max(points);
    points = [ points(:, 2) - mins(2), abs(points(:, 1) - maxs(1))];
    
    % Normalize
    maxLenght = max( sqrt(points(:,1).^2 + points(:, 2).^2));
    points = points / maxLenght;

    % log polar point
    binEdges = logspace(log10(1/2^5),0,5);
    pointsCS = zeros (1024, 12*5);    
    
    for i = 1:nPoints
        point = points(i, :);
        % pints to polar coords
        [theta, rho] = cart2pol(points(:, 1)-point(1), points(:, 2)-point(2));     
        
        % points in 1 to 12 angle sectors
        theta = ceil((theta / (pi / 6)) + 6);
        theta(theta < 1) = 1;
        
        % points in 1 to 6 distance sectors. (6 out of context)
        rho(rho > 1) = 6;
        for k = 1:5
            rho(rho <= binEdges(k)) = k;
        end 
        
        context = zeros(12, 6);
        for k = 1:nPoints
            context(theta(k), rho(k)) = context(theta(k), rho(k)) + 1;
        end
        % remove the point out of range
        context = context(1:12, 1:5);
        pointsCS(i, :) = context(:)';
    end
end
    
%      if theta(k) < 1
%      XX = 1;
%       else
%      XX = theta(k);
%     end
%                 
%     if rho(k) < 1
%     YY = 1;
%      else
%     YY = rho(k);
%     end
%   setFeatures(ind, (sum(nFeatures(1:11))+1):(sum(nFeatures(1:12))) ) = pointsCS(:)';

