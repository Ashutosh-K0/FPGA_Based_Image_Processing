function data = rld(rleEncoded)
    % Run-Length Decoding (RLD)
    % Input: rleEncoded - Encoded values and counts (struct)
    % Output: data - Decoded original values
    
    data = repelem(rleEncoded.values, rleEncoded.counts);
end
