function convertRawToPng(raw_file, width, height, output_file)
    % Open the raw file for reading
    fid = fopen(raw_file, 'rb');
    
    if fid == -1
        error('Error: Could not open the input raw file.');
    end
    
    % Read the raw pixel data
    raw_data = fread(fid, [width, height], 'uint8=>uint8');
    
    % Close the file
    fclose(fid);
    
    % Transpose the data to get the correct orientation
    raw_data = raw_data';
    
    % Create an image from the raw data
    img = uint8(raw_data);
    
    % Save the image as a PNG file
    imwrite(img, output_file);
end
