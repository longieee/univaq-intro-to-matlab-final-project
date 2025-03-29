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

    % Validate inputs - consider empty arrays as valid vectors
    if (~isempty(v1) && ~isvector(v1)) || (~isempty(v2) && ~isvector(v2))
        error('Both inputs must be vectors.');
    end
    
    % Determine the orientation (row or column) for empty vectors
    if isempty(v1)
        % If v1 is empty, use the orientation of v2, or default to row
        if isrow(v2)
            v1 = zeros(1, 0);  % Empty row vector
        elseif iscolumn(v2)
            v1 = zeros(0, 1);  % Empty column vector
        else
            v1 = zeros(1, 0);  % Default to row vector
        end
    end
    
    if isempty(v2)
        % If v2 is empty, use the orientation of v1, or default to row
        if isrow(v1)
            v2 = zeros(1, 0);
        elseif iscolumn(v1)
            v2 = zeros(0, 1);
        else
            v2 = zeros(1, 0);
        end
    end
    
    % Get lengths
    len1 = length(v1);
    len2 = length(v2);
    maxLen = max(len1, len2);

    % Extend the shorter vector while maintaining shape
    if len1 < maxLen
        if isrow(v1) || (isempty(v1) && isrow(v2))
            v1(1, maxLen) = 0;  % Extend row vector
        else
            v1(maxLen, 1) = 0;  % Extend column vector
        end
    end
    
    if len2 < maxLen
        if isrow(v2) || (isempty(v2) && isrow(v1))
            v2(1, maxLen) = 0;  % Extend row vector
        else
            v2(maxLen, 1) = 0;  % Extend column vector
        end
    end
end