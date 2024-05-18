function convertRawToImage(raw_path)
    % Read the raw file
    rgb_image = rawread(raw_path);

    % Save the RGB image to a PNG file
    [~, name, ~] = fileparts(raw_path);
    png_file = [name, '.png'];
    imwrite(rgb_image, png_file);
end

