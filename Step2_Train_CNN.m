clc; clear; close all;

disp('📌 Loading Extracted Features for Training...');
load('D:\VITC\Assignments\Semester_6\FPGA PROJECT\SHO_Dataset\SHO_Features.mat', 'features', 'labels');

% Convert labels to categorical format
labels = categorical(labels);

% Split dataset into Training (80%) and Validation (20%)
[trainInd, valInd] = dividerand(size(features, 1), 0.8, 0.2);
XTrain = features(trainInd, :);
YTrain = labels(trainInd);
XValidation = features(valInd, :);
YValidation = labels(valInd);

disp('📌 Defining CNN Model for Feature-Based Classification...');

%% **Fully Connected Neural Network for Classification (No Convolutional Layers)**
layers = [
    featureInputLayer(size(XTrain, 2))  % Input Layer (Feature Vector)
    
    fullyConnectedLayer(128)  
    batchNormalizationLayer
    reluLayer
    dropoutLayer(0.3)

    fullyConnectedLayer(64)  
    batchNormalizationLayer
    reluLayer
    dropoutLayer(0.3)

    fullyConnectedLayer(4)  % 4 Output Classes (Glioma, Meningioma, Non-Tumor, Pituitary)
    softmaxLayer
    classificationLayer
];

%% **Define Training Options**
options = trainingOptions('adam', ...
    'MaxEpochs', 30, ...
    'InitialLearnRate', 0.0003, ...
    'MiniBatchSize', 16, ...
    'Plots', 'training-progress', ...
    'ValidationData', {XValidation, YValidation});

disp('📌 Training CNN Model Using SHO Features...');
cnn_model = trainNetwork(XTrain, YTrain, layers, options);

disp('✅ CNN Training Complete!');

%% **Saving the Trained Model**
save_path = 'D:\VITC\Assignments\Semester_6\FPGA PROJECT\Models\';

if ~exist(save_path, 'dir')
    mkdir(save_path);
end

save(fullfile(save_path, 'trained_CNN_Model_SHO.mat'), 'cnn_model');

disp(['✅ CNN Model (Using SHO Features) Saved Successfully in ', save_path]);
