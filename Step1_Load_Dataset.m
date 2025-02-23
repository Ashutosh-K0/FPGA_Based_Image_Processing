clc; clear; close all;

disp('📌 Loading dataset...');

% Define dataset path (where grayscale images are stored)
dataset_path = 'D:\VITC\Assignments\Semester_6\FPGA PROJECT\Processed_Output';

% Load dataset using imageDatastore
imds = imageDatastore(dataset_path, ...
    'IncludeSubfolders', true, ...
    'LabelSource', 'foldernames');  % Automatically assigns labels based on folder names

% Display number of images per category
countEachLabel(imds)

% Display some images with their labels
figure;
perm = randperm(numel(imds.Files), 16); % Select 16 random images
for i = 1:16
    subplot(4,4,i);
    img = readimage(imds, perm(i));
    imshow(img);
    title(string(imds.Labels(perm(i))));
end

disp('✅ Dataset Loaded & Verified Successfully!');
