dirPath = './data';
fileNames = dir(dirPath);
window = 100 * 30;
neededSig = 1;
alphaRange = [8, 13];
betaRange = [12, 30]; 
thetaRange = [4, 8]; 
deltaRange = [0.5, 2];
spiRange = [12, 14];
sawRange = [2, 6];
fs = 100;
featureMatrix = [];

for i=3:(length(fileNames))
    fprintf("[+] File #%d\n", i - 2);

    % Read the Data
    [~, d] = edfread(fileNames(i).name);
    
    % Get the Window
    sig = d(neededSig, :);
    
    % Bandpass Filter 
    alphaSig = bandpass(d(neededSig, :), alphaRange, fs);
    betaSig = bandpass(d(neededSig, :), betaRange, fs);
    thetaSig = bandpass(d(neededSig, :), thetaRange, fs);
    deltaSig = bandpass(d(neededSig, :), deltaRange, fs);
    spiSig = bandpass(d(neededSig, :), spiRange, fs);
    sawSig = bandpass(d(neededSig, :), sawRange, fs);
    
    
   for n=1:window:(size(d, 2))
        fprintf('[+] Second : %d\n', ceil(n / fs));
        
        % Get the label 
        label = getLabel('./hypno/', fileNames(i).name(3:6), ceil(n / fs)); 
        if label == 7 % "Not Scored" 
            break; 
        end

        % Features Extraction
        sigFeat = feature_extraction(diff(sig(n:(n+window - 1))));
        alphaFeat = feature_extraction(diff(alphaSig(n:(n+window - 1))));
        betaFeat = feature_extraction(diff(betaSig(n:(n+window - 1))));
        thetaFeat = feature_extraction(diff(thetaSig(n:(n+window - 1))));
        deltaFeat = feature_extraction(diff(deltaSig(n:(n+window - 1))));
        spiFeat = feature_extraction(diff(spiSig(n:(n+window - 1))));
        sawFeat = feature_extraction(diff(sawSig(n:(n+window - 1))));
        featureRow = [sigFeat, alphaFeat, betaFeat, thetaFeat, deltaFeat, spiFeat, sawFeat];
                
        % Combine the label with the feature 
        featureRow = [featureRow, label];
        featureMatrix = [featureMatrix; featureRow]; 
   end
end

% Save the data to load it later
save('featureMat.mat', 'featureMatrix');