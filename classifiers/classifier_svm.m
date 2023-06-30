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

cLevel = 16; % 8:2:16;
gLevel = -16; % [-20, -18, -16, 3, 5, 6];
tics = tic;

for cc=cLevel
    for gg=gLevel
        fprintf("C: %d, G: %d\n", cc, gg);

        
    confusionMat = zeros(numel(unique(Y)), numel(unique(Y)));
        
    for fold=1:5

        % Cross varidation (train: 90%, test: 10%)
        cv = cvpartition(size(X,1), 'HoldOut', 0.2);
        idx = cv.test;

        % Separate to training and test data
        trainLabel = Y(~idx);
        trainData = X(~idx, :);
        testLabel = Y(idx);
        testData = X(idx,:);


        normVal = [0, 1];
        isDataNormalized = 0;
        if ~isDataNormalized
            for i=1:size(trainData, 2)
                col1 = trainData(:, i);
                col2 = testData(:, i);

                maxi = max(col1);
                mini = min(col1);

                if maxi == mini
                    trainData(:, i) = 0;
                    testData(:, i) = 0;
                else   
                    newCol = (normVal(2) - normVal(1)) * (col1 - mini) /  (maxi - mini);
                    newCol = newCol + normVal(1);
                    trainData(:, i) = newCol;

                    newCol = (normVal(2) - normVal(1)) * (col2 - mini) /  (maxi - mini);
                    newCol = newCol + normVal(1);
                    testData(:, i) = newCol;
                end
            end
        end


        template = templateSVM('KernelFunction', 'Gaussian',...
            'BoxConstraint', 2^(cc), ...
            'KernelScale', sqrt(1/(2^ (gg) )), ...
            'Solver', 'SMO', ...
            'standardize', false);

        %pool = parpool; % Invoke workers
        options = statset('UseParallel',true);

        Mdl = fitcecoc(trainData, trainLabel, ...
            'Coding', 'onevsone', ...
            'Learners', template,...
            'Prior', 'uniform', ...
            'Options', options);


        % String Predicting
        yfit = Mdl.predict(testData);


        % Confusion matrix and accuracy calculations
        for i=1:numel(testLabel)
            confusionMat(testLabel(i), yfit(i)) = confusionMat(testLabel(i), yfit(i)) + 1;
        end

        accuracy = sum(yfit == testLabel);
        acc(fold) = accuracy / size(testLabel, 1);
    end
    disp(strcat("Accuracy : ", num2str(mean(acc))));

    end
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