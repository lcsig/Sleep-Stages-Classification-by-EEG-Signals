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
        
        % Sub
        subplot(7, 1, 1);
        plot(0:0.01:30, sig);
        legend('Orginal Sig');
        subplot(7, 1, 2);
        plot(0:0.01:30, alphaSig);
        legend('Alpha Sig');
        subplot(7, 1, 3);
        plot(0:0.01:30, betaSig);
        legend('Beta Sig');
        subplot(7, 1, 4);
        plot(0:0.01:30, thetaSig);
        legend('Theta Sig');
        subplot(7, 1, 5);
        plot(0:0.01:30, deltaSig);
        legend('Delta Sig');
        subplot(7, 1, 6);
        plot(0:0.01:30, spiSig);
        legend('Spiha Sig');
        subplot(7, 1, 7);
        plot(0:0.01:30, sawSig);
        legend('Saw Sig');
        xlabel('Time [s]');
        break;
   end
   
   break;
end
