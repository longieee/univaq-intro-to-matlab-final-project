function w = fun(u,v,method)
    %FUN takes as input two vectors `u` and `v` and as output provides 
    % the vector `w` which contains in each entry the max between 
    % the same entry position of the two vectors.
    %   In the case the length of the 2 input vectors are different, the
    %   argument `method` will decide how to deal with the situation
    %   
    %   - If method="truncate", then the output's length is the length of
    %   the shorter vector
    %   - If method="fill", then the output's length is the length of the
    %   longer vector, and the missing part of the shorter vector is
    %   considered 0
    %
    %   Inputs:
    %       v1 - First input vector (row or column)
    %       v2 - Second input vector (row or column)
    %   Output:
    %       vector `w` as described above

    % Input validation
    if nargin < 2
        error('At least TWO input argument is required.');
    end

    if ~isvector(u)
        error('Input argument must be a vector, received %s', mat2str(u));
    end

    if ~isvector(v)
        error('Input argument must be a vector, received %s', mat2str(v));
    end

    % Provide default value for method argument
    if nargin < 3
        method="truncate";
    end
    % and then check its validity
    if method~="truncate" && method~="fill"
        error('Method must be one of {truncate, fill} Received %s', method);
    end

    % Main logic
    % Easy case: Same length
    if length(u) == length(v)
        w = max(u,v);
    % 2 vectors are not of the same length
    else
        if method=="truncate"
            min_length = min(length(u),length(v));
            w = max( ...
                u(1:min_length), ...
                v(1:min_length) ...
                );
        else
            [u2,v2] = extendVectors(u,v);
            w = max(u2,v2);
        end
    end
end
