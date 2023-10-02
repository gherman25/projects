function binaryArray = imageToBinary(rgbImage)
    % Step 1: Read the RGB image
    
    % Get the dimensions of the image
    [height, width, ~] = size(rgbImage);
    
    % Initialize an empty binary string
    binaryString = '';
    
    % Step 2: Convert RGB values to binary and concatenate to the binary string
    for i = 1:height
        for j = 1:width
            % Get the RGB values for the current pixel
            pixel = rgbImage(i, j, :);
            
            % Convert RGB values to binary (8 bits for each channel)
            redBinary = dec2bin(pixel(1), 8);
            greenBinary = dec2bin(pixel(2), 8);
            blueBinary = dec2bin(pixel(3), 8);
            
            % Concatenate the binary values to the binary string
            binaryString = [binaryString, redBinary, greenBinary, blueBinary];
        end
    end

    % convert binaryString to array

    % Initialize an empty array for ones and zeros
    binaryArray = zeros(1, numel(binaryString));
    
    % Convert the binary string to an array of ones and zeros
    for i = 1:numel(binaryString)
        if binaryString(i) == '1'
            binaryArray(i) = 1;
        end
    end
                
end