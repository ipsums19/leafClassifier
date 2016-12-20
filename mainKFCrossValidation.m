% create repo of images
categories = genvarname(repmat({'leaf'}, 1, 15), 'leaf');
imds = imageDatastore(fullfile('data/' , categories), 'LabelSource', 'foldernames');
%categories = {'with','without','maybe'};
%imds = imageDatastore(fullfile('data/paloTest' , categories), 'LabelSource', 'foldernames');

tbl = countEachLabel(imds);



K = 5;
sumMean = 0;
confusionMatrix = zeros(15,15);
for i = 1:K
    fprintf('K FOLD : %d \n', i)
    [validationSet, trainingSet] = splitEachLabel(imds, (1/K), 'randomize');
    disp([num2str(length(trainingSet.Files)) ' images for training']);
    disp([num2str(length(validationSet.Files)) ' images for Validation']);
    disp('extracting features of training set...');
    dataTrain = extractMatrixFeatures(trainingSet);
    
    disp('training model ...');
    t = fitctree(dataTrain, cellstr(trainingSet.Labels));
    
    disp('extracting features of validation set...');
    dataValid = extractMatrixFeatures(validationSet);
    
    disp('predicting ...');
    result = predict(t, dataValid);
    
    % accurracyand confusion matrix
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


