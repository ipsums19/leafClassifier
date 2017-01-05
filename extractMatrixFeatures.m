function [setFeatures] = extractMatrixFeatures(imgData)
    
    nFiles = length(imgData.Files);
    nFeatures = [1024 512 1 1 1 1 1 1 1 1 1];
    setFeatures = zeros(nFiles , sum(nFeatures));
    
    for i = 1:nFiles
        % Image Info
        data = readimage(imgData,i);
        I = rgb2gray(data);
        BW = I < 180;
        [height, width] = size(I);
        ratio = height / width;
        
        % cumulated h     
        h = 1024;
        w = h / ratio;
        Itmp = imresize(BW, [h w]);
        setFeatures(i, 1:nFeatures(1)) = sum(Itmp, 2)';
        
        % cumulated v    
        w = 512;
        h = w * ratio;
        Itmp = imresize(BW, [h w]);
        setFeatures(i, (sum(nFeatures(1:1))+1):sum(nFeatures(1:2))) = sum(Itmp)';
        
        %stem
        BW = imresize(BW, [h w]);
        SE1 = strel('disk', 10);
        ILeaf = imopen(BW, SE1);
        ILeaf = bwareafilt(ILeaf, 1);
        IStem = bwareafilt(logical(BW-ILeaf), 1); 

        %'Eccentricity', 'Solidity', 'Extent'                
        CC = bwconncomp(ILeaf);
        P = regionprops(CC, 'Area', 'Extent', 'Eccentricity', 'Solidity');
        setFeatures(i, sum(nFeatures(1:3))) = P.Area;
        setFeatures(i, sum(nFeatures(1:4))) = P.Extent;
        setFeatures(i, sum(nFeatures(1:5))) = P.Eccentricity;
        setFeatures(i, sum(nFeatures(1:6))) = P.Solidity;  
        
        CC = bwconncomp(IStem);
        P = regionprops(CC, 'Area', 'Extent', 'Eccentricity', 'Solidity');
        setFeatures(i, sum(nFeatures(1:7))) = P.Area;
        setFeatures(i, sum(nFeatures(1:8))) = P.Extent;
        setFeatures(i, sum(nFeatures(1:9))) = P.Eccentricity; 
        setFeatures(i, sum(nFeatures(1:10))) = P.Solidity;  
        
    end  
end