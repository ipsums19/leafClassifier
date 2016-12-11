function [setFeatures] = extractMatrixFeatures(imgData)
    
    nFiles = length(imgData.Files);
    nFeatures = [1024 512 1];
    setFeatures = zeros(nFiles , sum(nFeatures));
    
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
        setFeatures(i, 1:nFeatures(1)) = sum(BW, 2)';
        
        % cumulated v    
        w = 512;
        h = w * ratio;
        Itmp = imresize(I, [h w]);
        BW = Itmp < 180;
        setFeatures(i, (nFeatures(1)+1):nFeatures(2)) = sum(BW)';
        
        % stem
        SE1 = strel('disk', 10);
        SE2 = strel('disk', 6);
        E = imopen(BW, SE1);
        E = BW - E;
        E = imopen(E, SE2);
        setFeatures(i, (nFeatures(2)+1):nFeatures(3)) = sum(sum(E));

    end  
end