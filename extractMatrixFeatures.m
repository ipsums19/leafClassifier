function [setFeatures] = extractMatrixFeatures(imgData)
    
    nFiles = length(imgData.Files);
    nFeatures = 2;
    
    setFeatures = zeros(nFiles , nFeatures);
    
    for i = 1:nFiles
        data = readimage(imgData,i);
        I = rgb2gray(data);
        
        %Testing Extract features
        BW = I > 180;
        SE = strel('disk', 10);
        BW = imopen(BW, SE);
        BW = ~BW;
        CC = bwconncomp(BW);
        Props = regionprops(CC,  'Solidity', 'EulerNumber' );
        X = cell2mat(struct2cell(Props))';
        
        % features
        setFeatures(i, :) = X(1, :)';
    end
    
    
end