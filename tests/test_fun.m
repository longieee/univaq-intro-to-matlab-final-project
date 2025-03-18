function test_fun()
    % TEST_FUN Unit tests for the function `fun.m`.
    %
    % This function runs multiple test cases to verify the correctness
    % of `fun.m` using different input vectors and methods.

    % Test 1: Equal length row vectors
    u = [1, 3, 5];
    v = [2, 2, 6];
    expected = [2, 3, 6];
    assert(isequal(fun(u, v), expected), 'Test 1 failed');

    % Test 2: Equal length column vectors
    u = [1; 3; 5];
    v = [2; 2; 6];
    expected = [2; 3; 6];
    assert(isequal(fun(u, v), expected), 'Test 2 failed');

    % Test 3: Different lengths (truncate)
    u = [1, 3, 5];
    v = [2, 2];
    expected = [2, 3];
    assert(isequal(fun(u, v, "truncate"), expected), 'Test 3 failed');

    % Test 4: Different lengths (fill)
    u = [1, 3, 5];
    v = [2, 2];
    expected = [2, 3, 5]; % Since v gets extended with a zero
    assert(isequal(fun(u, v, "fill"), expected), 'Test 4 failed');

    % Test 5: Different lengths (fill, column vectors)
    u = [1; 3; 5];
    v = [2; 2];
    expected = [2; 3; 5]; % Since v gets extended with a zero
    assert(isequal(fun(u, v, "fill"), expected), 'Test 5 failed');

    % Test 6: Input validation (non-vector input)
    try
        fun([1 2; 3 4], [5 6]); % Non-vector input
        error('Test 6 failed: Expected an error for non-vector input');
    catch ME
        assert(contains(ME.message, 'Input argument must be a vector'), 'Test 6 failed');
    end

    % Test 7: Invalid method argument
    try
        fun([1, 2, 3], [4, 5, 6], "wrong_method");
        error('Test 7 failed: Expected an error for invalid method argument');
    catch ME
        assert(contains(ME.message, 'Method must be one of {truncate, fill}'), 'Test 7 failed');
    end

    % Test 8: Single-element vectors
    u = [5];
    v = [10];
    expected = [10];
    assert(isequal(fun(u, v), expected), 'Test 8 failed');

    % Test 9: Zero-length vectors
    u = [];
    v = [1, 2, 3];
    expected = [1, 2, 3]; % Since u gets extended with zeros
    assert(isequal(fun(u, v, "fill"), expected), 'Test 9 failed');

    fprintf('All tests passed!\n');
end
