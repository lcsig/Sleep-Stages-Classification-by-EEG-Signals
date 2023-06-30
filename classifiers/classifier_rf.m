load('featureMat.mat', 'featureMatrix');

X = featureMatrix(:, 1:(end - 1));
Y = featureMatrix(:, end);
X(isnan(X))=0;
X(isinf(X))=0;

k = (Y == 7);
X(k, :) = [];
Y(k, :) = [];

% Use MATLAB workers and allocate confusion matrix 
options = statset('UseParallel',true);
confusionMat = zeros(numel(unique(Y)), numel(unique(Y)));

tics = tic;
for fold=1:10
        
    % Cross varidation (train: 90%, test: 10%)
    cv = cvpartition(size(X,1), 'HoldOut', 0.1);
    idx = cv.test;
    
    % Separate to training and test data
    trainLabel = Y(~idx);
    trainData = X(~idx, :);
    testLabel = Y(idx);
    testData = X(idx,:);

    %Strart training
    Mdl = TreeBagger(300, trainData, trainLabel, ...
        'Method', 'Classification', ...
        'MinLeafSize', 1, ...
        'PredictorSelection', 'interaction-curvature', ...); 
        'Options', options); 
    
        
    % String Predicting 
    yfit = Mdl.predict(testData);
    yfit = cellfun(@str2double, yfit);

   
    % Confusion matrix and accuracy calculations
    for i=1:numel(testLabel)
        confusionMat(testLabel(i), yfit(i)) = confusionMat(testLabel(i), yfit(i)) + 1;
    end
    
    accuracy = sum(yfit == testLabel);
    acc(fold) = accuracy / size(testLabel, 1);
end

confusionchart(confusionMat, {'NREM1', 'NREM2', 'NREM3', 'NREM4', 'REM', 'WAKE'});

recall = diag(confusionMat) ./ sum(confusionMat,2);
precision = diag(confusionMat) ./ sum(confusionMat,1)';
F1 = (2 .* precision .* recall) ./ (precision + recall);

labelsDisp = {'Precision', 'Recall', 'F1_Score' };
detMat = [ precision, recall, F1 ];
detMat = cell2table(num2cell(detMat));
detMat.Row = {'NREM1', 'NREM2', 'NREM3', 'NREM4', 'REM', 'WAKE'};
detMat.Properties.VariableNames = labelsDisp;
detMat.Variables = round(detMat.Variables, 4);

disp(strcat("Accuracy : ", num2str(mean(acc))));
disp(detMat);
disp(confusionMat);
toc(tics);