function convertImageToRaw(inputImageFile, outputRawFile)
    % Read the input image
    if endsWith(inputImageFile, '.png')
        imageData = imread(inputImageFile);
    elseif endsWith(inputImageFile, '.pgm')
        imageData = imread(inputImageFile);
    else
        error('Unsupported image format. Please provide a PNG or PGM file.');
    end

    % Convert image data to uint8
    imageData = uint8(imageData);

    % Write the image data to a raw file
    fid = fopen(outputRawFile, 'wb');
    fwrite(fid, imageData, 'uint8');
    fclose(fid);

    disp(['Image saved as ' outputRawFile]);
end
