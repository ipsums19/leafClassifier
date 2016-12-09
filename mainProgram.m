% create repo of images
categories = genvarname(repmat({'leaf'}, 1, 15), 'leaf');
imds = imageDatastore(fullfile('data/' , categories), 'LabelSource', 'foldernames');
tbl = countEachLabel(imds);

[trainingSet, ~] = splitEachLabel(imds, 0.01, 'randomize');
[validationSet, ~] = splitEachLabel(imds, 0.03, 'randomize');

disp([num2str(length(trainingSet.Files)) ' images for training']);
disp([num2str(length(validationSet.Files)) ' images for Validation']);
    
disp('extracting features of training set...');
dataTrain = extractMatrixFeatures(trainingSet);

disp('training model ...');
t = fitctree(dataTrain, cellstr(trainingSet.Labels));
%t = fitctree(data, cellstr(trainingSet.Labels),'PredictorNames',{'SL' 'SW' });

disp('extracting features of validation set...');
dataValid = extractMatrixFeatures(validationSet);

disp('predicting ...');
result = predict(t, dataValid);

% simple accurracy
validResult = cellstr(validationSet.Labels);
hits = sum (strcmp(result, validResult));

fprintf('acurracy : %1.4f \n', hits / length(validResult))


