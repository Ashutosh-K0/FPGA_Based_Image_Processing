disp('📌 Loading RLE Encoded Features...');
load('D:\VITC\Assignments\Semester_6\FPGA PROJECT\Models\RLE_Encoded_Features.mat', 'rleEncoded');

disp('📌 Decoding Run-Length Encoded Data...');
decodedFeatures = rld(rleEncoded);  % Decode back to original format

% Verify correctness
if isequal(quantizedFeatures(:), decodedFeatures)
    disp('✅ RLE Encoding & Decoding Verified Successfully!');
else
    disp('⚠️ WARNING: Data mismatch after RLE decoding!');
end
