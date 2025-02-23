clc; clear; close all;

disp('📌 Loading SHO Extracted Features...');
load('D:\VITC\Assignments\Semester_6\FPGA PROJECT\SHO_Dataset\SHO_Features.mat', 'features', 'labels');

% ✅ Reduce unique values (Quantization)
disp('📌 Reducing Unique Symbols (Feature Quantization)...');
quantizedFeatures = round(features * 100) / 100; % Round to 2 decimal places

% ✅ Compute Frequencies
disp('📌 Computing Symbol Frequencies...');
[uniqueVals, ~, indices] = unique(quantizedFeatures(:));
freq = accumarray(indices, 1);

% ✅ Keep only top 500 most frequent values
N = 500;
[sortedFreq, sortIdx] = sort(freq, 'descend');
topSymbols = uniqueVals(sortIdx(1:min(N, length(sortedFreq))));
topFreqs = sortedFreq(1:min(N, length(sortedFreq)));

% ✅ Create Huffman Dictionary
disp('📌 Creating Optimized Huffman Dictionary...');
huffmanDict = huffmandict(topSymbols, topFreqs / sum(topFreqs));

% ✅ Encode Features (With Parallel Processing)
disp('📌 Encoding Features Using Huffman...');
flattenedFeatures = quantizedFeatures(:);
parfor i = 1:length(flattenedFeatures)
    huffmanEncoded{i} = huffmanenco(flattenedFeatures(i), huffmanDict);
end

% ✅ Save Huffman Encoded Data
save('D:\VITC\Assignments\Semester_6\FPGA PROJECT\Models\Huffman_Encoded_Features.mat', ...
    'huffmanEncoded', 'huffmanDict', 'labels');

disp('✅ Huffman Encoding Completed! Encoded Data Saved.');
