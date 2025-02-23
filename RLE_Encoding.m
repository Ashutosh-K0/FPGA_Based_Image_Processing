clc; clear; close all;

disp('📌 Loading SHO Extracted Features...');
load('D:\VITC\Assignments\Semester_6\FPGA PROJECT\SHO_Dataset\SHO_Features.mat', 'features', 'labels');

% ✅ Quantize Features to Reduce Unique Values
disp('📌 Reducing Unique Symbols (Feature Quantization)...');
quantizedFeatures = round(features * 100) / 100; % Round to 2 decimal places

disp('📌 Applying Run-Length Encoding (RLE)...');
rleEncoded = rle(quantizedFeatures(:));  % Now works correctly!

% ✅ Save Compressed Data
save('D:\VITC\Assignments\Semester_6\FPGA PROJECT\Models\RLE_Encoded_Features.mat', ...
    'rleEncoded', 'labels');

disp('✅ RLE Encoding Completed! Encoded Data Saved.');
