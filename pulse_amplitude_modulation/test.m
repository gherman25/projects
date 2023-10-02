% read in image
rgbImage = imread('IMG_2726.jpg'); 

% convert image to binary message
binaryString = imageToBinary(rgbImage);

% convert to 1s and -1s
for i = 1:length(binaryString)
    if binaryString(i) == 0
        binaryString(i) = -1;
    end
end

% run simulation
[~,~,~,output] = binaryPAMsim(length(binaryString),1,5,0.5,0,binaryString);

