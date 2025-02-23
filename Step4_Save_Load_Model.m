clc; clear; close all;

%% **Saving the Trained Model**
disp('📌 Saving the trained CNN model...');
load('trained_CNN_Model.mat', 'cnn_model'); % Load model from previous training
save('trained_CNN_Model.mat', 'cnn_model');
disp('✅ CNN Model Saved Successfully!');

%% **Loading the Trained Model**
disp('📌 Loading the trained CNN model...');
load('trained_CNN_Model.mat', 'cnn_model');
disp('✅ CNN Model Loaded Successfully!');
