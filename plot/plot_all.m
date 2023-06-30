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

for i=1:(length(fileNames) - 2)
   fprintf("File No %d\n", i);
   
   % Read the data
   [h, d] = edfread(fileNames(i + 2).name);
   
   for n=6001:window:size(d, 2)
        % Get the window
        sig = d(neededSig, n:(n+window));

        % Bandpass filter 
        alphaSig = bandpass(sig, alphaRange, fs);
        betaSig = bandpass(sig, betaRange, fs);
        thetaSig = bandpass(sig, thetaRange, fs);
        deltaSig = bandpass(sig, deltaRange, fs);
        spiSig = bandpass(sig, spiRange, fs);
        sawSig = bandpass(sig, sawRange, fs);
        
        % Plot All 
        plot(0:0.01:30, [sig', alphaSig', betaSig', thetaSig', deltaSig', spiSig', sawSig']);
        legend('Orginal Signal', 'Alpha Sig', 'Beta Signal', 'Theta Signal', 'Delta Signal', 'Spiha Signal', 'Saw Signal')
        xlabel('Time [s]');
        ylabel('EEG Singal');
        break;
   end
   
   break;
end
