function raw_file = convertImageToRaw(image_path)
    % Read the image
    image = imread(image_path);

    % Convert the image to RGB format (if not already in RGB)
    if size(image, 3) ~= 3
        error('Image must be in RGB format.');
    end

    % Resize the image to match the required dimensions (256x256 pixels)
    image_resized = imresize(image, [256, 256]);

    % Convert the RGB values to binary (uint8 format)
    binary_data = reshape(image_resized, [], 3);

    % Create the raw file path
    [~, name, ~] = fileparts(image_path);
    raw_file = [name, '.raw'];

    % Write the binary data to the raw file
    fid = fopen(raw_file, 'wb');
    fwrite(fid, binary_data', 'uint8');
    fclose(fid);
end
