function rleEncoded = rle(data)
    % Run-Length Encoding (RLE)
    % Input: data - 1D array of values
    % Output: rleEncoded - Encoded values and their counts
    
    % Find unique runs
    diffData = [true; diff(data(:)) ~= 0];
    values = data(diffData);
    counts = diff([find(diffData); length(data) + 1]);

    % Store encoded values and counts as a struct
    rleEncoded.values = values;
    rleEncoded.counts = counts;
end
