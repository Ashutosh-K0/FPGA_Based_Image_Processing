clc; clear; close all;

disp('📌 Loading Preprocessed Images...');
dataset_path = 'D:\VITC\Assignments\Semester_6\FPGA PROJECT\Processed_Output';

% Load images
imds = imageDatastore(dataset_path, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');

numImages = numel(imds.Files);
features = [];
labels = [];
imagePaths = imds.Files;  % Store image file paths

disp('📌 Extracting Features Using Selfish Herd Optimization (SHO)...');

for i = 1:numImages
    img = readimage(imds, i);
    img = imresize(img, [256, 256]); % Resize if needed
    
    % Convert to grayscale if not already
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    % 📌 Now Correctly Calls the SHO Feature Extraction Function
    extracted_features = SHO_feature_extraction(img);
    
    % Store features and corresponding label
    features = [features; extracted_features(:)']; % Flatten feature map
    labels = [labels; imds.Labels(i)];
    
    if mod(i, 50) == 0
        fprintf('Processed %d/%d images...\n', i, numImages);
    end
end

disp('✅ Feature Extraction Complete!');

%% **Save Extracted Features & Image Paths**
save_path = 'D:\VITC\Assignments\Semester_6\FPGA PROJECT\SHO_Dataset\';
if ~exist(save_path, 'dir')
    mkdir(save_path);  % Create the folder if it doesn’t exist
end

% Now save `imagePaths` along with features & labels
save(fullfile(save_path, 'SHO_Features.mat'), 'features', 'labels', 'imagePaths');

disp(['✅ SHO-Processed Dataset Saved in: ', save_path]);
