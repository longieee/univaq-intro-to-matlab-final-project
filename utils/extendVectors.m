function [v1, v2] = extendVectors(v1, v2)
    % EXTENDVECTORS Extends the shorter vector to match the longer one.
    %
    %   [v1, v2] = EXTENDVECTORS(v1, v2) takes two vectors and extends the 
    %   shorter one by padding with zeros to match the length of the longer one.
    %   The function preserves the original orientation (row or column).
    %
    %   Inputs:
    %       v1 - First input vector (row or column)
    %       v2 - Second input vector (row or column)
    %
    %   Outputs:
    %       v1 - First vector, extended if necessary
    %       v2 - Second vector, extended if necessary
    %
    %   Example usage:
    %       v1 = [1, 2, 3]; 
    %       v2 = [4, 5, 6, 7, 8]; 
    %       [v1_ext, v2_ext] = extendVectors(v1, v2);
    %       % v1_ext: [1 2 3 0 0], v2_ext: [4 5 6 7 8]
    %
    %       v1 = [1; 2]; 
    %       v2 = [3; 4; 5; 6]; 
    %       [v1_ext, v2_ext] = extendVectors(v1, v2);
    %       % v1_ext: [1; 2; 0; 0], v2_ext: [3; 4; 5; 6]

    % Validate inputs
    if ~isvector(v1) || ~isvector(v2)
        error('Both inputs must be vectors.');
    end
    
    % Get lengths
    len1 = length(v1);
    len2 = length(v2);
    maxLen = max(len1, len2);

    % Extend the shorter vector while maintaining shape
    if len1 < maxLen
        v1(maxLen) = 0; % MATLAB automatically extends with zeros
    end
    if len2 < maxLen
        v2(maxLen) = 0;
    end
end
