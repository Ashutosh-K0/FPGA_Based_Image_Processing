clc; clear; close all;

disp('📌 Loading Trained CNN Model...');
load('D:\VITC\Assignments\Semester_6\FPGA PROJECT\Models\trained_CNN_Model_SHO.mat', 'cnn_model');

disp('📌 Loading Extracted Features & Image Paths for Testing...');
load('D:\VITC\Assignments\Semester_6\FPGA PROJECT\SHO_Dataset\SHO_Features.mat', 'features', 'labels', 'imagePaths');

% Convert labels to categorical format
labels = categorical(labels);

disp('📌 Classifying Testing Data Using SHO Features...');
predictedLabels = classify(cnn_model, features);
accuracy = sum(predictedLabels == labels) / numel(labels) * 100;
fprintf('✅ CNN Model Accuracy (Using SHO Features): %.2f%%\n', accuracy);

% Display Sample Predictions with Original MRI Images
figure;
perm = randperm(numel(labels), min(16, numel(labels))); % Select up to 16 random images for display
for i = 1:length(perm)
    subplot(4,4,i);
    
    % Read and display the corresponding original MRI image
    img = imread(imagePaths{perm(i)});
    img = imresize(img, [256, 256]);  % Resize for consistent display
    imshow(img);
    
    % Set title with predicted & actual labels
    title(sprintf('Pred: %s\nTrue: %s', string(predictedLabels(perm(i))), string(labels(perm(i)))), 'FontSize', 10);
end

disp('✅ Testing Complete! Visualization Done.');
