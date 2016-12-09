% create repo of images
categories = {'with', 'without', 'maybe'};
imds = imageDatastore(fullfile('data/testData' , categories), 'LabelSource', 'foldernames');

tbl = countEachLabel(imds);
[trainingSet, validationSet] = splitEachLabel(imds, 0.3, 'randomize');

% vag of features
%bag = bagOfFeatures(imds, 'Verbose', false);
    
dataTrain = extractMatrixFeatures(trainingSet);
t = fitctree(dataTrain, cellstr(trainingSet.Labels));
%t = fitctree(data, cellstr(trainingSet.Labels),'PredictorNames',{'SL' 'SW' });

dataValid = extractMatrixFeatures(validationSet);

result = predict(t, dataValid);

% simple accurracy

validResult = cellstr(validationSet.Labels);
hits = sum (strcmp(result, validResult));
hits / length(validResult)

