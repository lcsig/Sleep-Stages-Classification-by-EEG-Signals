function labelName = getLabel(folderPath, fileNameNumber, currentSecond)
%GETLABEL A function to get the labels
%   It will read the fileName and return the label for the specific window
    
    fileNames = dir(folderPath);
    for i=1:length(fileNames)
        if contains(fileNames(i).name, num2str(fileNameNumber)) && contains(fileNames(i).name, '.csv')
            label = nan;
            x = readtable(strcat(folderPath,"/",fileNames(i).name), 'Format','%d %d %s');
            
            for d=size(x, 1):-1:1
                currentTime = x{d, 1};
                if currentSecond >= currentTime
                   label = x{d, 3};
                   label = label{1};
                   
                   if label == 'R'
                       label = 5;
                   elseif label == 'W'
                       label = 6;
                   elseif label == '1'
                       label = 1;
                   elseif label == '2'
                       label = 2;
                   elseif label == '3'
                       label = 3;
                   elseif label == '4'
                       label = 4;
                   else % if label == '?' || label == 'Movement time'
                       label = 7;
                   end
                   
                   break;
                end
            end
            
            if (isnan(label))
                error('[!] Coud not find the label! ' + strcat("File#", fileNameNumber, " -- ", "Sec#", string(currentSecond)));
            end
            labelName = label;
            break;
        end
    end
   
end

