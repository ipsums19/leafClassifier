% create repo of images
categories = genvarname(repmat({'leaf'}, 1, 15), 'leaf');
imds = imageDatastore(fullfile('data/' , categories), 'LabelSource', 'foldernames');
%[imds , ~] = splitEachLabel(imds, 0.3);

tbl = countEachLabel(imds);

K = 10;
sumMean = 0;
confusionMatrix = zeros(15,15);
for i = 1:K
    fprintf('K FOLD : %d \n', i)    
    if i == 1
        [validationSet, trainingSet] = splitEachLabel(imds, (1/K));
    elseif i == K
        [trainingSet, validationSet] = splitEachLabel(imds, (1/K));
    else
        [P1, P2, P3] = splitEachLabel(imds, (i-1) * (1/K),(1/K)); 
        trainingSet = imageDatastore([P1.Files ; P3.Files], 'LabelSource', 'foldernames');
        validationSet = P2;
    end
    disp([num2str(length(trainingSet.Files)) ' images for training']);
    disp([num2str(length(validationSet.Files)) ' images for Validation']);
    disp('extracting features of training set...');
    dataTrain = extractMatrixFeatures(trainingSet);
    
    disp('training model ...');
    t = fitcknn(dataTrain, cellstr(trainingSet.Labels));
    
    disp('extracting features of validation set...');
    dataValid = extractMatrixFeatures(validationSet);
    
    disp('predicting ...');
    result = predict(t, dataValid);
    
    % accurracy and confusion matrix
    validResult = cellstr(validationSet.Labels);
    hits = sum (strcmp(result, validResult));
    accurracy = hits / length(validResult);
    fprintf('acurracy : %1.4f \n', accurracy)
    sumMean = sumMean + accurracy;
    confusionMatrix = confusionMatrix + confusionmat(validResult, result);
end

fprintf('Mean Acurracy : %1.4f \n', sumMean / K)
disp('Confusion Matrix :');
confusionMatrix


