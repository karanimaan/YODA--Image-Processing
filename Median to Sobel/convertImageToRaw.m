% Read the image
image = imread('handsmat.png');

% Convert the image to RGB format (if not already in RGB)
% if size(image, 3) ~= 3
%     error('Image must be in RGB format.');
% end

% Resize the image to match the required dimensions (256x256 pixels)
image_resized = imresize(image, [256, 256]);

% Convert the  values to binary (uint8 format)
binary_data = imbinarize(image_resized);

figure
imshowpair(image_resized, binary_data,'montage')

% Create the raw file path
raw_file = ['INPUT_IMAGE', '.raw'];

% Write the binary data to the raw file
fid = fopen(raw_file, 'wb');
fwrite(fid, binary_data', 'uint8');
fclose(fid);

