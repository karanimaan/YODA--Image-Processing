function convertImageToMIF(imagePath, mifFilePath)
    % Read the image
    if endsWith(imagePath, '.png')
        img = imread(imagePath);
        img = rgb2gray(img); % Convert to grayscale if necessary
    elseif endsWith(imagePath, '.pgm')
        img = imread(imagePath);
    else
        error('Unsupported image format. Only PNG and PGM formats are supported.');
    end
    
    % Convert image to uint8 if necessary
    if ~isa(img, 'uint8')
        img = uint8(img);
    end
    
    % Get image size
    [height, width] = size(img);
    
    % Open MIF file for writing
    fid = fopen(mifFilePath, 'w');
    if fid == -1
        error('Failed to open MIF file for writing.');
    end
    
    % Write MIF file header
    fprintf(fid, 'DEPTH = %d;\n', width * height);
    fprintf(fid, 'WIDTH = 8;\n');
    fprintf(fid, 'ADDRESS_RADIX = HEX;\n');
    fprintf(fid, 'DATA_RADIX = HEX;\n');
    fprintf(fid, 'CONTENT\n');
    fprintf(fid, 'BEGIN\n');
    
    % Write pixel values to MIF file
    address = 0;
    for y = 1:height
        for x = 1:width
            fprintf(fid, '%X : %X;\n', address, img(y, x));
            address = address + 1;
        end
    end
    
    % Close MIF file
    fclose(fid);
    
    disp('Conversion completed successfully.');
end
