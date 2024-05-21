function convertRawToImage(raw_file, output_file)
    % Read the raw file
    fid = fopen(raw_file, 'rb');
    binary_data = fread(fid, 'uint8');
    fclose(fid);

    % Reshape the binary data to RGB format
    num_pixels = numel(binary_data) / 3;
    rgb_data = reshape(binary_data, [3, num_pixels])';

    % Reshape the RGB data to match the required dimensions (256x256 pixels)
    image_resized = reshape(rgb_data, [256, 256, 3]);

    % Convert the RGB data to uint8 format
    rgb_image = uint8(image_resized);

    % Save the RGB image to a PNG file
    imwrite(rgb_image, output_file);
end

