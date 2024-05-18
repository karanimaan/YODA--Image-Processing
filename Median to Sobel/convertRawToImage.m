function convertRawToImage(raw_path)
    % Read the raw file
    rgb_image = rawread(raw_path);
    png_file = "output.png";
    imwrite(rgb_image, png_file);
end

