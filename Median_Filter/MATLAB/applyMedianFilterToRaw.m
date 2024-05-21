function filtered_raw_file = applyMedianFilterToRaw(raw_file)
    % Start overall timing
    overall_tic = tic;

    % Constants
    image_width = 256;
    image_height = 256;
    num_channels = 3;

    % Timing for reading the raw file
    read_tic = tic;
    fid = fopen(raw_file, 'rb');
    binary_data = fread(fid, 'uint8');
    fclose(fid);
    read_time = toc(read_tic);
    
    % Reshape the binary data to RGB format
    rgb_data = reshape(binary_data, [num_channels, image_width * image_height])';
    image_resized = reshape(rgb_data, [image_height, image_width, num_channels]);

    % Timing for applying the 3x3 median filter
    filter_tic = tic;
    filtered_image = zeros(size(image_resized), 'uint8');
    for channel = 1:num_channels
        filtered_image(:,:,channel) = medfilt2(image_resized(:,:,channel), [3 3]);
    end
    filter_time = toc(filter_tic);

    % Reshape the filtered image back to the binary format
    filtered_binary_data = reshape(filtered_image, [], num_channels)';

    % Timing for writing the filtered data to the new raw file
    write_tic = tic;
    [~, name, ~] = fileparts(raw_file);
    filtered_raw_file = [name, '_filtered.raw'];
    fid = fopen(filtered_raw_file, 'wb');
    fwrite(fid, filtered_binary_data, 'uint8');
    fclose(fid);
    write_time = toc(write_tic);

    % Stop overall timing
    overall_time = toc(overall_tic);

    % Print execution times
    fprintf('Time to read raw file: %.3f ms\n', read_time*1000);
    fprintf('Time to apply median filter: %.3f ms\n', filter_time*1000);
    fprintf('Time to write filtered raw file: %.3f ms\n', write_time*1000);
    fprintf('Overall execution time: %.3f ms\n', overall_time*1000);
end

