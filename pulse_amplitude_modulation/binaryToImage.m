function reconstructedRGBImage = binaryToImage(binaryArray, imHeight,imWidth)
    % Step 1: Reshape the binary array into a 3D array
    height = imHeight; width = imWidth;
    binaryArray = reshape(binaryArray, height, width, 24); % Assuming each pixel has 8 bits for each channel (R, G, B)
    
    % Step 2: Convert binary values back to decimal for each channel
    redChannel = bin2dec(binaryArray(:,:,1:8));
    greenChannel = bin2dec(binaryArray(:,:,9:16));
    blueChannel = bin2dec(binaryArray(:,:,17:24));
    
    % Step 3: Create a new RGB image using the reconstructed channels
    reconstructedRGBImage = cat(3, uint8(redChannel), uint8(greenChannel), uint8(blueChannel));
    
    % Display the reconstructed RGB image
    imshow(reconstructedRGBImage);
end