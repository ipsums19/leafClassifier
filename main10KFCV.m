% Create Repo of data
categories = genvarname(repmat({'leaf'}, 1, 15), 'leaf');
imds = imageDatastore(fullfile('data/' , categories), 'LabelSource', 'foldernames');

% extrat all featrues of all images
disp('extracting features of dataset...');
dataFeatures = extractMatrixFeatures(imds);

% reshape to divide the dataset
nFeatures = 1545;
DF = reshape(dataFeatures, [70, 15, nFeatures]);
LB = reshape(cellstr(imds.Labels), [70, 15]); 

% 10 - fold cross validation
sumMean = 0;
confusionMatrix = zeros(15,15);
for i = 1:10
    fprintf('K FOLD : %d \n', i)     
    % divide data in train and validation set, depending of k fold
    if i == 1
        dataTrain = reshape ( DF(8:70, :, :) , [(63*15) nFeatures] );
        dataValid = reshape ( DF(1:7, :, :) , [(7*15) nFeatures] );
        labelTrain = reshape ( LB(1:63, :) , [(63*15) 1] );
    elseif i == K
        dataTrain = reshape ( DF(1:63, :, :) , [(63*15) nFeatures] );
        dataValid = reshape ( DF(64:70, :, :) , [(7*15) nFeatures] );
        labelTrain = reshape ( LB(1:63, :) , [(63*15) 1] );
    else
        endd = i * 7;
        init = endd + 8;

        dataTrain1 = reshape ( DF(1:endd, :, :) , [(endd*15) nFeatures] );
        dataValid = reshape ( DF((endd+1):(init-1), :, :) , [(7*15) nFeatures] );
        dataTrain3 = reshape ( DF(init:70, :, :) , [((70-endd-7)*15) nFeatures] ); 
        dataTrain = [dataTrain1 ; dataTrain3];

        label1 = reshape ( LB(1:endd, :) , [(endd*15) 1] );
        label3 = reshape ( LB(init:70, :) , [((70-endd-7)*15) 1] );
        labelTrain = [label1 ; label3];
    end    
    
    % Train the model
    disp('training model ...');
    t = TreeBagger(500, dataTrain,labelTrain);   
    %t = fitctree(dataTrain,labelTrain); 
    
    % Predict the validation set
    disp('predicting ...');
    result = predict(t, dataValid);
    
    % calculate the accurracy and confusion matrix
    labelValid = reshape ( LB(1:7, :) , [(7*15) 1] );
    hits = sum (strcmp(result , labelValid));
    accurracy = hits / length(labelValid);
    fprintf('acurracy : %1.4f \n', accurracy)
    sumMean = sumMean + accurracy;
    confusionMatrix = confusionMatrix + confusionmat(labelValid, result);
end

% print the result
fprintf('\nMean Acurracy : %1.4f \n', sumMean / 10)
confusionMatrix


