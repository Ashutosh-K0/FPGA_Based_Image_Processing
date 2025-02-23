% Define input and output folders
inputFolder = 'D:\VITC\Assignments\Semester_6\FPGA PROJECT\Training'; % Path to your input folder containing the original images
outputFolder = 'D:\VITC\Assignments\Semester_6\FPGA PROJECT\Processed_Output'; % Path to your output folder for grayscale images

% Create output folder if it doesn't exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Define subfolders
subfolders = {'Glioma', 'Meningioma', 'NonTumor', 'Pituitary'};

% Initialize an array to store image file paths
imageFiles = struct('file', {}, 'subfolder', {});

% Loop through each subfolder to collect image paths and their corresponding subfolders
for i = 1:length(subfolders)
    folderPath = fullfile(inputFolder, subfolders{i});
    files = dir(fullfile(folderPath, '*.*'));
    files = files(~[files.isdir]);
    for j = 1:length(files)
        imageFiles(end+1).file = fullfile(folderPath, files(j).name); %#ok<SAGROW>
        imageFiles(end).subfolder = subfolders{i};
    end
end

% Randomly select 500 images from the collected paths
selectedIndices = randperm(length(imageFiles), 500);
selectedFiles = imageFiles(selectedIndices);

% Loop through selected images, convert to grayscale, and save
for k = 1:length(selectedFiles)
    % Read the image
    img = imread(selectedFiles(k).file);
    
    % Convert to grayscale
    grayImg = im2gray(img);
    
    % Create corresponding subfolder in output folder
    outputSubfolder = fullfile(outputFolder, selectedFiles(k).subfolder);
    if ~exist(outputSubfolder, 'dir')
        mkdir(outputSubfolder);
    end
    
    % Save the grayscale image to the corresponding subfolder
    [~, name, ext] = fileparts(selectedFiles(k).file);
    outputFileName = fullfile(outputSubfolder, [name, '_grayscale', ext]);
    imwrite(grayImg, outputFileName);
    
    % Display progress
    fprintf('Converted and saved: %s\n', outputFileName);
end

fprintf('All images have been converted to grayscale.\n');
