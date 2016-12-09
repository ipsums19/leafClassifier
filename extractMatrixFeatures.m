function [setFeatures] = extractMatrixFeatures(imgData)
    
    nFiles = length(imgData.Files);
    nFeatures = 1024 + 512;
    
    setFeatures = zeros(nFiles , nFeatures);
    
    for i = 1:nFiles
        % Image Info
        data = readimage(imgData,i);
        I = rgb2gray(data);
        [height, width] = size(I);
        ratio = height / width;
        
        % cumulated h     
        h = 1024;
        w = h / ratio;
        Itmp = imresize(I, [h w]);
        BW = Itmp < 180;
        setFeatures(i, 1:1024) = sum(BW, 2)';
        
        % cumulated v    
        w = 512;
        h = w * ratio;
        Itmp = imresize(I, [h w]);
        BW = Itmp < 180;
        setFeatures(i, 1025:nFeatures) = sum(BW)';
        
        %        
        
    end
    
    
end